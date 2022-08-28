//
//  ShowScannerView.swift
//  Split
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
    
    @State var successCount = 0 //for Advanced Recognition
    @State var listOfProductsAndPricesTemp: [PairProductPrice] = []

    
    var body: some View {
        if showScanningResults {
            FirstListView(showScanningResults: $showScanningResults, nothingFound: $nothingFound)
        } else {
            HStack {
                if !showTutorialScreen {
                    ScannerView { result in
                        switch result {
                            case .success(let scannedImages):
                            if model.parameters.advancedRecognition {
                                successCount = 0
                                listOfProductsAndPricesTemp = []
                                
                                TextRecognitionAdvanced(scannedImages: scannedImages,
                                                recognizedContent: recognizedContent,
                                                visionParameters: model.parameters.visionParameters) { isLastImage in
                                    for item in recognizedContent.items{
                                        //print("BOOL: \(!model.listOfProductsAndPrices.contains(item.list.first ?? PairProductPrice()))")
                                        if !model.listOfProductsAndPrices.contains(item.list.first ?? PairProductPrice()){
                                            let content: [PairProductPrice] = item.list
                                            listOfProductsAndPricesTemp.append(contentsOf: content)
                                            model.addNameToReceipt(name: item.name)
                                            if !content.isEmpty {
                                                successCount += 1
                                            }
                                        }
                                        model.images.append(item.image)
                                    }
                                    if isLastImage {
                                        //print("Success: \(successCount) | Images: \(model.images.count)")
                                        if successCount != model.images.count {
                                            nothingFound = true
                                        } else {
                                            model.listOfProductsAndPrices = listOfProductsAndPricesTemp
                                        }
                                    }
                                    recognizedContent.items = []
                                }
                                .recognizeText()
                            } else {
                                TextRecognition(scannedImages: scannedImages,
                                                recognizedContent: recognizedContent,
                                                visionParameters: model.parameters.visionParameters) { isLastImage in
                                    for item in recognizedContent.items{
                                        if !model.listOfProductsAndPrices.contains(item.list.first ?? PairProductPrice()){
                                            let content: [PairProductPrice] = item.list
                                            model.listOfProductsAndPrices.append(contentsOf: content)
                                            model.addNameToReceipt(name: item.name)
                                        }
                                        model.images.append(item.image)
                                    }
                                    if model.listOfProductsAndPrices.isEmpty && isLastImage {
                                        nothingFound = true
                                    }
                                    recognizedContent.items = []
                                }
                                .recognizeText()
                            }
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
                VStack {
                    ScanTutorialView(advancedRecognition: $model.parameters.advancedRecognition)
                    Button {
                        showTutorialScreen = false
                        model.parameters.showScanTutorial = false
                        ParametersStore.save(parameters: model.parameters) { result in
                            switch result {
                            case .failure(let error):
                                fatalError(error.localizedDescription)
                            case .success(_):
                                print("Settings Saved")
                            }
                        }
                    } label: {
                        Text("OK, do not show again")
                            .font(Font.footnote)
                    }
                    .padding(.top,5)
                }
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
