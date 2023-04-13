//
//  LoadItemsView.swift
//  Split
//
//  Created by Hugo Queinnec on 08/01/2022.
//

import SwiftUI

struct LoadItemsView: View {
    @Binding var showScanningResults : Bool
    @Binding var nothingFound: Bool
    @EnvironmentObject var model: ModelData
    @Environment(\.dismiss) var dismiss
    @ObservedObject var recognizedContent = TextData()
    
    @State private var nothingFoundWithSecondTry = false
    
    var body: some View {
        if nothingFound {
            VStack {
                VStack {
                    if model.parameters.advancedRecognition && !nothingFoundWithSecondTry {
                        NoMatchFound()
                        Button {
                            if model.photoIsImported {
                                model.eraseModelData(eraseScanFails: false, fast: true)
                            } else {
                                model.eraseScanData()
                            }
                            nothingFound = false
                            withAnimation() {
                                showScanningResults = false
                            }
                            
                        } label: {
                            HStack {
                                Spacer()
                                VStack(spacing: 3) {
                                    Label(model.photoIsImported ? "Go back" : "Try again", systemImage: "arrow.clockwise")
                                        .font(.headline)
                                    Text(model.photoIsImported ? "and start again" : "with Advanced Recognition")
                                        .font(.caption)
                                        .multilineTextAlignment(.leading)
                                }
                                Spacer()
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(model.photoIsImported ? .red : .accentColor)
                        .padding(.horizontal, 25)
                        .padding(.bottom,5)
                        .padding(.top,5)
                        
                        Button {
                            let scannedImages = model.images.map({ idImage in return idImage.image! })
                            
                            model.eraseScanData()
                            nothingFound = false
                            
                            
                            TextRecognition(scannedImages: scannedImages,
                                            recognizedContent: recognizedContent,
                                            visionParameters: model.parameters.visionParameters) { isLastImage in
                                for item in recognizedContent.items{
                                    if !model.listOfProductsAndPrices.contains(item.list.first ?? PairProductPrice()){
                                        let content: [PairProductPrice] = item.list
                                        if !content.isEmpty {
                                            model.continueWithStandardRecognition = true
                                        }
                                        model.listOfProductsAndPrices.append(contentsOf: content)
                                        model.addNameToReceipt(name: item.name)
                                    }
                                    model.images.append(item.image)
                                }
                                if model.listOfProductsAndPrices.isEmpty && isLastImage {
                                    nothingFoundWithSecondTry = true
                                    nothingFound = true
                                }
                                recognizedContent.items = []
                            }
                            .recognizeText()
                        
                        } label: {
                            HStack {
                                Spacer()
                                VStack(spacing: 3) {
                                    Label("Continue", systemImage: "arrow.right")
                                        .font(.headline)
                                    Text("without Advanced Recognition for once")
                                        .font(.caption)
                                        .multilineTextAlignment(.leading)
                                }
                                Spacer()
                            }
                        }
                        .buttonStyle(.bordered)
                        .padding(.horizontal, 25)
                        .padding(.bottom,10)
                        
                    } else {
                        NoItemFound()
                        
                        Button {
                            if model.photoIsImported {
                                model.eraseModelData(eraseScanFails: false, fast: true)
                            } else {
                                model.eraseScanData()
                            }
                            nothingFound = false
                            nothingFoundWithSecondTry = false
                            withAnimation() {
                                showScanningResults = false
                            }
                            
                        } label: {
                            Label(model.photoIsImported ? "Start again" : "Try again", systemImage: "arrow.clockwise")
                        }
                        .buttonStyle(.bordered)
                        .padding(.bottom,10)
                        .padding(.top,5)
                    }
                }
                .padding(10)
                .frame(maxWidth: 400)
            }
            .background(Color(uiColor: UIColor.systemBackground).brightness(0.06))
            .cornerRadius(10)
            .shadow(color: .black.opacity(0.2), radius: 15.0)
            .padding()
            
        } else {
            ZStack {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    //.scaleEffect(2)
            }
        }
    }
    
}

struct LoadItemsView_Previews: PreviewProvider {
    static var previews: some View {
        LoadItemsView(showScanningResults: .constant(true), nothingFound: .constant(true))
            .environmentObject(ModelData())
    }
}
