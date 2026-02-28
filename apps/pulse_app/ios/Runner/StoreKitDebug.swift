import StoreKit

@MainActor
func logEntitlementsForDebug() async {
  guard #available(iOS 15.0, *) else {
    print("[StoreKitDebug] currentEntitlements requires iOS 15.0+")
    return
  }

  print("[StoreKitDebug] Start reading currentEntitlements")

  for await result in Transaction.currentEntitlements {
    switch result {
    case .verified(let transaction):
      print(
        """
        [StoreKitDebug] verified entitlement \
        productID=\(transaction.productID) \
        id=\(transaction.id) \
        originalTransactionId=\(transaction.originalID) \
        expirationDate=\(String(describing: transaction.expirationDate)) \
        environment=\(transaction.environment)
        """
      )
    case .unverified(_, let error):
      print("[StoreKitDebug] unverified entitlement error=\(error)")
    }
  }

  print("[StoreKitDebug] Finished reading currentEntitlements")
}
