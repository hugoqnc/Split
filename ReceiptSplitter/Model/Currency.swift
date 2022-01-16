//
//  Currency.swift
//  ReceiptSplitter
//
//  Created by Hugo Queinnec on 16/01/2022.
//

import Foundation

struct Currency {
    
    var symbol: SymbolType
    
    static let `default` = Currency(symbol: .euro)
    
    enum SymbolType: CaseIterable {
        case euro
        case dollar
        case pound
        case yen
        case other
    }
    
    var value: String {
        switch self.symbol{
        case .euro:
            return "€"
        case .dollar:
            return "$"
        case .pound:
            return "£"
        case .yen:
            return "¥"
        case .other:
            return "💎"
        }
    }
}
