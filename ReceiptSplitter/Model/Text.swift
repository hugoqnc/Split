//
//  Text.swift
//  ReceiptSplitter
//
//  Created by Hugo Queinnec on 05/01/2022.
//

import Foundation
import UIKit
import Vision

class TextModel: Identifiable {
    var id: String
    var list: [PairProductPrice] = []
    var image: IdentifiedImage
    
    init() {
        id = UUID().uuidString
        image = IdentifiedImage(id: self.id)
    }
}

struct PairProductPrice: Identifiable, Equatable {
    
    var id: String
    var name: String = ""
    var price: Double = 0
    var isNewItem: Bool = false
    
    var imageId: String?
    var box: VNDetectedObjectObservation?
    
    init() {
        id = UUID().uuidString
    }
    
    //only for preview
    init(id: String, name: String, price: Double) {
        self.id = id
        self.name = name
        self.price = price
    }
    init(id: String, name: String = "", price: Double = 0, isNewItem: Bool = false, imageId: String? = nil, box: VNDetectedObjectObservation? = nil) {
        self.id = id
        self.name = name
        self.price = price
        self.isNewItem = isNewItem
        self.imageId = imageId
        self.box = box
    }
}

struct IdentifiedImage: Identifiable {
    init(id: String, image: UIImage? = nil) {
        self.id = id
        self.image = image
    }
    
    var id: String
    var image: UIImage?
    
    func boxes(listOfProductsAndPrices: [PairProductPrice]) -> [VNDetectedObjectObservation] {
        return listOfProductsAndPrices.compactMap({ pair -> VNDetectedObjectObservation? in
            if pair.imageId==id && !(pair.box == nil){
                return pair.box!
            }
            return nil
        })
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
