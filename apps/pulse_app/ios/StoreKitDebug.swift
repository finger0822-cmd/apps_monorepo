import Foundation
import StoreKit

@MainActor
@available(iOS 15.0, *)
func logEntitlementsForDebug() async {
    // シミュレータ専用。実機では IAP 未設定時などで問題を起こすことがあるため AppDelegate から呼ばない。
    print("=== StoreKit Debug: currentEntitlements start ===")
    for await result in Transaction.currentEntitlements {
        switch result {
        case .verified(let transaction):
            print("✅ VERIFIED")
            print(" productID:", transaction.productID)
            print(" transactionId:", transaction.id)
            print(" originalTransactionId:", transaction.originalID)
            print(" purchaseDate:", transaction.purchaseDate)
            print(" expiresDate:", transaction.expirationDate as Any)
            print(" revocationDate:", transaction.revocationDate as Any)
            if #available(iOS 16.0, *) {
                print(" environment:", transaction.environment)
            }
        case .unverified(_, let error):
            print("⚠️ UNVERIFIED:", error)
        }
    }
    print("=== StoreKit Debug: currentEntitlements end ===")
}
