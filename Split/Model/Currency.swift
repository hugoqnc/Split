//
//  Currency.swift
//  Split
//
//  Created by Hugo Queinnec on 16/01/2022.
//

import Foundation

struct Currency: Codable, Hashable {
    
    var symbol: SymbolType
    
    static let `default` = Currency(symbol: .other)
    
    enum SymbolType: CaseIterable, Codable {
        case euro
        case dollar
        case pound
        case yen
        case other
    }
    
    var value: String {
        switch self.symbol{
        case .other:
            return "–"
        case .euro:
            return "€"
        case .dollar:
            return "$"
        case .pound:
            return "£"
        case .yen:
            return "¥"
        }
    }
}
