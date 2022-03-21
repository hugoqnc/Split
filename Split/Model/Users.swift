//
//  Users.swift
//  Split
//
//  Created by Hugo Queinnec on 04/01/2022.
//

import Foundation

struct User: Identifiable, Codable, Equatable, Hashable {
    var id: UUID
    var name = ""
    
    init() {
        id = UUID()
    }
    init(name: String) {
        id = UUID()
        self.name = name
    }
}

//struct ChosenItem: Identifiable, Codable, Equatable {
//    var id: UUID
//    var name = ""
//    var price = 0.0
//    var dividedBy = 1
//
//
//    init() {
//        id = UUID()
//    }
//    init(name: String = "", price: Double, dividedBy: Int) {
//        self.id = UUID()
//        self.name = name
//        self.price = price
//        self.dividedBy = dividedBy
//    }
//}

