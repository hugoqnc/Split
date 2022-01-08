//
//  UsersModel.swift
//  ReceiptSplitter
//
//  Created by Hugo Queinnec on 04/01/2022.
//

import Foundation

struct UsersModel {
    var users: [User] = []
}

struct User: Identifiable {
    var id: UUID
    var name = ""
    var balance = 0.0
    
    init() {
        id = UUID()
    }
    init(name: String) {
        id = UUID()
        self.name = name
    }
    
    init(name: String, balance: Double) {
        id = UUID()
        self.name = name
        self.balance = balance
    }
}
