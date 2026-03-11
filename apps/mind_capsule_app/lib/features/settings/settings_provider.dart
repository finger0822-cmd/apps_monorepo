import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/storage/api_key_storage.dart';

const _keyLanguage = 'mind_capsule_language';
const _keyNotificationsEnabled = 'mind_capsule_notifications_enabled';

/// 設定状態（言語・通知ON/OFF）
class SettingsState {
  const SettingsState({
    this.language = 'ja',
    this.notificationsEnabled = true,
  });

  final String language;
  final bool notificationsEnabled;

  SettingsState copyWith({String? language, bool? notificationsEnabled}) {
    return SettingsState(
      language: language ?? this.language,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }
}

/// 設定を永続化する Notifier
class SettingsNotifier extends AsyncNotifier<SettingsState> {
  @override
  Future<SettingsState> build() async {
    final prefs = await SharedPreferences.getInstance();
    final lang = prefs.getString(_keyLanguage) ?? 'ja';
    final notifications =
        prefs.getBool(_keyNotificationsEnabled) ?? true;
    return SettingsState(language: lang, notificationsEnabled: notifications);
  }

  Future<void> setLanguage(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLanguage, value);
    state = AsyncData((state.value ?? const SettingsState()).copyWith(language: value));
  }

  Future<void> setNotificationsEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyNotificationsEnabled, value);
    state = AsyncData((state.value ?? const SettingsState()).copyWith(notificationsEnabled: value));
  }
}

final settingsProvider =
    AsyncNotifierProvider<SettingsNotifier, SettingsState>(SettingsNotifier.new);

/// 現在の表示言語（'ja' or 'en'）
final appLanguageProvider = Provider<String>((ref) {
  final settings = ref.watch(settingsProvider);
  return settings.valueOrNull?.language ?? 'ja';
});

/// API キーの取得・保存用
final apiKeyAsyncProvider =
    AsyncNotifierProvider<ApiKeyAsyncNotifier, String?>(ApiKeyAsyncNotifier.new);

class ApiKeyAsyncNotifier extends AsyncNotifier<String?> {
  @override
  Future<String?> build() async {
    final storage = ref.read(apiKeyStorageProvider);
    return storage.getApiKey();
  }

  Future<void> save(String key) async {
    final storage = ref.read(apiKeyStorageProvider);
    await storage.setApiKey(key.trim());
    state = AsyncData(key.trim());
  }

  Future<void> delete() async {
    final storage = ref.read(apiKeyStorageProvider);
    await storage.deleteApiKey();
    state = const AsyncData(null);
  }
}

final apiKeyStorageProvider = Provider<ApiKeyStorage>((ref) => ApiKeyStorageImpl());
