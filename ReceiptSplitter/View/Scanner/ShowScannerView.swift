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
    
    var body: some View {
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

                            }
                            if model.listOfProductsAndPrices.isEmpty{
                                //nothingFound = true
                            }
                        }
                        .recognizeText()
                        
                    case .failure(let error):
                        print(error.localizedDescription)
                }
                
//                showScanner = false
//                showAllList = true

            } didCancelScanning: {
                // Dismiss the scanner controller and the sheet.
                model.users = UsersModel().users
                model.listOfProductsAndPrices = []
                withAnimation() {
                    model.startTheProcess = false
                }
                
//                showScanner = false
            }
        }
        .onAppear(perform: {
            print("OK")
            let secondsToDelay = 0.5
            DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
                print("OK2")
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

struct ShowScannerView_Previews: PreviewProvider {
    static var previews: some View {
        ShowScannerView()
    }
}
