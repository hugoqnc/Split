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
    @State private var goesBack = false
    @State public var itemCounter = 0 // public for preview purposes
    @State private var showResult = false
    @State private var firstCardAppear = false
    @State private var quitConfirmation = false
    @State private var showTutorialScreen = false
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass //for iPad specificity
    
    var body: some View {
        if showResult {
            ResultView()
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
                    
                    if horizontalSizeClass == .compact {
                        Spacer()
                    } else {
                        VStack(spacing: 4) {
                            Spacer()
                            Text("Split!")
                                .font(.largeTitle)
                                .foregroundColor(.secondary)
                                .opacity(0.5)
                            Text("Designed to facilitate fair sharing")
                                .font(.title2)
                                .foregroundColor(.secondary)
                                .opacity(0.5)
                            Spacer()
                        }
                        .animation(.easeInOut, value: firstCardAppear)
                        .animation(.easeInOut, value: itemCounter)
                    }
                    
                    
                    ZStack{
                        if firstCardAppear {
                            Group {
                                if itemCounter<model.listOfProductsAndPrices.count {
                                    ZStack {
                                        ForEach(model.listOfProductsAndPrices) { pair in
                                            let number = model.listOfProductsAndPrices.firstIndex(of: pair)!
                                            if itemCounter==number {
                                                AttributionCard(pair: $model.listOfProductsAndPrices[number], isValidated: $isValidated, goesBack: $goesBack, itemCounter: itemCounter, initialSelection: model.listOfProductsAndPrices[number].chosenBy == [] ? (model.parameters.selectAllUsers ? model.users.map({ user in user.id }) : []) : model.listOfProductsAndPrices[number].chosenBy)
                                                    .onChange(of: isValidated) { newValue in
                                                        if newValue {
                                                            itemCounter += 1
                                                            isValidated = false
                                                        }
                                                    }
                                                    .onChange(of: goesBack) { newValue in
                                                        if newValue && itemCounter > 0 {
                                                            itemCounter -= 1
                                                        }
                                                    }
                                                    .padding(.horizontal, horizontalSizeClass ==  .compact ? 0 : 50)

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
                .padding(.horizontal, horizontalSizeClass ==  .compact ? 0 : 60)
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
                    showTutorialScreen = model.parameters.showAttributionTutorial
                }
            })
            .sheet(isPresented: $showAllList, content: {
                if itemCounter<model.listOfProductsAndPrices.count {
                    ListSheetView(itemCounter: $itemCounter)
                } else {
                    ListSheetView(itemCounter: .constant(-1))
                }
            })
            .slideOverCard(isPresented: $showTutorialScreen, content: {
                VStack {
                    AttributionTutorialView()
                    Button {
                        showTutorialScreen = false
                        model.parameters.showAttributionTutorial = false
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
                    .padding(.top,10)
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
            }
            //.previewInterfaceOrientation(.portraitUpsideDown)
    }
}
