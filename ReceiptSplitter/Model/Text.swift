//
//  Model.swift
//  ScanAndRecognizeText
//
//  Created by Gabriel Theodoropoulos.
//

import Foundation

class TextModel: Identifiable {
    var id: String
    var text: String = ""
    var list: [PairProductPrice] = []
    
    init() {
        id = UUID().uuidString
    }
    
    func getListOfProductsAndPrices() {
        self.list = []
        self.text+="\n"
        
        let productDivision = text.ranges(of: "(?!= A\\n| B\\n)(.|\\n)+? [A,B]\\n", options: .regularExpression).map { text[$0].trimmingCharacters(in: .whitespaces) }
        
        for productString in productDivision {
            var pair = PairProductPrice()
            
            let productString = productString.prefix(productString.count-1)
            if let divider = productString.lastIndex(of:"\n"){
                let product = productString[...divider].replacingOccurrences(of: "\n", with: " ")
                var price = productString[divider...].replacingOccurrences(of: "\n", with: "")
                price = price.replacingOccurrences(of: price.suffix(2), with: "")
                
                pair.name = product
                if let priceDouble = Double(price) {
                    pair.price = priceDouble
                }
                if !product.trimmingCharacters(in: .whitespaces).isEmpty && !price.trimmingCharacters(in: .whitespaces).isEmpty{ //do not add if the line is empty
                    self.list.append(pair)
                }
            } else {
                pair.name = String(productString)
                self.list.append(pair)
            }

        }
    }
}

struct PairProductPrice: Identifiable {
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
