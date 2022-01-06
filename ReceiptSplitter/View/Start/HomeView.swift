//
//  ContentView.swift
//  ScanAndRecognizeText
//
//  Created by Gabriel Theodoropoulos.
//

import SwiftUI
import simd

struct HomeView: View {
    @ObservedObject var recognizedContent = TextData()
    @State var showScanner = true // TODO: add private when done, and remove Preview
    @State private var isRecognizing = false
    @State private var isValidated = false
    @State private var itemCounter = 0
    
    @State private var listOfProductsAndPrices: [PairProductPrice] = []
    
    
    var body: some View {
        NavigationView {
            ZStack() {
                VStack{

//                    ForEach(recognizedContent.items, id: \.id) { textItem in
//                        List() {
//                            ForEach(textItem.list) { pair in
//                                HStack {
//                                    Text(pair.name)
//                                    Spacer()
//                                    Text(String(pair.price)+"€")
//                                }
//                            }
//                        }
//                    }
                    CurrentExpensesRow()

                    if itemCounter<listOfProductsAndPrices.count {
                        AttributionView(pair: listOfProductsAndPrices[itemCounter], isValidated: $isValidated)
                            .onChange(of: isValidated) { newValue in
                                print("AAA")
                                print(newValue)
                                print(isValidated)
                                print(listOfProductsAndPrices.count)
                                print(itemCounter)
                                print("AAAA")
                                if newValue {
                                    itemCounter += 1
                                    isValidated = false
                                }
                        }
                    } else {
                        Text("E1")
                    }


                }
                
                
                if isRecognizing {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(2)
                }
                
            }
            .navigationTitle("ReceiptSplitter")
            

        }
        .sheet(isPresented: $showScanner, content: {
            ScannerView { result in
                switch result {
                    case .success(let scannedImages):
                        isRecognizing = true
                        
                        TextRecognition(scannedImages: scannedImages,
                                        recognizedContent: recognizedContent) {
                            for item in recognizedContent.items{
                                let content: [PairProductPrice] = item.list
                                listOfProductsAndPrices.append(contentsOf: content)
                            }
                            // print(listOfProductsAndPrices)
                        }
                        .recognizeText()
                    
                        // Text recognition is finished, hide the progress indicator.

                        isRecognizing = false
                        
                    case .failure(let error):
                        print(error.localizedDescription)
                }
                
                showScanner = false
                
            } didCancelScanning: {
                // Dismiss the scanner controller and the sheet.
                showScanner = false
            }
        })
    }
}

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView(showScanner: false)
//    }
//}
