//
//  VisionParameters.swift
//  ReceiptSplitter
//
//  Created by Hugo Queinnec on 22/01/2022.
//

import Foundation

struct VisionParameters: Codable { //default values
    var epsilonHeight = 0.5 //multiplicative
    var minAreaCoverage = 0.6
    var maxMargin = 0.2
}
