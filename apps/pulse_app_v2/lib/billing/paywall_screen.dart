import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import 'billing_providers.dart';
import 'product_ids.dart';
import '../core/theme/app_theme.dart';

/// Paywall 文言（後で i18n 化するときはここを差し替え）。
class PaywallStrings {
  PaywallStrings._();

  static const String title = 'Pro を利用する';
  static const String description =
      'AI要約や高度な分析など、Pro限定機能をご利用いただけます。';
  static const String close = '閉じる';
  static const String restore = '購入を復元';
  static const String purchaseSuccess = '復元しました';
  static const String purchaseError = '処理に失敗しました';
  static const String recommended = 'おすすめ';
}

class PaywallScreen extends ConsumerStatefulWidget {
  const PaywallScreen({super.key});

  @override
  ConsumerState<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends ConsumerState<PaywallScreen> {
  List<ProductDetails> _products = [];
  bool _loading = true;
  bool _actionLoading = false;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final repo = ref.read(billingRepositoryProvider);
    final list = await repo.fetchProducts();
    if (mounted) setState(() => _products = list..sort((a, b) => a.id.compareTo(b.id)));
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _onPurchase(ProductDetails product) async {
    setState(() => _actionLoading = true);
    final repo = ref.read(billingRepositoryProvider);
    final ok = await repo.purchase(product.id);
    if (mounted) setState(() => _actionLoading = false);
    if (!mounted) return;
    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(PaywallStrings.purchaseError),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
    // 購入完了は purchaseStream で届く。ユーザーが閉じるを押したときに invalidate + pop する。
  }

  Future<void> _onRestore() async {
    setState(() => _actionLoading = true);
    final repo = ref.read(billingRepositoryProvider);
    final ok = await repo.restore();
    if (mounted) setState(() => _actionLoading = false);
    if (!mounted) return;
    ref.invalidate(entitlementProvider);
    if (ok) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(PaywallStrings.purchaseSuccess),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _onClose() {
    ref.invalidate(entitlementProvider);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.darkTheme,
      child: Scaffold(
        backgroundColor: AppTheme.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: _actionLoading ? null : _onClose,
          ),
        ),
        body: SafeArea(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 16),
                      Text(
                        PaywallStrings.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textMain,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        PaywallStrings.description,
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppTheme.textMain,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 32),
                      ..._products.map((p) {
                        final isYearly =
                            p.id == BillingProductIds.subscriptionProYearly;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              if (isYearly)
                                Positioned(
                                  top: -8,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF4A4A4A),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      PaywallStrings.recommended,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppTheme.textMain,
                                      ),
                                    ),
                                  ),
                                ),
                              ElevatedButton(
                                onPressed: _actionLoading
                                    ? null
                                    : () => _onPurchase(p),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2A2A2A),
                                  foregroundColor: AppTheme.textMain,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                    horizontal: 20,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      p.title,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      p.price,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      const SizedBox(height: 32),
                      TextButton(
                        onPressed: _actionLoading ? null : _onRestore,
                        child: Text(
                          PaywallStrings.restore,
                          style: const TextStyle(
                            color: Color(0xFF9E9E9E),
                            fontSize: 13,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
