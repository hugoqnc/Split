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
    @State private var showCurrentItem = false

    var body: some View {
        VStack {
            NavigationView {
                VStack{

                    List() {
                        Section(header: Text("\(model.listOfProductsAndPrices.count) transactions — \(model.showPrice(price: model.totalPrice))")){
                            ForEach(model.listOfProductsAndPrices) { pair in
                                if showCurrentItem {
                                    HStack {
                                        if  pair.id==model.listOfProductsAndPrices[itemCounter].id {
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
                                        Text(String(pair.price)+model.currency.value)
                                    }
                                    .foregroundColor(pair.id==model.listOfProductsAndPrices[itemCounter].id ? .blue : nil)
                                } else {
                                    HStack {
                                        Text(pair.name)
                                        Spacer()
                                        Text(String(pair.price)+model.currency.value)
                                    }
                                }
                            }
                            .onAppear {
                                if itemCounter>=0 {
                                    showCurrentItem = true
                                }
                            }
                        }
                    }
                }
//                .toolbar {
//                    ToolbarItem(placement: .bottomBar) {
//                        Button {
//                            dismiss()
//                        } label: {
//                            Text("Close")
//                        }
//                        .padding()
//                    }
//                }
                .navigationBarTitle("")
                .navigationBarHidden(true)
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}


struct ListSheetView_Previews: PreviewProvider {
    static let model = ModelData()
    static var previews: some View {
        Text("Test")
            .sheet(isPresented: .constant(true)) {
                ListSheetView(itemCounter: 1)
                    .environmentObject(model)
                    .onAppear {
                        model.users = [User(name: "Hugo"), User(name: "Lucas"), User(name: "Thomas")]
                        model.listOfProductsAndPrices = [PairProductPrice(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBB", name: "Potato Wedges 1kg", price: 4.99), PairProductPrice(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBC", name: "Finger Fish", price: 1.27), PairProductPrice(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBD", name: "Ice Cream Strawberry", price: 3.20)]
                    }
            }

    }
}
