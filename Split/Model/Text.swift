//
//  Text.swift
//  Split
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
    var name: String
    
    init() {
        id = UUID().uuidString
        image = IdentifiedImage(id: self.id)
        name = ""
    }
}

struct PairProductPrice: Identifiable, Equatable {
    
    var id: String
    var name: String = ""
    var price: Double = 0
    var isNewItem: Bool = false
    var chosenBy: [UUID] = []
    
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
    init(id: String, name: String = "", price: Double = 0, isNewItem: Bool = false, imageId: String? = nil, box: VNDetectedObjectObservation? = nil, chosenBy: [UUID] = []) {
        self.id = id
        self.name = name
        self.price = price
        self.isNewItem = isNewItem
        self.imageId = imageId
        self.box = box
        self.chosenBy = chosenBy
    }
}

struct PairProductPriceCodable: Identifiable, Equatable, Codable {
    var id: String = ""
    var name: String = ""
    var price: Double = 0
    var chosenBy: [UUID] = []
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


class TextData: ObservableObject {
    @Published var items = [TextModel]()
}
