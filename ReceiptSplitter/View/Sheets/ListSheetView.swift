//
//  ListSheetView.swift
//  ReceiptSplitter
//
//  Created by Hugo Queinnec on 07/01/2022.
//

import SwiftUI

struct ListSheetView: View {
    @EnvironmentObject var model: ModelData
    var itemCounter: Int
    @Environment(\.dismiss) var dismiss
    @State private var editItemAlert = false
    @State private var editPair = PairProductPrice()

    var body: some View {
        VStack {
            NavigationView {
                VStack{
                    
                    Text("\(editPair.name)") //due to https://developer.apple.com/forums/thread/652080
                        .hidden()
                        .frame(height:0)

                    List() {
                        Section(header: Text("\(model.listOfProductsAndPrices.count) items — \(model.showPrice(price: model.totalPrice))")){
                            ForEach($model.listOfProductsAndPrices) { $pair in
                                HStack {
                                    if itemCounter>=0 ? pair.id==model.listOfProductsAndPrices[itemCounter].id : false {
                                        VStack(alignment: .leading) {
                                            Text("Current item".uppercased())
                                                .font(.caption)
                                                .padding(.top,3)
                                            Text(pair.name)
                                                .font(.headline)
                                        }
                                    } else {
                                        if !pair.chosenBy.isEmpty {
                                            VStack(alignment: .leading, spacing: 2) {
                                                Text(pair.name)
                                                    .padding(.vertical, 3)
                                                MiniRepartitionRow(userIDs: pair.chosenBy)
                                                    .padding(.horizontal, 4)
                                                    .padding(.bottom, 3)
                                            }
                                            .contextMenu{
                                                Button{
                                                    editItemAlert = true
                                                    editPair = pair
                                                } label: {
                                                    Label("Edit item", systemImage: "pencil")
                                                }
                                                Button(role: .destructive){
                                                    if let index = model.listOfProductsAndPrices.firstIndex(where: {$0.id == pair.id}) {
                                                        model.listOfProductsAndPrices.remove(at: index)
                                                    }
                                                } label: {
                                                    Label("Delete item", systemImage: "trash")
                                                }
                                            }
                                        } else {
                                            Text(pair.name)
                                        }
                                    }

                                    Spacer()
                                    
                                    Text(model.showPrice(price: pair.price))
                                        .fontWeight(.semibold)
                                }
                                .listRowBackground(Color.secondary.opacity(0.1))
                                .foregroundColor(itemCounter>=0 ? pair.id==model.listOfProductsAndPrices[itemCounter].id ? .blue : nil : nil)
                            }
                            .sheet(isPresented: $editItemAlert) {
                                let name = editPair.name
                                let price = editPair.price
                                
                                InputItemDetails(title: "Modify item",
                                                 message:"You can change the name, price and repartition of \"\(name)\" between users",
                                                 placeholder1: "Name",
                                                 placeholder2: "Price",
                                                 initialText: name,
                                                 initialDouble: price,
                                                 initialSelections: editPair.chosenBy,
                                                 action: {
                                                      if $0 != nil && $1 != nil {
                                                          if $0! != "" {
                                                              let index = model.listOfProductsAndPrices.firstIndex(of: editPair)!
                                                              let name = $0!
                                                              let price = $1!
                                                              let chosenBy = $2!
                                                              withAnimation() {
                                                                  model.listOfProductsAndPrices[index].name = name
                                                                  model.listOfProductsAndPrices[index].price = price
                                                                  model.listOfProductsAndPrices[index].chosenBy = chosenBy
                                                                  return
                                                              }
                                                          }
                                                      }
                                                  })
                            }
                        }
                    }
                }
                .navigationBarTitle("")
                .navigationBarHidden(true)
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}


struct ListSheetView_Previews: PreviewProvider {
    static let model: ModelData = {
        var model = ModelData()
        model.users = [User(name: "Hugo"), User(name: "Lucas"), User(name: "Thomas")]
        model.listOfProductsAndPrices = [PairProductPrice(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBB", name: "Potato Wedges 1kg", price: 4.99), PairProductPrice(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBC", name: "Finger Fish", price: 1.27), PairProductPrice(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBD", name: "Ice Cream Strawberry", price: 3.20)]
        model.listOfProductsAndPrices[0].chosenBy = [model.users[0].id]
        //model.listOfProductsAndPrices[1].chosenBy = [model.users[0].id, model.users[1].id]
        //model.listOfProductsAndPrices[2].chosenBy = [model.users[0].id, model.users[1].id, model.users[2].id]
        return model
    }()
    
    static var previews: some View {
        Text("Test")
            .sheet(isPresented: .constant(true)) {
                ListSheetView(itemCounter: 1)
                    .environmentObject(model)
            }

    }
}
