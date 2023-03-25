//
//  TextRecognitionAdvanced.swift
//  Split
//
//  Created by Hugo Queinnec on 06/03/2022.
//

import SwiftUI
import Vision

var hasSuccessed = false

struct TextRecognitionAdvanced {
    var scannedImages: [UIImage]
    @ObservedObject var recognizedContent: TextData
    var visionParameters: VisionParameters
    var didFinishRecognition: (Bool) -> Void
    @State private var allHasMatched = true
    
    func recognizeText() {
        let queue = DispatchQueue(label: "textRecognitionQueue", qos: .userInitiated)
        queue.async {
            for (index, image) in scannedImages.enumerated() {
                print("Image \(index):")
                request(image)
                
                DispatchQueue.main.async {
                    let isLastImage = scannedImages.count-1==scannedImages.lastIndex(of: image)
                    didFinishRecognition(isLastImage)
                }
            }
        }
    }
    
    
    func request(_ image: UIImage) {
        
        let epsilonFloat = visionParameters.epsilonFloat
        let contrastFactorList = [0.0, visionParameters.contrastFactor]
        let minimumTextHeightList = [visionParameters.minimumTextHeight, visionParameters.minimumTextHeight*5.0, visionParameters.minimumTextHeight*9.0]
        
        var counter = 0
        
        var parametersList: [[Double]] = []
        for i in contrastFactorList {
            for j in minimumTextHeightList {
                parametersList.append([i,j])
            }
        }
        
        let textItem = TextModel()
        textItem.image = IdentifiedImage(id: textItem.id, image: image)
        
        while !hasSuccessed && counter<parametersList.count{
            //print("loop hasSuccessed: \(hasSuccessed)")
            let imageMono: UIImage
            
            let currentContrast = parametersList[counter][0]
            let currentMinimumTextHeight = parametersList[counter][1]
            counter+=1
            
            if abs(currentContrast-0.0)<epsilonFloat {
                imageMono = image
            } else {
                imageMono = createMonoImage(image: image, contrastFactor: currentContrast)
            }
            
            if abs(currentMinimumTextHeight-minimumTextHeightList[0])<epsilonFloat {
                print("  contrast: \(currentContrast)")
            }
            print("    text height: \(currentMinimumTextHeight)")
            
            guard let cgImage = imageMono.cgImage else {
                return
            }
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            do {
                try handler.perform([getTextRecognitionRequest(with: textItem, currentMinimumTextHeight: Float(currentMinimumTextHeight))])
            }
            catch let error as NSError {
                print("Failed: \(error)")
            }
        }
        hasSuccessed = false
        DispatchQueue.main.async {
            recognizedContent.items.append(textItem)
        }
    }
    
    func createMonoImage(image:UIImage, contrastFactor:Double) -> UIImage {
        let filter = CIFilter(name: "CIPhotoEffectMono")
        filter!.setValue(CIImage(image: image), forKey: "inputImage")
        var outputImage = filter!.outputImage
        outputImage = outputImage!.applyingFilter("CIColorControls", parameters: [kCIInputContrastKey:NSNumber(value: contrastFactor)])
        let cgimg = CIContext().createCGImage(outputImage!, from: (outputImage?.extent)!)
        return UIImage(cgImage: cgimg!)
    }
    
