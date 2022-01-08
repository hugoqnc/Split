//
//  ContentView.swift
//  ScanAndRecognizeText
//
//  Created by Gabriel Theodoropoulos.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var model: ModelData
    @ObservedObject var recognizedContent = TextData()
    @State var showScanner = true // TODO: add private when done, and remove Preview
    @State  var showAllList = false // TODO: add private when done, and remove Preview
    @State private var isFirstTimeShowingList = true
    @State private var isValidated = false
    @State private var itemCounter = 0
    
    var body: some View {
        NavigationView {
            VStack{
                
                if itemCounter<model.listOfProductsAndPrices.count {
                    
                    CurrentExpensesRow()
                        .padding()
                        .frame(height: 100)
                    
                    Spacer()
                    
                    ZStack {
                        ForEach(model.listOfProductsAndPrices) { pair in
                            let number = model.listOfProductsAndPrices.firstIndex(of: pair)!
                            Text(String(number))
                                .offset(x: CGFloat(10*number), y: 0.0)
                            if itemCounter==number {
                                AttributionView(pair: $model.listOfProductsAndPrices[number], isValidated: $isValidated, itemCounter: itemCounter)
                                    .onChange(of: isValidated) { newValue in
                                        if newValue {
                                            itemCounter += 1
                                            isValidated = false
                                        }
                                    }

                            }
                        }
                    }
                    .animation(.easeInOut, value: model.listOfProductsAndPrices[itemCounter].id)
                    //.animation(.easeInOut)
                    
                    Button {
                        showAllList = true
                    } label: {
                        Label("See all transactions", systemImage: "list.bullet")
                    }
                    .padding(15)
                    
                } else {
                    if !isFirstTimeShowingList {
                        ResultView()
                    }
                }
                
            }
            .navigationTitle("ReceiptSplitter")
            

        }
        .sheet(isPresented: $showScanner, content: {
            HStack {
                ScannerView { result in
                    switch result {
                        case .success(let scannedImages):
                            
                            TextRecognition(scannedImages: scannedImages,
                                            recognizedContent: recognizedContent) {
                                for item in recognizedContent.items{
                                    let content: [PairProductPrice] = item.list
                                    model.listOfProductsAndPrices.append(contentsOf: content)
                                }
                                // print(listOfProductsAndPrices)
                            }
                            .recognizeText()
                            
                        case .failure(let error):
                            print(error.localizedDescription)
                    }
                    
                    showScanner = false
                    showAllList = true

                } didCancelScanning: {
                    // Dismiss the scanner controller and the sheet.
                    model.startTheProcess = false
                    model.users = UsersModel().users
                    model.listOfProductsAndPrices = []
                    
                    showScanner = false
                }
            }.ignoresSafeArea(.all)
        })
        .sheet(isPresented: $showAllList, content: {
            if model.listOfProductsAndPrices.isEmpty {
                LoadItemsView()
            } else {
                ListSheetView(itemCounter: itemCounter, isFirstTimeShowingList: $isFirstTimeShowingList)
            }
        })
    }
}

struct HomeView_Previews: PreviewProvider {
    static let model = ModelData()
    static var previews: some View {
        HomeView(showScanner: false, showAllList: false)
            .environmentObject(model)
            .onAppear {
                model.users = [User(name: "Hugo"), User(name: "Lucas"), User(name: "Thomas")]
                model.listOfProductsAndPrices = [PairProductPrice(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBB", name: "Potato Wedges 1kg", price: 4.99), PairProductPrice(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBC", name: "Finger Fish", price: 1.27), PairProductPrice(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBD", name: "Ice Cream Strawberry", price: 3.20)]
            }
    }
}
