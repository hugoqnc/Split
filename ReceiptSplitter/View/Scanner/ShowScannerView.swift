//
//  ShowScannerView.swift
//  ReceiptSplitter
//
//  Created by Hugo Queinnec on 20/01/2022.
//

import SwiftUI

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
                ScannerView { result in
                    switch result {
                        case .success(let scannedImages):
                            
                            TextRecognition(scannedImages: scannedImages,
                                            recognizedContent: recognizedContent) {
                                for item in recognizedContent.items{
                                    if !model.listOfProductsAndPrices.contains(item.list.first ?? PairProductPrice()){
                                        let content: [PairProductPrice] = item.list
                                        model.listOfProductsAndPrices.append(contentsOf: content)
                                    }
                                    model.images.append(item.image)
                                }
                                if model.listOfProductsAndPrices.isEmpty{
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
                    model.users = UsersModel().users
                    model.listOfProductsAndPrices = []
                    withAnimation() {
                        model.startTheProcess = false
                    }
                }
            }
            .onAppear(perform: {
                let secondsToDelay = 0.7
                DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
                    showTutorialScreen = true
                }
            })
            .ignoresSafeArea(.all)
            .transition(.move(edge: .bottom))
            .sheet(isPresented: $showTutorialScreen, content: {
                TutorialView()

                Button {
                    showTutorialScreen=false
                } label: {
                    Label("OK", systemImage: "checkmark")
                }
                .buttonStyle(.borderedProminent)
                .padding()
        })
        }
    }
}

//struct ShowScannerView_Previews: PreviewProvider {
//    static var previews: some View {
//        ShowScannerView()
//    }
//}
