import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'billing_repository.dart';
import 'billing_repository_impl.dart';
import 'entitlement.dart';

final billingRepositoryProvider = Provider<BillingRepository>((ref) {
  final repo = BillingRepositoryImpl();
  ref.onDispose(() => repo.dispose());
  return repo;
});

final entitlementProvider = FutureProvider<Entitlement>((ref) async {
  final repo = ref.read(billingRepositoryProvider);
  return repo.getEntitlement();
});
