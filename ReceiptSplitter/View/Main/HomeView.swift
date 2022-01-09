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
    @State private var showScanner = false
    @State private var showAllList = false
    @State var isFirstTimeShowingList = true //TODO: change
    @State private var isValidated = false
    @State private var itemCounter = 0
    @State private var isKeyboardShown = false
    @State private var showResult = false
    
    var body: some View {
            NavigationView {
                VStack{
                    if itemCounter<model.listOfProductsAndPrices.count {
                        
                        CurrentExpensesRow()
                            .padding()
                            .frame(height: 150)
                        
                        Spacer()
                        
                        ZStack {
                            ForEach(model.listOfProductsAndPrices) { pair in
                                let number = model.listOfProductsAndPrices.firstIndex(of: pair)!
                                if itemCounter==number {
                                    AttributionView(pair: $model.listOfProductsAndPrices[number], isValidated: $isValidated, itemCounter: itemCounter)
                                        .onChange(of: isValidated) { newValue in
                                            if newValue {
                                                itemCounter += 1
                                                isValidated = false
                                                if itemCounter==model.listOfProductsAndPrices.count && !isFirstTimeShowingList{
                                                        showResult = true
                                                }
                                            }
                                        }

                                }
                            }
                        }
                        .animation(.easeInOut, value: model.listOfProductsAndPrices[itemCounter].id)
                        
                        Button {
                            showAllList = true
                        } label: {
                            Label("See all transactions", systemImage: "list.bullet")
                        }
                        .padding(15)
                        
                    } else {
                        Text("Hello World") //TODO: we are here if we delete all items
                    }
                    
                    if showScanner{
                        // Weird SwiftUI bug: this invisible text is necessary to open the scanner onAppear of HomeView
                        Text(String(showScanner))
                    }
                    
                }
                .navigationTitle("ReceiptSplitter")
                .navigationBarHidden(isKeyboardShown)
                .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { _ in
                    withAnimation(.easeInOut(duration: 4)) {
                        isKeyboardShown = true
                    }
                }
                .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                    withAnimation(.easeInOut) {
                        isKeyboardShown = false
                    }
                }
                .onAppear {
                    showScanner = true //TODO: change
            }
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
            }
            .ignoresSafeArea(.all)
            .interactiveDismissDisabled(true)
        })
        .sheet(isPresented: $showAllList, content: {
            if model.listOfProductsAndPrices.isEmpty {
                LoadItemsView()
            } else {
                ListSheetView(itemCounter: itemCounter, isFirstTimeShowingList: $isFirstTimeShowingList)
            }
        })
        .sheet(isPresented: $showResult, content: {
            ResultView()
                .interactiveDismissDisabled(true)
        })
    }
}

struct HomeView_Previews: PreviewProvider {
    static let model = ModelData()
    static var previews: some View {
        HomeView(isFirstTimeShowingList: false)
            .environmentObject(model)
            .onAppear {
                model.users = [User(name: "Hugo"), User(name: "Lucas"), User(name: "Thomas")]
                model.listOfProductsAndPrices = [PairProductPrice(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBB", name: "Potato Wedges 1kg", price: 4.99)]//, PairProductPrice(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBC", name: "Finger Fish", price: 1.27), PairProductPrice(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBD", name: "Ice Cream Strawberry", price: 3.20)]
            }
    }
}
