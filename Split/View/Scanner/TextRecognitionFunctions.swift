//
//  TextRecognitionFunctions.swift
//  Split
//
//  Created by Hugo Queinnec on 19/03/2023.
//

import Foundation
import PhotosUI

class TextRecognitionFunctions {
    let model: ModelData
    let recognizedContent: TextData
    
    init(model: ModelData, recognizedContent: TextData) {
        self.model = model
        self.recognizedContent = recognizedContent
    }
    
    func fillInModel(images: [UIImage], completion: @escaping (Bool) -> Void) {
        var successCount = 0 //for Advanced Recognition
        var listOfProductsAndPricesTemp: [PairProductPrice] = []
        var nothingFound = false
        
        if model.parameters.advancedRecognition {
            successCount = 0
            listOfProductsAndPricesTemp = []
            
            TextRecognitionAdvanced(scannedImages: images,
                            recognizedContent: recognizedContent,
                            visionParameters: model.parameters.visionParameters) { isLastImage in
                for item in self.recognizedContent.items{
                    if !self.model.listOfProductsAndPrices.contains(item.list.first ?? PairProductPrice()){
                        let content: [PairProductPrice] = item.list
                        listOfProductsAndPricesTemp.append(contentsOf: content)
                        self.model.addNameToReceipt(name: item.name)
                        if !content.isEmpty {
                            successCount += 1
                        }
                    }
                    self.model.images.append(item.image)
                }
                if isLastImage {
                    //print("Success: \(successCount) | Images: \(model.images.count)")
                    if successCount != self.model.images.count {
                        nothingFound = true
                    } else {
                        self.model.listOfProductsAndPrices = listOfProductsAndPricesTemp
                    }
                }
                self.recognizedContent.items = []
                completion(nothingFound)
            }
            .recognizeText()
        } else {
            TextRecognition(scannedImages: images,
                            recognizedContent: recognizedContent,
                            visionParameters: model.parameters.visionParameters) { isLastImage in
                for item in self.recognizedContent.items{
                    if !self.model.listOfProductsAndPrices.contains(item.list.first ?? PairProductPrice()){
                        let content: [PairProductPrice] = item.list
                        self.model.listOfProductsAndPrices.append(contentsOf: content)
                        self.model.addNameToReceipt(name: item.name)
                    }
                    self.model.images.append(item.image)
                }
                if self.model.listOfProductsAndPrices.isEmpty && isLastImage {
                    nothingFound = true
                }
                self.recognizedContent.items = []
                completion(nothingFound)
            }
            .recognizeText()
        }
    }
}
