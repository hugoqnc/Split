//
//  Text.swift
//  ReceiptSplitter
//
//  Created by Hugo Queinnec on 05/01/2022.
//

import Foundation

class TextModel: Identifiable {
    var id: String
    var text: String = ""
    var list: [PairProductPrice] = []
    
    init() {
        id = UUID().uuidString
    }
    
    func getListOfProductsAndPrices(textModel: TextModel, shop: Shop) {
        self.list = shop.shop.parse(textModel: textModel).list
    }
}

struct PairProductPrice: Identifiable, Equatable {
    var id: String
    var name: String = ""
    var price: Double = 0
    
    init() {
        id = UUID().uuidString
    }
    
    init(id: String, name: String, price: Double) {
        self.id = id
        self.name = name
        self.price = price
    }
}

extension StringProtocol {
    func ranges<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var startIndex = self.startIndex
        while startIndex < endIndex,
            let range = self[startIndex...].range(of: string, options: options) {
                result.append(range)
                startIndex = range.lowerBound < range.upperBound ? range.upperBound :
                    index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
}


class TextData: ObservableObject {
    @Published var items = [TextModel]()
}
