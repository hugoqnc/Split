//
//  ModelData.swift
//  Split
//
//  Created by Hugo Queinnec on 05/01/2022.
//

import Foundation
import UIKit
import SwiftUI

final class ModelData: ObservableObject {
    @Published var startTheProcess = false
    @Published var photoFromLibrary = false
    @Published var users: [User] = []
    @Published var listOfProductsAndPrices: [PairProductPrice] = []
    @Published var currency: Currency = Currency.default
    @Published var images: [IdentifiedImage] = []
    @Published var parameters = Parameters.default
    @Published var receiptName = ""
    @Published var continueWithStandardRecognition = false
    @Published var numberOfScanFails = 0
    @Published var tipRate: Double?
    @Published var tipEvenly: Bool? // if false, tip proportionally
    @Published var taxRate: Double?
    @Published var taxEvenly: Bool? // if false, tax proportionally
    var date = Date()
    
    func addNameToReceipt(name: String) -> Void {
        if receiptName.isEmpty {
            self.receiptName = name
        } else if !name.isEmpty {
            self.receiptName += ", "+name
        }
        
    }
    
    var totalBalance: Double { // Excluding tax and tip
        get {
            var total: Double = 0
            for item in listOfProductsAndPrices{
                if !item.chosenBy.isEmpty {
                    total += item.price
                }
            }
            return total
        }
    }
    
    var totalPrice: Double { // Including tax and tip
        get {
            return totalPriceBeforeTaxTip + tipAmount + taxAmount
        }
    }
    
    var totalPriceBeforeTaxTip: Double {
        get {
            var total: Double = 0
            for item in listOfProductsAndPrices{
                total += item.price
            }
            return total
        }
    }
    
    var tipAmount: Double {
        get {
            if let t = tipRate {
                return t*totalPriceBeforeTaxTip/100
            }
            return 0
        }
    }
    
    var taxAmount: Double {
        get {
            if let t = taxRate {
                return t*totalPriceBeforeTaxTip/100
            }
            return 0
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
    
    func balance(ofUser user: User) -> Double { // Including tax and tip
        var total: Double = 0.0
        for item in chosenItems(ofUser: user){
            total += item.price/Double(item.chosenBy.count)
        }
        var additional: Double = 0
        if let t = tipRate, let even = tipEvenly {
            additional += even ? (totalPriceBeforeTaxTip*t/100)/Double(users.count) :t*total/100
        }
        if let t = taxRate, let even = taxEvenly {
            additional += even ? (totalPriceBeforeTaxTip*t/100)/Double(users.count) :t*total/100
        }
        total += additional
        return total
    }
    
    func showPrice(price: Double) -> String {
        return formatPriceAndCurrency(price: price, currency: currency)
    }
    
    func individualSharedText(ofUser user: User) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        var sharedText =
        """
        👤 \(user.name)
        🛒 Shopping at \(receiptName)
        🗓 Date: \(dateFormatter.string(from: date))
        ________________\n
        """
        
        let items = chosenItems(ofUser: user)
        
        for item in items.sorted(by: {$0.price/Double($0.chosenBy.count)>$1.price/Double($1.chosenBy.count)}) {
            var text = "\n  \(item.name)\n"
            text.append("  \(showPrice(price: item.price/Double(item.chosenBy.count))) [\(showPrice(price: item.price) + " ÷ "+String(item.chosenBy.count))]\n")
            sharedText.append(text)
        }
        
        sharedText.append(
        """
        ________________
        
        💸 Total: \(showPrice(price: balance(ofUser: user)))
        
        Sent with Split!
        """
        )
        return sharedText
    }

    var sharedText: String {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            
            var sharedText =
            """
            🛒 Shopping at \(receiptName)
            🗓 Date: \(dateFormatter.string(from: date))
            ________________\n\n
            """
            
            for user in users {
                sharedText.append("🔹 \(user.name): \(showPrice(price: balance(ofUser: user)))\n")
            }
            
            sharedText.append(
            """
            ________________
            
            💸 Total: \(showPrice(price: totalBalance))
            
            Sent with Split!
            """
            )
            return sharedText
        }
    }
    
    var sharedTextDetailed: String {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            
            var sharedText =
            """
            🛒 Shopping at \(receiptName)
            🗓 Date: \(dateFormatter.string(from: date))
            ________________\n
            """
                        
            for item in listOfProductsAndPrices {
                var text = "\n\(item.name)\n"
                var namesText = ""
                for i in 0..<item.chosenBy.count {
                    let u = users.first { user in
                        user.id == item.chosenBy[i]
                    }!
                    namesText.append(u.name)
                    if i<item.chosenBy.count-1 {
                        namesText.append(", ")
                    }
                }
                if item.chosenBy.count == 1 {
                    text.append("\(showPrice(price: item.price)) [\(namesText)]\n")
                }
                else {
                    text.append("\(showPrice(price: item.price) + " ÷ "+String(item.chosenBy.count)) = \(showPrice(price: item.price/Double(item.chosenBy.count))) [\(namesText)]\n")
                }
                sharedText.append(text)
            }
            
            sharedText.append("________________\n\n")
            for user in users {
                sharedText.append("🔹 \(user.name): \(showPrice(price: balance(ofUser: user)))\n")
            }
            
            sharedText.append(
            """
            ________________
            
            💸 Total: \(showPrice(price: totalBalance))
            
            Sent with Split!
            """
            )
            return sharedText        }
    }
    
    func eraseModelData(eraseScanFails: Bool = true) {
        withAnimation {
            self.startTheProcess = false
            self.photoFromLibrary = false
        }
        
        let secondsToDelay = 0.35
        DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
            if eraseScanFails {self.numberOfScanFails = 0}
            self.users = []
            self.listOfProductsAndPrices = []
            self.currency = Currency.default
            self.images = []
            self.receiptName = ""
            self.continueWithStandardRecognition = false
            self.tipRate = nil
            self.tipEvenly = nil
            self.taxRate = nil
            self.taxEvenly = nil
        }
    }
    func eraseScanData() {
        self.numberOfScanFails += 1 // when eraseScanData is called, it means that a scan parsing has failed and that the user tries again
        
        self.listOfProductsAndPrices = []
        self.images = []
        self.receiptName = ""
        self.continueWithStandardRecognition = false
    }
}

func formatPriceAndCurrency(price: Double, currency: Currency) -> String {
    let currenciesOnLeft = [Currency(symbol: Currency.SymbolType.dollar), Currency(symbol: Currency.SymbolType.yen), Currency(symbol: Currency.SymbolType.pound)]
    
    if currenciesOnLeft.contains(currency) {
        return currency.value+String(round(price * 100) / 100.0)
    } else {
        return String(round(price * 100) / 100.0)+currency.value
    }
}
