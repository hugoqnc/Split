//
//  Extensions.swift
//  Split
//
//  Created by Hugo Queinnec on 02/08/2022.
//

import Foundation
import UIKit
import StoreKit
import SwiftUI

extension Array where Element: Comparable {
    func containsSameElements(as other: [Element]) -> Bool {
        return self.count == other.count && self.sorted() == other.sorted()
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

extension UIColor {
    /// Generate a color from the given string deterministically.
    /// Generated colors are *not* evenly distributed in the HSL color space, but you and/or your users also probably won't be able to tell.
    convenience init(_ string: String, saturation: Double = 0.8, brightness: Double = 0.8) {
        let seed = Double.pi // Can be any positive irrational number. Pi was chosen for flavor.
        let hash = string
            .compactMap { $0.unicodeScalars.first?.value.byteSwapped }
            .map(Double.init)
            .reduce(seed) { (hash, unicodeValue) in
                return (hash * seed * unicodeValue)
                    .truncatingRemainder(dividingBy: 360)
            }

        let hue = hash / 360

        self.init(hue: CGFloat(hue), saturation: CGFloat(saturation), brightness: CGFloat(brightness), alpha: 1.0)
    }
}

extension String { // decode Unicode to UTF8
    var decoded : String {
        let data = self.data(using: .utf8)
        let message = String(data: data!, encoding: .nonLossyASCII) ?? ""
        return message
    }
}

extension SKStoreReviewController {
    public static func requestReviewInCurrentScene() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            requestReview(in: scene)
        }
    }
}

struct CustomColor {
    static let bankGreen = Color(red: 30 / 255, green: 225 / 255, blue: 149 / 255)
    static let realPink = Color(red: 255 / 255, green: 101 / 255, blue: 227 / 255)
}
