//
//  HomeView.swift
//  ReceiptSplitter
//
//  Created by Hugo Queinnec on 05/01/2022.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var model: ModelData
    @State private var showAllList = false
    @State private var isValidated = false
    @State private var itemCounter = 0
    @State private var showResult = false
    
    var body: some View {
            NavigationView {
                VStack{
                    
                    CurrentExpensesRow()
                        .padding()
                        .frame(height: 150)
                    
                    Spacer()
                    
                    ZStack{
                        if itemCounter<model.listOfProductsAndPrices.count {
                            
                            ZStack {
                                ForEach(model.listOfProductsAndPrices) { pair in
                                    let number = model.listOfProductsAndPrices.firstIndex(of: pair)!
                                    if itemCounter==number {
                                        AttributionView(pair: $model.listOfProductsAndPrices[number], isValidated: $isValidated, itemCounter: itemCounter)
                                            .onChange(of: isValidated) { newValue in
                                                if newValue {
                                                    itemCounter += 1
                                                    isValidated = false
                                                }
                                            }
                                            //.tint(.blue)

                                    }
                                }
                            }
                            //.animation(.easeInOut, value: model.listOfProductsAndPrices[itemCounter].id)
                            
                        } else {
                            LastItemView(showResult: $showResult)
                                //.animation(.easeInOut)
                        }
                    }
                    .animation(.easeInOut, value: model.listOfProductsAndPrices)
                    .animation(.easeInOut, value: itemCounter)
                    
                    Button {
                        showAllList = true
                    } label: {
                        Label("See all transactions", systemImage: "list.bullet")
                    }
                    .padding(15)
                    
                }
                .navigationBarTitle(Text("ReceiptSplitter"), displayMode: .inline)

        }
        .ignoresSafeArea(.keyboard)
        .transition(.opacity)
        .navigationViewStyle(StackNavigationViewStyle())
        .sheet(isPresented: $showAllList, content: {
            if model.listOfProductsAndPrices.isEmpty {
                VStack {
                    //Text("nothingFound: \(String(nothingFound))")
                    //LoadItemsView(nothingFound: $nothingFound)
                }
            } else {
                if itemCounter<model.listOfProductsAndPrices.count {
                    ListSheetView(itemCounter: itemCounter)
                } else {
                    ListSheetView(itemCounter: -1)
                }
                
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
        HomeView()
            .environmentObject(model)
            .onAppear {
                model.users = [User(name: "Hugo"), User(name: "Lucas"), User(name: "Thomas")]
                model.listOfProductsAndPrices = [PairProductPrice(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBB", name: "Potato Wedges 1kg", price: 4.99), PairProductPrice(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBC", name: "Finger Fish", price: 1.27), PairProductPrice(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBD", name: "Ice Cream Strawberry", price: 3.20)]
            }
    }
}
