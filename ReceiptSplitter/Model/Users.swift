//
//  Users.swift
//  ReceiptSplitter
//
//  Created by Hugo Queinnec on 04/01/2022.
//

import Foundation

struct User: Identifiable, Codable, Equatable {
    var id: UUID
    var name = ""
    //var balance = 0.0
    var chosenItems: [ChosenItem] = []
    
    var balance: Double {
        get {
            var total: Double = 0
            for item in chosenItems{
                total += item.price/Double(item.dividedBy)
            }
            return total
        }
    }
    
    init() {
        id = UUID()
    }
    init(name: String) {
        id = UUID()
        self.name = name
    }
    
//    init(name: String, balance: Double) {
//        id = UUID()
//        self.name = name
//        self.balance = balance
//    }
}

struct ChosenItem: Identifiable, Codable, Equatable {
    var id: UUID
    var name = ""
    var price = 0.0
    var dividedBy = 1
 
    
    init() {
        id = UUID()
    }
    init(name: String = "", price: Double, dividedBy: Int) {
        self.id = UUID()
        self.name = name
        self.price = price
        self.dividedBy = dividedBy
    }
}

