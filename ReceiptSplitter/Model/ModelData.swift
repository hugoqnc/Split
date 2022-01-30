//
//  ModelData.swift
//  ReceiptSplitter
//
//  Created by Hugo Queinnec on 05/01/2022.
//

import Foundation
import UIKit

final class ModelData: ObservableObject {
    @Published var startTheProcess = false
    @Published var users: [User] = []
    @Published var listOfProductsAndPrices: [PairProductPrice] = []
    @Published var currency: Currency = Currency.default
    @Published var images: [IdentifiedImage] = []
    @Published var visionParameters = VisionParameters()
    
    var totalBalance: Double {
        get {
            var total: Double = 0
            for user in users{
                total += balance(ofUser: user)
            }
            return total
        }
    }
    
    var totalPrice: Double {
        get {
            var total: Double = 0
            for item in listOfProductsAndPrices{
                total += item.price
            }
            return total
        }
    }
    
    func chosenItems(ofUser user: User) -> [PairProductPrice] {
        var chosen: [PairProductPrice] = []
        for item in listOfProductsAndPrices {
            if item.chosenBy.contains(user.id) {
                chosen.append(item)
            }
        }
        return chosen
    }
    
    func balance(ofUser user: User) -> Double {
        var total: Double = 0.0
        for item in chosenItems(ofUser: user){
            total += item.price/Double(item.chosenBy.count)
        }
        return total
    }
    
    func showPrice(price: Double) -> String {
        return String(round(price * 100) / 100.0)+currency.value
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
                sharedText.append("      \(user.name): \(showPrice(price: balance(ofUser: user)))\n")
            }
            
            sharedText.append(
            """
            ________________
            💸 Total: \(showPrice(price: totalBalance))
            
            Sent with ReceiptSplitter
            """
            )
            return sharedText
        }
    }
    
    func eraseModelData() {
        self.startTheProcess = false
        self.users = []
        self.listOfProductsAndPrices = []
        self.currency = Currency.default
        self.images = []
    }
    func eraseScanData() {
        self.listOfProductsAndPrices = []
        self.images = []
    }
}
