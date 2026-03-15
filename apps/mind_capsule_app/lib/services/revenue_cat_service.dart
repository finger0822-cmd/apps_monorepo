import 'package:purchases_flutter/purchases_flutter.dart';

class RevenueCatService {
  /// 本番は --dart-define=REVENUECAT_API_KEY=xxx で渡す。未設定時は開発用テストキー。
  static const String _apiKey = String.fromEnvironment(
    'REVENUECAT_API_KEY',
    defaultValue: 'test_cuiyISZDuUVINoLkJpuIZOFfNcY',
  );

  static Future<void> initialize() async {
    if (_apiKey.isEmpty) return;
    try {
      await Purchases.setLogLevel(LogLevel.debug);
      await Purchases.configure(
        PurchasesConfiguration(_apiKey)..appUserID = null,
      );
      print('✅ RevenueCat initialized');
    } catch (e) {
      print('Error: $e');
    }
  }

  static Future<bool> isSubscriptionActive() async {
    try {
      final info = await Purchases.getCustomerInfo();
      return info.activeSubscriptions.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}
