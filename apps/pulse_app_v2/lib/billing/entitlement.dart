/// アプリ内で参照する課金権利。isPro / trialActive / expiresAt / source を一元管理。
/// domain 層は import しない。Flutter / in_app_purchase に依存しない plain Dart。
enum EntitlementSource {
  none,
  purchase,
  restore,
  trial,
}

class Entitlement {
  const Entitlement({
    required this.isPro,
    required this.trialActive,
    this.expiresAt,
    required this.source,
  });

  final bool isPro;
  final bool trialActive;
  final DateTime? expiresAt;
  final EntitlementSource source;

  static const Entitlement free = Entitlement(
    isPro: false,
    trialActive: false,
    expiresAt: null,
    source: EntitlementSource.none,
  );

  Entitlement copyWith({
    bool? isPro,
    bool? trialActive,
    DateTime? expiresAt,
    EntitlementSource? source,
  }) {
    return Entitlement(
      isPro: isPro ?? this.isPro,
      trialActive: trialActive ?? this.trialActive,
      expiresAt: expiresAt ?? this.expiresAt,
      source: source ?? this.source,
    );
  }
}
