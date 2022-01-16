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
    @Published var shop: Shop = Shop.default
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
}
