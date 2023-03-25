//
//  ListSheetView.swift
//  Split
//
//  Created by Hugo Queinnec on 07/01/2022.
//

import SwiftUI

struct ListSheetView: View {
    @EnvironmentObject var model: ModelData
    @Binding var itemCounter: Int
    var isShownInHistory = false
    @Environment(\.dismiss) var dismiss
    @State private var editItemAlert = false
    @State private var editPair = PairProductPrice()
    @State private var showSafariView = false
    
    var textTipTax: String {
        get {
            var text = ""
            if (model.tipRate != nil || model.taxRate != nil) {
                text = "incl. \(model.tipRate != nil ? "tip" : "")\(model.tipRate != nil && model.taxRate != nil ? " and " : "")\(model.taxRate != nil ? "taxes" : "")"
            }
            return text
        }
    }

    var body: some View {
        NavigationView {
            VStack{
            
                List() {
                    if !isShownInHistory {
                        Section(header:
                            HStack{
                                Text("Receipt Name")
                            }
                        ){
                            VStack {
                                TextField("Receipt Name", text: $model.receiptName.animation())
                            }
                        }
                    }
                    
                    Section(header: Text("\(model.listOfProductsAndPrices.count) items — \(model.showPrice(price: model.totalPrice)) \(textTipTax)"), footer: isShownInHistory ? Label("Items ordered as they were on the receipt", systemImage: "arrow.up.arrow.down") : Label("Long press on an assigned item to modify it", systemImage: "lightbulb")){
                        ForEach($model.listOfProductsAndPrices) { $pair in
                            HStack {
                                if itemCounter>=0 ? pair.id==model.listOfProductsAndPrices[itemCounter].id : false {
                                    VStack(alignment: .leading) {
                                        Text("Current item".uppercased())
                                            .font(.caption)
                                            //.padding(.top,3)
                                        Text(pair.name)
                                            .font(.headline)
                                    }
                                    .padding(.vertical,1)
                                } else {
                                    if !pair.chosenBy.isEmpty {
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(pair.name)
                                                //.padding(.bottom, 3)
                                            MiniRepartitionRow(userIDs: pair.chosenBy)
                                                .padding(.horizontal, 4)
                                                //.padding(.bottom, 3)
                                        }
//                                        .fullScreenCover(isPresented: $showSafariView) {
//                                            let urlString = ("http://www.google.com/images?q="+editPair.name).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
//                                            SafariView(url: URL(string: urlString!)!).edgesIgnoringSafeArea(.all)
//                                        }
                                        .sheet(isPresented: $showSafariView, content: {
                                            RestrictedBrowserView(isShown: $showSafariView, imageName: editPair.name)
                                        })
                                        .contextMenu{
                                            Button{
                                                editPair = pair
                                                showSafariView = true
                                            } label: {
                                                Label("Search for images", systemImage: "magnifyingglass")
                                            }

                                            if !isShownInHistory {
                                                Button{
                                                    editItemAlert = true
                                                    editPair = pair
                                                } label: {
                                                    Label("Edit this item", systemImage: "pencil")
                                                }
                                                Button(role: .destructive){
                                                    withAnimation() {
                                                        itemCounter -= 1
                                                        if let index = model.listOfProductsAndPrices.firstIndex(where: {$0.id == pair.id}) {
                                                            model.listOfProductsAndPrices.remove(at: index)
                                                        }
                                                    }
                                                } label: {
                                                    Label("Delete this item", systemImage: "trash")
                                                }
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
                    
                    Text("\(editPair.name)") //due to https://developer.apple.com/forums/thread/652080
                        .hidden()
                        .frame(height:0)
                        .listRowBackground(Color.clear)
                }
            }
            .navigationBarTitle(Text(""), displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Done")
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}


struct ListSheetView_Previews: PreviewProvider {
    static let model: ModelData = {
        var model = ModelData()
        model.users = [User(name: "Hugo"), User(name: "Lucas"), User(name: "Thomas")]
        model.listOfProductsAndPrices = [PairProductPrice(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBB", name: "Potato Wedges 1kg", price: 4.99), PairProductPrice(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBC", name: "Finger Fish", price: 1.27), PairProductPrice(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBD", name: "Ice Cream Strawberry", price: 3.20)]
        model.listOfProductsAndPrices[0].chosenBy = [model.users[0].id]
        model.listOfProductsAndPrices[1].chosenBy = [model.users[0].id, model.users[1].id]
        //model.listOfProductsAndPrices[2].chosenBy = [model.users[0].id, model.users[1].id, model.users[2].id]
        return model
    }()
    
    static var previews: some View {
        Text("Test")
            .sheet(isPresented: .constant(true)) {
                ListSheetView(itemCounter: .constant(2))
                    .environmentObject(model)
            }

    }
}
