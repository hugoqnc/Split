//
//  TextRecognition.swift
//  Split
//
//  Created by Hugo Queinnec on 05/01/2022.
//

import SwiftUI
import Vision

struct TextRecognition {
    var scannedImages: [UIImage]
    @ObservedObject var recognizedContent: TextData
    var visionParameters: VisionParameters
    var didFinishRecognition: (Bool) -> Void
    
    
    func recognizeText() {
        let queue = DispatchQueue(label: "textRecognitionQueue", qos: .userInitiated)
        queue.async {
            for image in scannedImages {
                guard let cgImage = image.cgImage else { return }
                
                let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
                
                do {
                    let textItem = TextModel()
                    textItem.image = IdentifiedImage(id: textItem.id, image: image)
                    try requestHandler.perform([getTextRecognitionRequest(with: textItem)])
                                        
                    DispatchQueue.main.async {
                        recognizedContent.items.append(textItem)
                    }
                } catch {
                    print(error.localizedDescription)
                }
                
                DispatchQueue.main.async {
                    let isLastImage = scannedImages.count-1==scannedImages.lastIndex(of: image)
                    didFinishRecognition(isLastImage)
                }
            }
        }
    }
    
    
    func getTextRecognitionRequest(with textItem: TextModel) -> VNRecognizeTextRequest {
        // vision parameters
        let epsilonHeight = visionParameters.epsilonHeight
        let minAreaCoverage = visionParameters.minAreaCoverage
        let maxMargin = visionParameters.maxMargin
                
        let request = VNRecognizeTextRequest { (request, error) in
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                print("Error: \(error! as NSError)")
                return
            }
            
            textItem.name = observations.first?.topCandidates(1).first?.string ?? ""
            
            //0. Get median heigth of bounding box
            let heights: [CGFloat] = observations.map { obs in
             obs.boundingBox.size.height
            }
            var medianHeight: CGFloat = 0.0
            if (heights.count != 0) {
                medianHeight = heights.sorted(by: <)[heights.count / 2]
            }
            //print("median height: \(medianHeight)")
            
            var observationsCopy = observations
            var listOfMatchs: [[VNRecognizedTextObservation]] = []
            
            // 1. Group bounding boxes of the same line together
            for obs in observations {
                let px = obs.boundingBox.origin.x
                let py = obs.boundingBox.origin.y
                let h = obs.boundingBox.size.height
                var matching: [VNRecognizedTextObservation] = [obs]
                
                let longRect: CGRect = CGRect(x: px, y: py, width: 1-px, height: h)

                 if h<medianHeight*(1+epsilonHeight) && h>medianHeight*(1-epsilonHeight) {
                     for obs2 in observationsCopy {
                         let px2 = obs2.boundingBox.origin.x
                         let h2 = obs2.boundingBox.size.height

                         let areaCoverage = getsCoveredByArea(of: longRect, rect: obs2.boundingBox)
                         //let globalHeight = h+h2-abs(py-py2)
                         //if px<px2 && areaCoverage > minAreaCoverage {print(areaCoverage)}
                         
                         if (px<px2 && areaCoverage>minAreaCoverage && h2<medianHeight*(1+epsilonHeight) && h2>medianHeight*(1-epsilonHeight)) {
                             matching.append(obs2)
                         }
                    }
                }
                
                if matching.count>1 {
                    listOfMatchs.append(matching)
                    observationsCopy.removeAll { o in
                        matching.contains(o)
                    }
                }
            }

            // 2. Remove observations that do not go to the edges of the receipt
            for l in listOfMatchs {
                var hasBeginObs = false
                var hasEndObs = false
                for obs in l {
                    let px = obs.boundingBox.origin.x
                    let w = obs.boundingBox.size.width
                    
                    if px<maxMargin {
                        hasBeginObs = true
                    }
                    if (px+w)>(1-maxMargin) {
                        hasEndObs = true
                    }
                }
                if !(hasBeginObs && hasEndObs){
                     listOfMatchs.remove(at: listOfMatchs.firstIndex(of: l)!)
                 }
            }
            
            
            // 3. Extract pairs of product and price
            var listOfPairProductPrice: [PairProductPrice] = []
            for l in listOfMatchs {
                var pairProductPrice = PairProductPrice()
                var removeThisPairFlag = false
                
                var listOfPrices: [PairStringDouble] = []
                var matchsCopy = l
                for o in matchsCopy {
                    if let cleanedString = o.topCandidates(1).first?.string.replacingOccurrences(of:",", with: ".") {
                        let scanner = Scanner(string: cleanedString)
                        if let double = scanner.scanDouble() {
                            var p = PairStringDouble()
                            p.string = cleanedString
                            p.price = double
                            p.o = o
                            listOfPrices.append(p)
                        }
                    }
                }
                var priceIndex = -1
                
                if listOfPrices.isEmpty {
                    pairProductPrice.price = 0.0
                    removeThisPairFlag = true
                } else if listOfPrices.count==1 {
                    pairProductPrice.price=listOfPrices[0].price
                    priceIndex = 0
                } else if let priceIndex1 = listOfPrices.lastIndex(where: { p in p.string.contains("€") || p.string.contains("$") || p.string.contains("¥") || p.string.contains("£")}) {
                    pairProductPrice.price=listOfPrices[priceIndex1].price
                    priceIndex=priceIndex1
                } else if let priceIndex1 = listOfPrices.lastIndex(where: { p in p.string.contains(".")}) {
                    pairProductPrice.price=listOfPrices[priceIndex1].price
                    priceIndex=priceIndex1
                } else {
                    removeThisPairFlag = true
                    pairProductPrice.price=listOfPrices.last!.price
                    priceIndex=listOfPrices.count-1
                }
                
                if priceIndex>=0 {
                    matchsCopy.removeAll { o in
                        o==listOfPrices[priceIndex].o
                    }
                }
                
                // Get content
                var content = ""
                var index = 0
                for o in matchsCopy {
                    content.append(o.topCandidates(1).first?.string ?? "")
                    index+=1
                    if !(index==matchsCopy.count) {
                        content.append(" ")
                    }
                }
                
                // Get bounding box
                var px = 1.0
                var py = 1.0
                var w = 0.0
                var h = 0.0
                
                for o in l {
                    if o.boundingBox.origin.x<px{
                        px = o.boundingBox.origin.x
                    }
                    if o.boundingBox.origin.y<py{
                        py = o.boundingBox.origin.y
                    }
                }
                
                for o in l {
                    var current_w = 0.0
                    current_w = o.boundingBox.origin.x-px + o.boundingBox.size.width
                    if current_w>w{
                        w=current_w
                    }
                    
                    var current_h = 0.0
                    current_h = o.boundingBox.origin.y-py + o.boundingBox.size.height
                    if current_h>h{
                        h=current_h
                    }
                }
                
                let bb = CGRect(x: px, y: py, width: w, height: h)
                let v = VNDetectedObjectObservation(boundingBox: bb)
                
                pairProductPrice.name=content
                pairProductPrice.imageId=textItem.id
                pairProductPrice.box=v
                
                if !removeThisPairFlag { listOfPairProductPrice.append(pairProductPrice) }
                
            }
            
            // 4. Result
            textItem.list = listOfPairProductPrice
//            print("\(listOfPairProductPrice.count) products found")
//            for p in listOfPairProductPrice{
//                print(p)
//            }
        }
        
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true
        
        return request
    }
}

func getsCoveredByArea(of bigRect: CGRect, rect: CGRect) -> CGFloat {
     if (bigRect.intersects(rect)) {

        //let interRect:CGRect = r1.rectByIntersecting(r2); //OLD
        let interRect:CGRect = bigRect.intersection(rect);

        return ((interRect.width * interRect.height) / (rect.width * rect.height))
     }
     return 0;
 }


struct PairStringDouble: Identifiable {
    var id: String
    var string: String = ""
    var price: Double = 0
    var o: VNRecognizedTextObservation = VNRecognizedTextObservation()
    
    init() {
        id = UUID().uuidString
    }
}
