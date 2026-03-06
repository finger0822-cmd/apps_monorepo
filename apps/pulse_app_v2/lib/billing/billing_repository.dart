import 'package:in_app_purchase/in_app_purchase.dart';

import 'entitlement.dart';

abstract interface class BillingRepository {
  Future<Entitlement> getEntitlement();
  Future<List<ProductDetails>> fetchProducts();
  Future<bool> purchase(String productId);
  Future<bool> restore();
  void dispose();
}
