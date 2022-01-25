//
//  Visualization.swift
//  ReceiptSplitter
//
//  Created by Hugo Queinnec on 22/01/2022.
//

import Foundation
import Vision
import UIKit

public func visualization(_ image: UIImage, observations: [VNDetectedObjectObservation]) -> UIImage {
    var transform = CGAffineTransform.identity
        .scaledBy(x: 1, y: -1)
        .translatedBy(x: 1, y: -image.size.height)
    transform = transform.scaledBy(x: image.size.width, y: image.size.height)

    UIGraphicsBeginImageContextWithOptions(image.size, true, 0.0)
    let context = UIGraphicsGetCurrentContext()

    image.draw(in: CGRect(origin: .zero, size: image.size))
    context?.saveGState()

    context?.setLineWidth(2)
    context?.setLineJoin(CGLineJoin.round)
    context?.setStrokeColor(UIColor.gray.cgColor)
    context?.setLineWidth(2)
    context?.setFillColor(red: 241/255, green: 184/255, blue: 0, alpha: 0.4)

    observations.forEach { observation in
        let bounds = observation.boundingBox.applying(transform)
        //context?.addRect(bounds)
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: 30)
        context?.addPath(path.cgPath)
        
    }

    context?.drawPath(using: CGPathDrawingMode.fillStroke)
    context?.restoreGState()
    let resultImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return resultImage!
}
