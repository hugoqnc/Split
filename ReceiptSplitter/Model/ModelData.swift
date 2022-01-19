//
//  ModelData.swift
//  ReceiptSplitter
//
//  Created by Hugo Queinnec on 05/01/2022.
//

import Foundation

final class ModelData: ObservableObject {
    @Published var startTheProcess = false
    @Published var users: [User] = UsersModel().users
    @Published var listOfProductsAndPrices: [PairProductPrice] = []
    @Published var currency: Currency = Currency.default
    
    var totalPrice: Double {
        get {
            var total: Double = 0
            for user in users{
                total += user.balance
            }
            return total
        }
    }
    
    var sharedText: String {
        get {
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            
            var sharedText =
            """
            🛒 Shopping Repartition
            🗓 Date: \(dateFormatter.string(from: date))\n\n
            """
            
            for user in users {
                sharedText.append("      \(user.name): \(String(round(user.balance * 100) / 100.0))\(currency.value)\n")
            }
            
            sharedText.append(
            """
            ________________
            💸 Total: \(String(round(self.totalPrice * 100) / 100.0))\(currency.value)
            
            Sent with ReceiptSplitter
            """
            )
            return sharedText
        }
    }
}
