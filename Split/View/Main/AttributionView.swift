//
//  HomeView.swift
//  Split
//
//  Created by Hugo Queinnec on 05/01/2022.
//

import SwiftUI

struct AttributionView: View {
    @EnvironmentObject var model: ModelData
    @State private var showAllList = false
    @State private var isValidated = false
    @State private var itemCounter = 0
    @State private var showResult = false
    @State private var firstCardAppear = false
    @State private var quitConfirmation = false
    
    var body: some View {
        if showResult {
            ResultView()
                //.transition(.slide)
        } else {
            NavigationView {
                VStack{
                    
                    CurrentExpensesRow(isValidated: $isValidated)
                        .padding()
                        .frame(height: 150)
                    
                    if !model.listOfProductsAndPrices.isEmpty {
                        ProgressView(value: Double(itemCounter)/Double(model.listOfProductsAndPrices.count))
                            .animation(.easeInOut, value: itemCounter)
                            .animation(.easeInOut, value: model.listOfProductsAndPrices.count)
                            .padding(.horizontal)
                            .padding(.top, 10)
                    }
                    
                    Spacer()
                    
                    ZStack{
                        if firstCardAppear {
                            Group {
                                if itemCounter<model.listOfProductsAndPrices.count {
                                    ZStack {
                                        ForEach(model.listOfProductsAndPrices) { pair in
                                            let number = model.listOfProductsAndPrices.firstIndex(of: pair)!
                                            if itemCounter==number {
                                                AttributionCard(pair: $model.listOfProductsAndPrices[number], isValidated: $isValidated, itemCounter: itemCounter, initialSelection: model.parameters.selectAllUsers ? model.users.map({ user in user.id }) : [])
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
                                    .transition(itemCounter==0 ? .asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)) : .asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .leading)))
                                    
                                } else {
                                    LastItemView(showResult: $showResult)
                                }
                            }
                        }
                    }
                    .animation(.easeInOut, value: model.listOfProductsAndPrices)
                    .animation(.easeInOut, value: itemCounter)
                    .animation(.easeInOut, value: firstCardAppear)
                    
                    Button {
                        showAllList = true
                    } label: {
                        Label("All transactions", systemImage: "list.bullet")
                    }
                    .padding(15)
                    
                }
                .navigationBarTitle(Text(model.receiptName), displayMode: .inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            withAnimation() {
                                quitConfirmation = true
                            }
                        } label: {
                            Text("Quit")
                        }
                        .tint(.red)
                        .confirmationDialog(
                            "If you quit now, you will lose your progress and nothing will be saved.",
                             isPresented: $quitConfirmation,
                            titleVisibility: .visible
                        ) {
                            Button("Quit", role: .destructive) {
                                model.eraseModelData()
                            }
                        }
                    }
                }

            }
            .ignoresSafeArea(.keyboard)
            .transition(.opacity)
            .navigationViewStyle(StackNavigationViewStyle())
            .onAppear(perform: {
                let secondsToDelay = 0.35
                DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
                    firstCardAppear = true
                }
            })
            .sheet(isPresented: $showAllList, content: {
                if model.listOfProductsAndPrices.isEmpty {
                    VStack {
                        //Text("nothingFound: \(String(nothingFound))")
                        //LoadItemsView(nothingFound: $nothingFound)
                    }
                } else {
                    if itemCounter<model.listOfProductsAndPrices.count {
                        ListSheetView(itemCounter: $itemCounter)
                    } else {
                        ListSheetView(itemCounter: .constant(-1))
                    }
                    
                }
            })
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static let model = ModelData()
    static var previews: some View {
        AttributionView()
            .environmentObject(model)
            .onAppear {
                model.users = [User(name: "Hugo"), User(name: "Lucas"), User(name: "Thomas")]
                model.listOfProductsAndPrices = [PairProductPrice(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBB", name: "Potato Wedges 1kg", price: 4.99), PairProductPrice(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBC", name: "Finger Fish", price: 1.27), PairProductPrice(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBD", name: "Ice Cream Strawberry", price: 3.20)]
                model.parameters.selectAllUsers = false
                model.receiptName = "ALDI SUISSE"
            }
    }
}
