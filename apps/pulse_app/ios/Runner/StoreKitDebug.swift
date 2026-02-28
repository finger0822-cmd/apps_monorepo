import StoreKit

@available(iOS 15.0, *)
@MainActor
func logEntitlementsForDebug() async {
    print("[StoreKitDebug] ---- currentEntitlements start ----")
    var count = 0
    for await result in Transaction.currentEntitlements {
        count += 1
        switch result {
        case .verified(let tx):
            print("""
            [StoreKitDebug] ✅ verified
              productID        : \(tx.productID)
              id               : \(tx.id)
              originalID       : \(tx.originalID)
              expirationDate   : \(tx.expirationDate?.description ?? "nil")
              environment      : \(tx.environment.rawValue)
            """)
        case .unverified(_, let error):
            print("[StoreKitDebug] ❌ unverified – \(error.localizedDescription)")
        }
    }
    print("[StoreKitDebug] ---- currentEntitlements end (count: \(count)) ----")
}