    func getTextRecognitionRequest(with textItem: TextModel, currentMinimumTextHeight: Float) -> VNRecognizeTextRequest {
        
        let priceMarginRight = visionParameters.priceMarginRight
        let nameMarginLeft = visionParameters.nameMarginLeft
        let epsilonFloat = visionParameters.epsilonFloat
        let proportionWithTotal = visionParameters.proportionWithTotal
        let epsilonHeight = visionParameters.epsilonHeightAR
        let minAreaCoverage = visionParameters.minAreaCoverageAR
        
        let recognizeTextRequest = VNRecognizeTextRequest { (request, error) in
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                print("Error: \(error! as NSError)")
                return
            }
            
            textItem.name = observations.first?.topCandidates(1).first?.string ?? ""
            
            var listOfPricesObs: [PairStringDouble] = []
            var matched = false

            //0. Get median heigth of bounding box
            let heights: [CGFloat] = observations.map { obs in
                obs.boundingBox.size.height
            }
            
            let medianHeight = heights.count>0 ? heights.sorted(by: <)[heights.count / 2] : 1
            if medianHeight > 0.1 { print("      /!\\ median height: \(medianHeight)") }
            
            
            //A. get prices
            var prices: [VNRecognizedTextObservation] = []
            
            for obs in observations {
                let px = obs.boundingBox.origin.x
                let h = obs.boundingBox.size.height
                
                if h<medianHeight*(1+epsilonHeight) && h>medianHeight*(1-epsilonHeight) && px>1-priceMarginRight {
                    prices.append(obs)
                }
            }
            
            // A.bis: Additional filter for prices: remove prices to far away of the median x axis
            let pricesX: [CGFloat] = prices.map { obs in
                obs.boundingBox.origin.x + obs.boundingBox.size.width
            }
            let medianPriceX = pricesX.count>0 ? pricesX.sorted(by: <)[pricesX.count / 2] : 1
            
            var prices2: [VNRecognizedTextObservation] = []
            for obs in prices {
                let pxEnd = obs.boundingBox.origin.x + obs.boundingBox.size.width
                let epsilonX = priceMarginRight/2 //TODO: "2" is arbitrary here, and should require a dedicated parameter or a better approach (using stddev)
                
                if pxEnd<medianPriceX*(1+epsilonX) && pxEnd>medianPriceX*(1-epsilonX) {
                    prices2.append(obs)
                }
            }
            
            prices = prices2
                    
            prices = prices.filter { obs in
                let candidates = obs.topCandidates(2)
                if var cleanedString = candidates.first?.string.replacingOccurrences(of:",", with: ".") {
                    cleanedString = removeCurrencySymbols(s: cleanedString)
                    // print(cleanedString)
                    let scanner = Scanner(string: cleanedString)
                    if let double = scanner.scanDouble() {
                        if cleanedString.contains(".") && double != 0 {
                            
                            var p = PairStringDouble()
                            p.string = cleanedString
                            p.price = double
                            p.o = obs
                            listOfPricesObs.append(p)
                            
                            return true
                        } else {
                            if candidates.count >= 2 {
                                cleanedString = candidates[1].string.replacingOccurrences(of:",", with: ".")
                                let scanner = Scanner(string: cleanedString)
                                if let double = scanner.scanDouble() {
                                    
                                    if cleanedString.contains(".") && double != 0 {
                                        //print("\(double)")
                                        
                                        var p = PairStringDouble()
                                        p.string = cleanedString
                                        p.price = double
                                        p.o = obs
                                        listOfPricesObs.append(p)
                                        return true
                                    }
                                }
                            }
                        }
                    }
                }
                return false
            }
            
            for (index, p) in listOfPricesObs.reversed().enumerated() {
                if Double(index) < Double(listOfPricesObs.count)*proportionWithTotal {
                    var s = 0.0
                    for (index0, p) in listOfPricesObs.enumerated() {
                        if index0 < listOfPricesObs.count-1-index {
                            s += p.price
                        }
                    }
                    if abs(p.price - s) < epsilonFloat {
                        for _ in 0...index {
                            listOfPricesObs.remove(at: listOfPricesObs.count-1)
                        }
                        print("      match! (jump: 0)\n")
                        matched = true
                        break
                    }
                    
                    //second case if we have not "break": "jump" one item (that could be VAT or else)
                    s = 0.0
                    for (index0, p) in listOfPricesObs.enumerated() {
                        if index0 < listOfPricesObs.count-2-index {
                            s += p.price
                        }
                    }
                    if abs(p.price - s) < epsilonFloat {
                        for _ in 0...index+1 {
                            listOfPricesObs.remove(at: listOfPricesObs.count-1)
                        }
                        print("      match! (jump: 1)\n")
                        matched = true
                    }
                }

            }
            
            if matched {
                hasSuccessed = true //stops the while loop
                //print("set hasSuccessed: \(hasSuccessed)")
                var listOfPricesWithObservations: [LineWithPrice] = []
                for pair in listOfPricesObs {
                    listOfPricesWithObservations.append(LineWithPrice(pairStringDouble: pair))
                }
                
                // 1. Group bounding boxes of the same line together
                for obs in observations {
                    let s = listOfPricesObs.sorted { p1, p2 in
                        let o1 = p1.o
                        let o2 = p2.o
                        
                        let px1 = o1.boundingBox.origin.x
                        let py1 = o1.boundingBox.origin.y
                        let h1 = o1.boundingBox.size.height
                        //let w1 = o1.boundingBox.size.width
                        let longRect1: CGRect = CGRect(x: 0, y: py1, width: px1, height: h1)
            
                        let px2 = o2.boundingBox.origin.x
                        let py2 = o2.boundingBox.origin.y
                        let h2 = o2.boundingBox.size.height
                        //let w2 = o2.boundingBox.size.width
                        let longRect2: CGRect = CGRect(x: 0, y: py2, width: px2, height: h2)
                        
                        let areaCoverage1 = getsCoveredByArea(of: longRect1, rect: obs.boundingBox)
                        let areaCoverage2 = getsCoveredByArea(of: longRect2, rect: obs.boundingBox)
                        
                        return areaCoverage1 > areaCoverage2
                    }

                    if let oFirst = s.first?.o {
                        let px1 = oFirst.boundingBox.origin.x
                        let py1 = oFirst.boundingBox.origin.y
                        let h1 = oFirst.boundingBox.size.height
                        //let w1 = oFirst.boundingBox.size.width
                        let longRect1: CGRect = CGRect(x: 0, y: py1, width: min(px1, nameMarginLeft), height: h1)
                        
                        let areaCoverage1 = getsCoveredByArea(of: longRect1, rect: obs.boundingBox)
                        if areaCoverage1>minAreaCoverage {
                            let i = listOfPricesWithObservations.firstIndex { line in
                                line.pairStringDouble.o == oFirst
                            }
                            listOfPricesWithObservations[i!].otherObservations.append(obs)
                        }
                    }
                }

                
                // 3. Compute the bigger bounding boxes that contains item+price
                var listOfVisualizations: [VNDetectedObjectObservation] = []
                
                for l in listOfPricesWithObservations.map({ line -> [VNRecognizedTextObservation] in
                    var l = line.otherObservations
                    l.append(line.pairStringDouble.o)
                    return l
                }) {
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
                    listOfVisualizations.append(v)
                }
                
                // 4. Extract pairs of product and price
                var listOfPairProductPrice: [PairProductPrice] = []
                for line in listOfPricesWithObservations {
                    var pairProductPrice = PairProductPrice()
                    pairProductPrice.price = line.pairStringDouble.price

                    // Get content
                    var content = ""
                    var index = 0
                    for o in line.otherObservations {
                        content.append(o.topCandidates(1).first?.string ?? "")
                        index+=1
                        if !(index==line.otherObservations.count) {
                            content.append(" ")
                        }
                    }

                    // Get bounding box
                    var px = 1.0
                    var py = 1.0
                    var w = 0.0
                    var h = 0.0
                    
                    var allBoxes = line.otherObservations
                    allBoxes.append(line.pairStringDouble.o)
                    for o in allBoxes {
                        if o.boundingBox.origin.x<px{
                            px = o.boundingBox.origin.x
                        }
                        if o.boundingBox.origin.y<py{
                            py = o.boundingBox.origin.y
                        }
                    }

                    for o in allBoxes {
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

                    listOfPairProductPrice.append(pairProductPrice)

                }
                
                
                // 5. Result
                textItem.list = listOfPairProductPrice
                
//                print("\(listOfPairProductPrice.count) products found:\n")
//                for p in listOfPairProductPrice{
//                    print("\(p.name) - \(p.price)")
//                }
//
//                var s1 = 0.0
//                for p in listOfPairProductPrice {
//                    s1 += p.price
//                }
//                print("\nTotal computed = \(round(s1 * 100) / 100.0)\n______________________\n")
            }
        }
        
        recognizeTextRequest.recognitionLevel = .accurate
        recognizeTextRequest.usesLanguageCorrection = true
        recognizeTextRequest.minimumTextHeight = currentMinimumTextHeight
        
        return recognizeTextRequest
    }
    
    
    func removeCurrencySymbols(s: String) -> String {
        var result = ""
        for char in s {
            if !(char.isCurrencySymbol) {
                result.append(char)
            }
        }
        return result
    }
    
}

struct LineWithPrice: Identifiable {
    init(pairStringDouble: PairStringDouble) {
        self.id = pairStringDouble.id
        self.pairStringDouble = pairStringDouble
    }
    
    var id: String
    var pairStringDouble: PairStringDouble
    var otherObservations: [VNRecognizedTextObservation] = []
}
