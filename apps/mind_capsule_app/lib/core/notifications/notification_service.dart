import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../domain/models/mind_entry.dart';
import '../constants/app_constants.dart';

/// タイムカプセル開封通知をスケジュールするサービス
class NotificationService {
  NotificationService._();

  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  static bool _initialized = false;
  static final Set<String> _loggedKeys = <String>{};

  static void _logOnce(String key, String message) {
    if (_loggedKeys.add(key)) {
      debugPrint(message);
    }
  }

  static bool get _isDesktopPlatform {
    if (kIsWeb) return false;
    return Platform.isWindows || Platform.isLinux || Platform.isMacOS;
  }

  /// 通知プラグインを初期化（タイムゾーン設定含む）
  static Future<void> initialize() async {
    if (_initialized) return;

    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation(AppConstants.defaultTimezone));

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    _initialized = true;
  }

  static void _onNotificationTapped(NotificationResponse response) {
    // タップ時はアプリを開くだけ（開封処理は起動時の openDueCapsules で行う）
  }

  /// 通知権限をリクエスト
  static Future<bool> requestPermissions() async {
    final android = await _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
    final ios = await _notifications
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);
    return android ?? ios ?? false;
  }

  /// タイムカプセル1件分の通知をスケジュール。
  /// 開封済み（openedAt != null）の場合は何もしない。
  static Future<void> scheduleForCapsule(MindEntry entry) async {
    if (entry.openedAt != null || entry.openOn == null) return;
    if (_isDesktopPlatform) {
      _logOnce(
        'notificationsSkippedDesktop',
        '[NotificationService] デスクトップでは通知をスキップします',
      );
      return;
    }

    final openOn = entry.openOn!;
    final notificationTime = tz.TZDateTime.from(openOn, tz.local);
    if (notificationTime.isBefore(tz.TZDateTime.now(tz.local))) {
      return;
    }

    // 通知文: 「{createdAt}の自分からのメッセージが届きました」
    final createdAtStr = DateFormat('yyyy/M/d').format(entry.createdAt);
    final body = '$createdAtStrの自分からのメッセージが届きました';

    final notificationId = entry.id;
    const androidDetails = AndroidNotificationDetails(
      AppConstants.notificationChannelId,
      AppConstants.notificationChannelName,
      channelDescription: 'タイムカプセル開封通知',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.zonedSchedule(
      notificationId,
      'MindCapsule',
      body,
      notificationTime,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  /// 指定エントリの通知をキャンセル
  static Future<void> cancelForCapsule(MindEntry entry) async {
    if (!_initialized) return;
    await _notifications.cancel(entry.id);
  }

  /// 未開封カプセル一覧に対して通知を再スケジュール（起動時などに呼ぶ）
  static Future<void> rescheduleAll(List<MindEntry> sealedCapsules) async {
    for (final entry in sealedCapsules) {
      await cancelForCapsule(entry);
      await scheduleForCapsule(entry);
    }
  }
}
