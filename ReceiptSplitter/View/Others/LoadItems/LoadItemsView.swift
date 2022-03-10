//
//  LoadItemsView.swift
//  ReceiptSplitter
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
    
    var body: some View {
        if nothingFound {
            VStack {
                VStack {
                    if model.parameters.bigRecognition {
                        NoMatchFound()
                        Button {
                            model.eraseScanData()
                            nothingFound = false
                            withAnimation() {
                                showScanningResults = false
                            }
                            
                        } label: {
                            HStack {
                                Spacer()
                                VStack(spacing: 3) {
                                    Label("Try again", systemImage: "arrow.clockwise")
                                        .font(.headline)
                                    Text("with Advanced Recognition")
                                        .font(.caption)
                                        .multilineTextAlignment(.leading)
                                }
                                Spacer()
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .padding(.horizontal, 25)
                        .padding(.bottom,5)
                        .padding(.top,5)
                        
                        Button {
                            let scannedImages = model.images.map({ idImage in return idImage.image! })
                            
                            model.eraseScanData()
                            nothingFound = false
                            model.parameters.bigRecognition = false
                            
                            
                            TextRecognition(scannedImages: scannedImages,
                                            recognizedContent: recognizedContent,
                                            visionParameters: model.parameters.visionParameters) { isLastImage in
                                for item in recognizedContent.items{
                                    if !model.listOfProductsAndPrices.contains(item.list.first ?? PairProductPrice()){
                                        let content: [PairProductPrice] = item.list
                                        model.listOfProductsAndPrices.append(contentsOf: content)
                                    }
                                    model.images.append(item.image)
                                }
                                if model.listOfProductsAndPrices.isEmpty && isLastImage {
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
                            model.eraseScanData()
                            nothingFound = false
                            withAnimation() {
                                showScanningResults = false
                            }
                            
                        } label: {
                            Label("Try again", systemImage: "arrow.clockwise")
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
