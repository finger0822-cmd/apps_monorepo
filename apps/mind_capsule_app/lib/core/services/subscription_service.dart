import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

/// 無料プランの制限（AI 月間回数・期間選択）
class SubscriptionLimits {
  static const int freeAiMonthlyLimit = 3;
  static const List<int> freePeriodDays = [7, 30];
  static const List<int> premiumPeriodDays = [7, 30, 90, 0]; // 0 = 全期間
}

/// サブスク状態（RevenueCat 連携）
class SubscriptionState {
  const SubscriptionState({
    this.isPremium = false,
    this.aiUsedThisMonth = 0,
  });

  final bool isPremium;
  final int aiUsedThisMonth;

  bool get canUseAi =>
      isPremium || aiUsedThisMonth < SubscriptionLimits.freeAiMonthlyLimit;

  List<int> get availablePeriodDays => isPremium
      ? SubscriptionLimits.premiumPeriodDays
      : SubscriptionLimits.freePeriodDays;

  bool canUsePeriod(int days) => availablePeriodDays.contains(days);
}

/// サブスクサービス（RevenueCat）
class SubscriptionNotifier extends AsyncNotifier<SubscriptionState> {
  /// 本番は --dart-define=REVENUECAT_API_KEY=xxx で渡す。未設定時は開発用テストキー。
  static const _apiKey = String.fromEnvironment(
    'REVENUECAT_API_KEY',
    defaultValue: 'test_cuiyISZDuUVINoLkJpuIZOFfNcY',
  );
  static const _entitlementId = 'MindCapsule Pro';

  @override
  Future<SubscriptionState> build() async {
    if (_apiKey.isEmpty) {
      return const SubscriptionState();
    }
    await Purchases.configure(PurchasesConfiguration(_apiKey));
    return _stateFromCustomerInfo(await Purchases.getCustomerInfo());
  }

  SubscriptionState _stateFromCustomerInfo(CustomerInfo info) {
    final isPremium =
        info.entitlements.active[_entitlementId] != null;
    final current = state.valueOrNull;
    return SubscriptionState(
      isPremium: isPremium,
      aiUsedThisMonth: current?.aiUsedThisMonth ?? 0,
    );
  }

  Future<void> incrementAiUsage() async {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncData(SubscriptionState(
      isPremium: current.isPremium,
      aiUsedThisMonth: current.aiUsedThisMonth + 1,
    ));
  }

  Future<void> reload() async {
    final previous = state.valueOrNull;
    state = const AsyncLoading();
    try {
      final info = await Purchases.getCustomerInfo();
      final next = _stateFromCustomerInfo(info);
      state = AsyncData(SubscriptionState(
        isPremium: next.isPremium,
        aiUsedThisMonth: previous?.aiUsedThisMonth ?? next.aiUsedThisMonth,
      ));
    } catch (_) {
      rethrow;
    }
  }

  /// 月額プラン購入
  Future<void> purchaseMonthly() async {
    final offerings = await Purchases.getOfferings();
    final package = offerings.current?.monthly;
    if (package == null) return;
    final result = await Purchases.purchase(PurchaseParams.package(package));
    state = AsyncData(_stateFromCustomerInfo(result.customerInfo));
  }

  /// 年額プラン購入
  Future<void> purchaseYearly() async {
    final offerings = await Purchases.getOfferings();
    final package = offerings.current?.annual;
    if (package == null) return;
    final result = await Purchases.purchase(PurchaseParams.package(package));
    state = AsyncData(_stateFromCustomerInfo(result.customerInfo));
  }

  /// 購入の復元
  Future<void> restorePurchases() async {
    final info = await Purchases.restorePurchases();
    state = AsyncData(_stateFromCustomerInfo(info));
  }
}

final subscriptionProvider =
    AsyncNotifierProvider<SubscriptionNotifier, SubscriptionState>(
        SubscriptionNotifier.new);
