/// 課金商品 ID。本番では App Store Connect / Play Console の ID に差し替える。
class BillingProductIds {
  BillingProductIds._();

  static const String subscriptionProMonthly = 'com.pulse.pro.monthly';
  static const String subscriptionProYearly = 'com.pulse.pro.yearly';

  static const Set<String> subscriptionIds = {
    subscriptionProMonthly,
    subscriptionProYearly,
  };
}
