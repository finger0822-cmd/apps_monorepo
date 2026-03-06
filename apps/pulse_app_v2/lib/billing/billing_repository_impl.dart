import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

import 'billing_repository.dart';
import 'entitlement.dart';
import 'product_ids.dart';

/// in_app_purchase をラップ。purchaseStream で購入完了時に completePurchase を実行。
/// MVP: getEntitlement は暫定 isPro 判定（購読IDに一致する購入/復元が確認できた場合に Pro）。
/// Android は queryPastPurchases で判定し _setCachedEntitlement に集約、iOS は restore をイベント完了で待つ。
class BillingRepositoryImpl implements BillingRepository {
  BillingRepositoryImpl() {
    _init();
  }

  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _sub;
  final Completer<void> _ready = Completer<void>();
  Entitlement? _cachedEntitlement;
  Completer<bool>? _restoreCompleter;

  static const Duration _restoreTimeout = Duration(seconds: 15);

  void _setCachedEntitlement(Entitlement e) {
    _cachedEntitlement = e;
  }

  Future<void> _init() async {
    try {
      final available = await _iap.isAvailable();
      if (!available) {
        _ready.complete();
        return;
      }
      _sub = _iap.purchaseStream.listen((purchases) async {
        for (final p in purchases) {
          if (p.pendingCompletePurchase) {
            try {
              await _iap.completePurchase(p);
            } catch (e, st) {
              debugPrint(
                'BillingRepositoryImpl: completePurchase failed ${p.productID}: $e',
              );
              if (kDebugMode) debugPrint('$st');
            }
          }
          if (BillingProductIds.subscriptionIds.contains(p.productID) &&
              (p.status == PurchaseStatus.purchased ||
                  p.status == PurchaseStatus.restored)) {
            _setCachedEntitlement(Entitlement(
              isPro: true,
              trialActive: false,
              expiresAt: null,
              source: p.status == PurchaseStatus.restored
                  ? EntitlementSource.restore
                  : EntitlementSource.purchase,
            ));
            _restoreCompleter?.complete(true);
            _restoreCompleter = null;
          }
        }
      }, onError: (_) {});
    } finally {
      if (!_ready.isCompleted) _ready.complete();
    }
  }

  @override
  Future<Entitlement> getEntitlement() async {
    await _ready.future;
    try {
      final available = await _iap.isAvailable();
      if (!available) return Entitlement.free;

      if (Platform.isAndroid) {
        final android =
            _iap.getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
        final res = await android.queryPastPurchases();
        if (res.error != null) return _cachedEntitlement ?? Entitlement.free;
        for (final p in res.pastPurchases) {
          if (!BillingProductIds.subscriptionIds.contains(p.productID)) {
            continue;
          }
          _setCachedEntitlement(Entitlement(
            isPro: true,
            trialActive: false,
            expiresAt: null,
            source: EntitlementSource.purchase,
          ));
          return _cachedEntitlement!;
        }
        return Entitlement.free;
      }

      if (Platform.isIOS) {
        await restore();
        return _cachedEntitlement ?? Entitlement.free;
      }

      return _cachedEntitlement ?? Entitlement.free;
    } catch (_) {
      return _cachedEntitlement ?? Entitlement.free;
    }
  }

  @override
  Future<List<ProductDetails>> fetchProducts() async {
    await _ready.future;
    try {
      final available = await _iap.isAvailable();
      if (!available) return [];

      final res = await _iap.queryProductDetails(BillingProductIds.subscriptionIds);
      if (res.error != null) return [];
      return res.productDetails;
    } catch (_) {
      return [];
    }
  }

  @override
  Future<bool> purchase(String productId) async {
    await _ready.future;
    try {
      final available = await _iap.isAvailable();
      if (!available) return false;

      final res = await _iap.queryProductDetails({productId});
      if (res.error != null) return false;
      if (res.productDetails.isEmpty) return false;

      final product = res.productDetails.first;
      final param = PurchaseParam(productDetails: product);
      return await _iap.buyNonConsumable(purchaseParam: param);
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> restore() async {
    await _ready.future;
    try {
      final available = await _iap.isAvailable();
      if (!available) return false;

      _restoreCompleter = Completer<bool>();
      await _iap.restorePurchases();
      try {
        return await _restoreCompleter!.future.timeout(
          _restoreTimeout,
          onTimeout: () {
            if (!_restoreCompleter!.isCompleted) {
              _restoreCompleter!.complete(false);
            }
            return false;
          },
        );
      } finally {
        _restoreCompleter = null;
      }
    } catch (_) {
      _restoreCompleter = null;
      return false;
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    _restoreCompleter?.complete(false);
    _restoreCompleter = null;
  }
}
