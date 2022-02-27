//
//  AttributionView.swift
//  ReceiptSplitter
//
//  Created by Hugo Queinnec on 05/01/2022.
//

import SwiftUI

struct AttributionCard: View {
    internal init(pair: Binding<PairProductPrice>, isValidated: Binding<Bool>, itemCounter: Int, initialSelection: [UUID]) {
        self._pair = pair
        self._isValidated = isValidated
        self.itemCounter = itemCounter
        self._selections = State(initialValue: initialSelection)
    }
    
    
    @Binding var pair: PairProductPrice
    @Binding var isValidated: Bool
    var itemCounter: Int
    
    @EnvironmentObject var model: ModelData
    @State var selections: [UUID]
    @State private var showAlert1 = false
    @State private var isEditorMode = false
    @State private var showSafariView = false
    
    @State private var createsNewItemCall = false
    @State private var deletesItemCall = false
    
    @State private var xOffset: CGFloat = 0.0
    @State private var yOffset: CGFloat = 0.0
    @State private var opacity = 1.0
    
    static let textOfNewItem = "Additional Product"
        
    var body: some View {
        VStack {
            VStack {
                                
                HStack {
                    VStack(alignment: .leading) {
                    
                        Text(pair.name)
                            .font(.title2)

                        Text(String(pair.price)+model.currency.value)
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.bottom,25)
                            .offset(x: 0, y: 5)
                            .foregroundColor(pair.price==0 ? .red : nil)
                            .sheet(isPresented: $isEditorMode) {
                                InputItemDetails(title: pair.isNewItem ? "New item" : "Modify item",
                                                 message: pair.isNewItem ? "Please enter the name and the price of the new item" : "You can change the name and the price of \"\(pair.name)\"",
                                                 placeholder1: "Name",
                                                 placeholder2: "Price",
                                                 initialText: pair.name,
                                                 initialDouble: pair.price,
                                                 action: {
                                                      let _ = $2
                                                      if $0 != nil && $1 != nil {
                                                          if $0! != "" {
                                                              let index = model.listOfProductsAndPrices.firstIndex(of: pair)!
                                                              let name = $0!
                                                              let price = $1!
                                                              withAnimation() {                                              model.listOfProductsAndPrices[index].name = name
                                                                  model.listOfProductsAndPrices[index].price = price
                                                                  return
                                                              }
                                                          }
                                                      }
                                                  })
                            }
                    }
                    
                    Spacer()
                    
                    VStack {
                        
                        Text("\(itemCounter+1)/\(model.listOfProductsAndPrices.count)")
                            .font(.caption)
                            .fontWeight(.bold)
                            .padding(.trailing, 5)
                            .padding(.bottom, 5)
                            .padding(.top, -20)
                            .foregroundColor(.secondary)
                                                
                        Button(action: {
                            showSafariView = true
                        }) {
                            Image(systemName: "magnifyingglass")
                                .resizable(resizingMode: .tile)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30.0, height: 25.0)
                        }
                        .padding(.trailing, 5)
                        
                    }
                }
                .fullScreenCover(isPresented: $showSafariView) {
                    let urlString = ("http://www.google.com/images?q="+pair.name).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                    SafariView(url: URL(string: urlString!)!).edgesIgnoringSafeArea(.all)}
                .padding(.top,5)
                
                Divider()
                
                SelectableItems(users: model.users, selections: $selections)
                    .padding(.top)
                    .padding(.bottom,25)
                
                Divider()
                
                HStack {
                    
                    Menu {
                        
                        Button {
                            isEditorMode = true
                        } label: {
                                Label("Edit this item", systemImage: "pencil")
                        }

                        if !pair.isNewItem {
                            Button {
                                withAnimation(.easeInOut(duration: 4)) {
                                    createsNewItemCall = true
                                }
                            } label: {
                                Label("Add a new item", systemImage: "plus")
                            }
                        }
                        
                        Button(role: .destructive){
                            withAnimation(.easeInOut(duration: 4)) {
                                deletesItemCall = true
                            }
                        } label: {
                            Label("Delete this item", systemImage: "trash")
                        }
                        
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .resizable(resizingMode: .tile)
                            .frame(width: 25.0, height: 25.0)
                            .padding(.top)
                            .padding(.trailing,5)
                    }
                
                    Spacer()
                    
                    Button {
                        let divider = selections.count
                        if divider==0 {
                            showAlert1 = true
                        } else {
                            let index = model.listOfProductsAndPrices.firstIndex(of: pair)!
                            model.listOfProductsAndPrices[index].chosenBy = selections
                            isValidated = true
                            //selections = []
                        }
                    } label: {
                        Image(systemName: "checkmark.circle.fill")
                            .resizable(resizingMode: .tile)
                            .frame(width: 40.0, height: 40.0)
                            .padding(.top,5)
                    }
                    .tint(.green)
                    .disabled(selections.isEmpty)
                    .onTapGesture {
                        if selections.isEmpty {
                            showAlert1 = true
                        }
                    }
                    
                }
                .ignoresSafeArea(.keyboard)
                .padding(.top, 2)
            }
            .padding(20)
        }
        .onAppear(perform: {
            if pair.isNewItem {
                let secondsToDelay = 0.5
                DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
                    isEditorMode = true
                }
            }
        })
        .background(Color(uiColor: UIColor.systemBackground).brightness(0.06))
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.2), radius: 15.0)
        
        .padding()
        .alert(isPresented: $showAlert1) {
            Alert(title: Text("Missing selection"), message: Text("Please select the users who participate in this expense"), dismissButton: .default(Text("OK")))
        }
        .offset(x: xOffset, y: yOffset)
        .opacity(opacity)
        .onChange(of: createsNewItemCall) { newValue in
            if newValue {
                withAnimation(.easeInOut(duration: 0.35)) {
                    xOffset = 300
                    opacity = 0.0
                }
                let secondsToDelay = 0.35
                DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
                    createsNewItemCall = false
                }

            } else {
                var newPair = PairProductPrice(id: UUID().uuidString, name: AttributionCard.textOfNewItem, price: 0.0)
                newPair.isNewItem = true
                model.listOfProductsAndPrices.insert(newPair, at: itemCounter)
            }
        }
        .onChange(of: deletesItemCall) { newValue in
            if newValue {
                withAnimation(.easeInOut(duration: 0.35)) {
                    yOffset = 300
                    opacity = 0.0
                }
                let secondsToDelay = 0.35
                DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
                    deletesItemCall = false
                }

            } else {
                if let index = model.listOfProductsAndPrices.firstIndex(where: {$0.id == pair.id}) {
                    model.listOfProductsAndPrices.remove(at: index)
                }
            }
        }
        .transition(
            pair.isNewItem ?
                .asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .leading)) :
                    .asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
    }
    
}

struct AttributionView_Previews: PreviewProvider {
    static let model = ModelData()

    static var previews: some View {
        AttributionCard(pair: .constant(PairProductPrice(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBB", name: "Potato Wedges 1kg", price: 4.99)), isValidated: .constant(false), itemCounter: 0, initialSelection: [])
            .environmentObject(model)
            .onAppear {
                model.users = [User(name: "Hugo"), User(name: "Lucas"), User(name: "Thomas")]
                model.listOfProductsAndPrices = [PairProductPrice(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBB", name: "Potato Wedges 1kg", price: 4.99), PairProductPrice(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBC", name: "Finger Fish", price: 1.27), PairProductPrice(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBD", name: "Ice Cream Strawberry", price: 3.20)]
            }
    }
}
