//
//  ShowScannerView.swift
//  ReceiptSplitter
//
//  Created by Hugo Queinnec on 20/01/2022.
//

import SwiftUI
import SlideOverCard

struct ShowScannerView: View {
    @EnvironmentObject var model: ModelData
    @ObservedObject var recognizedContent = TextData()
    @State private var showTutorialScreen = false
    @State private var showScanningResults = false
    @State private var nothingFound = false
    
    var body: some View {
        if showScanningResults {
            FirstListView(showScanningResults: $showScanningResults, nothingFound: $nothingFound)
        } else {
            HStack {
                if !showTutorialScreen {
                    ScannerView { result in
                        switch result {
                            case .success(let scannedImages):
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
                            case .failure(let error):
                                print(error.localizedDescription)
                        }
                        withAnimation() {
                            showScanningResults = true
                        }

                    } didCancelScanning: {
                        // Dismiss the scanner controller and the sheet.
                        withAnimation() {
                            model.eraseModelData()
                        }
                    }
                } else {
                    //black screen
                    HStack {
                        VStack{
                            Text("")
                            Spacer()
                        }
                        Spacer()
                    }
                    .background(.black)
                }
            }
            .onAppear(perform: {
                let secondsToDelay = 0.6
                DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
                    showTutorialScreen = model.parameters.showScanTutorial
                }
            })
            .transition(.move(edge: .bottom))
            .slideOverCard(isPresented: $showTutorialScreen, content: {
                ScanTutorialView()
            })
            .ignoresSafeArea(.all)
        }
    }
}

//struct ShowScannerView_Previews: PreviewProvider {
//    static var previews: some View {
//        ShowScannerView()
//    }
//}
