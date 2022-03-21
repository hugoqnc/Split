//
//  VisionParameters.swift
//  Split
//
//  Created by Hugo Queinnec on 22/01/2022.
//

import Foundation

struct VisionParameters: Codable { //default values
    var epsilonHeight = 0.5 //multiplicative
    var epsilonHeightAR = 1.0 //multiplicative
    var minAreaCoverage = 0.6
    var minAreaCoverageAR = 0.3
    var maxMargin = 0.2
    var priceMarginRight = 0.3
    var nameMarginLeft = 0.4
    var proportionWithTotal = 0.4
    var contrastFactor = 2.0
    var minimumTextHeight = 0.001
    
    var epsilonFloat = 0.00000001
}
