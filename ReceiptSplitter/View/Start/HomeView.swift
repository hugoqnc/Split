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
    @State private var isRecognizing = false
    @State private var isValidated = false
    @State private var itemCounter = 0
    
    //@State private var listOfProductsAndPrices: [PairProductPrice] = []
    
    
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
                        .padding()
                        .frame(height: 100)
                    
                    Spacer()
                    
                    if itemCounter<model.listOfProductsAndPrices.count {
                        AttributionView(pair: $model.listOfProductsAndPrices[itemCounter], isValidated: $isValidated, itemCounter: itemCounter)
                            .onChange(of: isValidated) { newValue in
                                print("AAA")
                                print(newValue)
                                print(isValidated)
                                print(model.listOfProductsAndPrices.count)
                                print(model.listOfProductsAndPrices)
                                print(model.listOfProductsAndPrices[itemCounter])
                                print(itemCounter)
                                print("AAAA")
                                if newValue {
                                    itemCounter += 1
                                    isValidated = false
                                }
                        }
                    } else {
                        Text("Finished")
                    }
                    
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
                    
                } didCancelScanning: {
                    // Dismiss the scanner controller and the sheet.
                    showScanner = false
                }
            }.ignoresSafeArea(.all)
        })
        .sheet(isPresented: $showAllList, content: {
            VStack{
                List() {
                    Section(header: Text("All transactions")){
                    ForEach(model.listOfProductsAndPrices) { pair in
                        HStack {
                            if pair.id == model.listOfProductsAndPrices[itemCounter].id {
                                VStack(alignment: .leading) {
                                    Text("Current item".uppercased())
                                        .font(.caption)
                                        .padding(.top,3)
                                    Text(pair.name)
                                }
                            } else {
                                Text(pair.name)
                            }
                            
                            Spacer()
                            Text(String(pair.price)+"€")
                        }
                        .foregroundColor(pair.id == model.listOfProductsAndPrices[itemCounter].id ? .blue : nil)
                    }
                    }
                }
            }
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
