//
//  ContentView.swift
//  ScanAndRecognizeText
//
//  Created by Gabriel Theodoropoulos.
//

import SwiftUI
import simd

struct HomeView: View {
    @EnvironmentObject var model: ModelData
    @ObservedObject var recognizedContent = TextData()
    @State var showScanner = true // TODO: add private when done, and remove Preview
    @State private var showAllList = false
    @State private var isFirstTimeShowingList = true
    @State private var isRecognizing = false
    @State private var isValidated = false
    @State private var itemCounter = 0
    
    //@State private var listOfProductsAndPrices: [PairProductPrice] = []
    
    
    var body: some View {
        NavigationView {
            ZStack() {
                VStack{

                    CurrentExpensesRow()
                        .padding()
                        .frame(height: 100)
                    
                    Spacer()
                    
                    ZStack{
                        if itemCounter<model.listOfProductsAndPrices.count {
                            ZStack {
                                ForEach(0..<model.listOfProductsAndPrices.count) { number in
                                    if number==itemCounter {
                                        AttributionView(pair: $model.listOfProductsAndPrices[number], isValidated: $isValidated, itemCounter: itemCounter)
                                            .onChange(of: isValidated) { newValue in
                                                if newValue {
                                                    itemCounter += 1
                                                    isValidated = false
                                                }
                                            }
                                            .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                                    }
                                }
                            }
                            
                        } else {
                            Text("Finished")
                        }
                    }
                    .animation(.easeInOut, value: itemCounter)
                    
                    Spacer()
                    
                    Button {
                        showAllList = true
                    } label: {
                        Label("See all list", systemImage: "list.bullet")
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(15)


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
            HStack {
                ScannerView { result in
                    switch result {
                        case .success(let scannedImages):
                            isRecognizing = true
                            
                            TextRecognition(scannedImages: scannedImages,
                                            recognizedContent: recognizedContent) {
                                for item in recognizedContent.items{
                                    let content: [PairProductPrice] = item.list
                                    model.listOfProductsAndPrices.append(contentsOf: content)
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
                    showAllList = true

                } didCancelScanning: {
                    // Dismiss the scanner controller and the sheet.
                    showScanner = false
                }
            }.ignoresSafeArea(.all)
        })
        .sheet(isPresented: $showAllList, content: {
            ListSheetView(listOfProductsAndPrices: model.listOfProductsAndPrices, itemCounter: itemCounter, isFirstTimeShowingList: $isFirstTimeShowingList)
                .background(Color(red: 255 / 255, green: 255 / 255, blue: 55 / 255).opacity(0.2).ignoresSafeArea(.all))
        })
    }
}

struct HomeView_Previews: PreviewProvider {
    static let model = ModelData()
    static var previews: some View {
        HomeView(showScanner: false)
            .environmentObject(model)
            .onAppear {
                model.users = [User(name: "Hugo"), User(name: "Lucas"), User(name: "Thomas")]
                model.listOfProductsAndPrices = [PairProductPrice(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBB", name: "Potato Wedges 1kg", price: 4.99), PairProductPrice(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBC", name: "Finger Fish", price: 1.27), PairProductPrice(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBD", name: "Ice Cream Strawberry", price: 3.20)]
            }
    }
}
