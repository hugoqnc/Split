//
//  FirstListView.swift
//  ReceiptSplitter
//
//  Created by Hugo Queinnec on 20/01/2022.
//

import SwiftUI
import UIKit
import Vision

struct FirstListView: View {
    @EnvironmentObject var model: ModelData
    @Binding var showScanningResults: Bool
    @Binding var nothingFound: Bool

    var body: some View {

        VStack {
            
            if model.listOfProductsAndPrices.isEmpty {
                VStack {
                    LoadItemsView(showScanningResults: $showScanningResults, nothingFound: $nothingFound)
                }
            } else {
    //            VStack {
    //                Image(systemName: "exclamationmark.triangle")
    //                    .resizable(resizingMode: .tile)
    //                    .frame(width: 30.0, height: 30.0)
    //                    .foregroundColor(.orange)
    //                    .padding(.top)
    //                Text("Please check that most of the transactions are correct, meaning that most names are associated with the right prices. If it is not the case, please cancel and start again.")
    //                    .padding(.top,3)
    //                    .padding(.bottom)
    //                    .padding(.leading)
    //                    .padding(.trailing)
    //            }
                
                NavigationView {
                    
                    VStack{
                        Text("Receipt Image")

                        ForEach(model.images){ idImage in
                            if let image = idImage.image {
                                let boxes = model.listOfProductsAndPrices.compactMap({ pair -> VNDetectedObjectObservation? in
                                    if pair.imageId==idImage.id && !(pair.box == nil){
                                        return pair.box!
                                    }
                                    return nil
                                })
                                Image(uiImage: visualization(image, observations: boxes))
                                    .resizable()
                                    .scaledToFit()
                            }
                        }

                        List() {
                            Section(header: Text("\(model.listOfProductsAndPrices.count) transactions — \(model.showPrice(price: model.totalPrice))")){
                                ForEach(model.listOfProductsAndPrices) { pair in
                                    HStack {
                                        Text(pair.name)
                                        Spacer()
                                        Text(String(pair.price)+model.currency.value)
                                    }
                                }
                            }
                        }
                    }
                    .toolbar {
                        ToolbarItem(placement: .bottomBar) {
                            Button {
                                model.listOfProductsAndPrices = []
                                model.images = []
                                
                                withAnimation() {
                                    showScanningResults = false
                                }
                            } label: {
                                Text("Cancel")
                            }
                            .padding()
                            .foregroundColor(.red)
                        }
                        ToolbarItem(placement: .bottomBar) {
                            Button {
                                
                            } label: {
                                Text("Done")
                            }
                            .padding()
                        }
                    }
                    .navigationBarTitle("")
                    .navigationBarHidden(true)
                }
                .navigationViewStyle(StackNavigationViewStyle())
            }
        }
        .background(Color(red: 255 / 255, green: 225 / 255, blue: 51 / 255).opacity(0.2).ignoresSafeArea(.all))
        .transition(.opacity)
    }

}

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
    context?.setStrokeColor(UIColor.black.cgColor)
    context?.setFillColor(red: 241, green: 184, blue: 0, alpha: 0.2)

    observations.forEach { observation in
        let bounds = observation.boundingBox.applying(transform)
        context?.addRect(bounds)
    }

    context?.drawPath(using: CGPathDrawingMode.fillStroke)
    context?.restoreGState()
    let resultImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return resultImage!
}


struct FirstListView_Previews: PreviewProvider {
    static let model = ModelData()
    static var previews: some View {
        FirstListView(showScanningResults: .constant(true), nothingFound: .constant(true))
            .environmentObject(model)
            .onAppear {
                model.users = [User(name: "Hugo"), User(name: "Lucas"), User(name: "Thomas")]
                model.listOfProductsAndPrices = [
                    PairProductPrice(id: "EC7017DC-8A53-4E98-B738-036A6581A6AA", name: "1L Nectar Goyave", price: 3.0, isNewItem: false, imageId: Optional("1111"), box: VNDetectedObjectObservation(boundingBox: CGRect(x: 0.0960523, y: 0.875845, width: 0.78441, height: 0.080671))),
                    PairProductPrice(id: "EC7017DC-8A53-4E98-B738-036A6581A6AB", name: "250G Camembert CDL", price: 1.75, isNewItem: false, imageId: Optional("1111"), box: VNDetectedObjectObservation(boundingBox: CGRect(x: 0.0958873, y: 0.767238, width: 0.783298, height: 0.0783178))),
                    PairProductPrice(id: "EC7017DC-8A53-4E98-B738-036A6581A6AC", name: "2x125g Palets Bret", price: 1.3, isNewItem: false, imageId: Optional("1111"), box: VNDetectedObjectObservation(boundingBox: CGRect(x: 0.1399, y: 0.64551, width: 0.739269, height: 0.0893237))),
                    PairProductPrice(id: "EC7017DC-8A53-4E98-B738-036A6581A6AD", name: "Courgette", price: 2.19, isNewItem: false, imageId: Optional("2222"), box: VNDetectedObjectObservation(boundingBox: CGRect(x: 0.0960523, y: 0.875845, width: 0.78441, height: 0.080671))),
                    PairProductPrice(id: "EC7017DC-8A53-4E98-B738-036A6581A6AE", name: "DCH LPM Verv Citro", price: 3.85, isNewItem: false, imageId: Optional("2222"), box: VNDetectedObjectObservation(boundingBox: CGRect(x: 0.0973473, y: 0.765197, width: 0.782281, height: 0.0958386)))]
                model.images = [IdentifiedImage(id: "1111", image: UIImage(named: "scan1")), IdentifiedImage(id: "2222", image: UIImage(named: "scan2"))]
            }
    }
}

