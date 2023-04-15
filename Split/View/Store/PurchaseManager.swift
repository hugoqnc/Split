//
//  PurchaseManager.swift
//  Split
//
//  Created by Hugo Queinnec on 15/04/2023.
//

import Foundation
import StoreKit

@MainActor
class PurchaseManager: ObservableObject {

    private let productIds = ["patron.small", "patron.medium", "patron.big"]

    @Published
    private(set) var products: [Product] = []
    @Published
    private(set) var purchasedProductIDs = Set<String>()

    private var productsLoaded = false
    private var updates: Task<Void, Never>? = nil

    init() {
        self.updates = observeTransactionUpdates()
    }

    deinit {
        self.updates?.cancel()
    }

    var hasTipped: Bool {
       return !self.purchasedProductIDs.isEmpty
    }
    
    var hasTippedAll: Bool {
        productIds.containsSameElements(as: self.purchasedProductIDs.sorted())
    }

    func loadProducts() async throws {
        guard !self.productsLoaded else { return }
        self.products = try await Product.products(for: productIds)
        self.productsLoaded = true
    }

    func purchase(_ product: Product) async throws -> Bool {
        let result = try await product.purchase()

        switch result {
        case let .success(.verified(transaction)):
            // Successful purchase
            await transaction.finish()
            await self.updatePurchasedProducts()
            return true
        case let .success(.unverified(_, error)):
            // Successful purchase but transaction/receipt can't be verified
            // Could be a jailbroken phone
            print(error)
            break
        case .pending:
            // Transaction waiting on SCA (Strong Customer Authentication) or
            // approval from Ask to Buy
            break
        case .userCancelled:
            // ^^^
            break
        @unknown default:
            break
        }
        return false
    }

    func updatePurchasedProducts() async {
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else {
                continue
            }

            if transaction.revocationDate == nil {
                self.purchasedProductIDs.insert(transaction.productID)
            } else {
                self.purchasedProductIDs.remove(transaction.productID)
            }
            // print(self.purchasedProductIDs)
        }
    }

    private func observeTransactionUpdates() -> Task<Void, Never> {
        Task(priority: .background) {
            for await _ in Transaction.updates {
                // Using verificationResult directly would be better
                // but this way works for this tutorial
                await self.updatePurchasedProducts()
            }
        }
    }
}
