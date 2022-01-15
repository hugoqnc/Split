//
//  Shops.swift
//  ReceiptSplitter
//
//  Created by Hugo Queinnec on 15/01/2022.
//

import Foundation
import SwiftUI

struct Shop: Identifiable {
    var id: UUID
    var shop: ShopReceiptType
    
    static let `default` = Shop(shop: .aldi_suisse)
    
    enum ShopReceiptType: CaseIterable {

        case aldi_suisse
        case carrefour_france

        func parse(textModel: TextModel) -> TextModel {
            switch self {
            case .aldi_suisse:
                textModel.list = []
                textModel.text+="\n"
                
                let productDivision = textModel.text.ranges(of: "(?!= A\\n| B\\n)(.|\\n)+? [A,B]\\n", options: .regularExpression).map { textModel.text[$0].trimmingCharacters(in: .whitespaces) }
                
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
                            textModel.list.append(pair)
                        }
                    } else {
                        pair.name = String(productString)
                        textModel.list.append(pair)
                    }

                }
                return textModel
            case .carrefour_france:
                return textModel
//            default:
//                return textModel
            }
        }
    }
    
    var name: String {
        switch self.shop{
        case .aldi_suisse:
            return "Aldi Suisse"
        case .carrefour_france:
            return "Carrefour France"
//        default:
//            return ""
        }
    }
    
    var image: Image {
        switch self.shop{
        case .aldi_suisse:
            return Image("aldi_suisse")
        case .carrefour_france:
            return Image("carrefour_france")
//        default:
//            return ""
        }
    }
    
    init(shop: ShopReceiptType) {
        id = UUID()
        self.shop = shop
    }
}
