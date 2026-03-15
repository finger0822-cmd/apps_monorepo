/// アプリ全体で使用する定数（APIエンドポイント等）
abstract final class AppConstants {
  AppConstants._();

  /// Claude API エンドポイント
  static const String claudeApiBaseUrl =
      'https://api.anthropic.com/v1/messages';

  /// 通知チャネルID（Android）
  static const String notificationChannelId = 'mind_capsule_channel';

  /// 通知チャネル名（Android）
  static const String notificationChannelName = 'MindCapsule';

  /// デフォルトタイムゾーン
  static const String defaultTimezone = 'Asia/Tokyo';
}
