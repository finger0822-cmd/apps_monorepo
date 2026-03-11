import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/entry_repository.dart';
import '../providers/app_providers.dart';

/// サブスクリプションの制限定数
class SubscriptionLimits {
  static const int freeAiMonthlyLimit = 3;
  static const int freeCapsuleLimit = 3;
  static const List<int> freePeriodDays = [7, 30];
  static const List<int> premiumPeriodDays = [7, 30, 90, 0]; // 0 = 全期間
}

/// サブスク状態
class SubscriptionState {
  const SubscriptionState({
    this.isPremium = false,
    this.aiUsedThisMonth = 0,
    this.capsuleCount = 0,
  });

  final bool isPremium;
  final int aiUsedThisMonth;
  final int capsuleCount;

  bool get canUseAi =>
      isPremium || aiUsedThisMonth < SubscriptionLimits.freeAiMonthlyLimit;

  bool get canAddCapsule =>
      isPremium || capsuleCount < SubscriptionLimits.freeCapsuleLimit;

  List<int> get availablePeriodDays => isPremium
      ? SubscriptionLimits.premiumPeriodDays
      : SubscriptionLimits.freePeriodDays;

  bool canUsePeriod(int days) => availablePeriodDays.contains(days);
}

/// サブスクサービス
class SubscriptionNotifier extends AsyncNotifier<SubscriptionState> {
  @override
  Future<SubscriptionState> build() async {
    final repo = ref.read(entryRepositoryProvider);
    return _loadState(repo);
  }

  Future<SubscriptionState> _loadState(EntryRepository repo) async {
    final allEntries = await repo.getAll();
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);
    final aiUsed = allEntries
        .where((e) => e.aiFeedbackLoaded && e.createdAt.isAfter(monthStart))
        .length;

    return SubscriptionState(
      isPremium: false, // TODO: RevenueCat連携後に差し替え
      aiUsedThisMonth: aiUsed,
      capsuleCount: 0,
    );
  }

  Future<void> incrementAiUsage() async {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncData(SubscriptionState(
      isPremium: current.isPremium,
      aiUsedThisMonth: current.aiUsedThisMonth + 1,
      capsuleCount: current.capsuleCount,
    ));
  }

  Future<void> incrementCapsuleCount() async {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncData(SubscriptionState(
      isPremium: current.isPremium,
      aiUsedThisMonth: current.aiUsedThisMonth,
      capsuleCount: current.capsuleCount + 1,
    ));
  }

  Future<void> reload() async {
    state = const AsyncLoading();
    final repo = ref.read(entryRepositoryProvider);
    state = AsyncData(await _loadState(repo));
  }
}

final subscriptionProvider =
    AsyncNotifierProvider<SubscriptionNotifier, SubscriptionState>(
        SubscriptionNotifier.new);
