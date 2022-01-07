//
//  ListSheetView.swift
//  ReceiptSplitter
//
//  Created by Hugo Queinnec on 07/01/2022.
//

import SwiftUI

struct ListSheetView: View {
    var listOfProductsAndPrices: [PairProductPrice]
    var itemCounter: Int
    @Binding var isFirstTimeShowingList: Bool
    @Environment(\.dismiss) var dismiss

    var body: some View {
        if isFirstTimeShowingList {
            VStack {
                Image(systemName: "exclamationmark.triangle")
                    .resizable(resizingMode: .tile)
                    .frame(width: 30.0, height: 30.0)
                    .foregroundColor(.orange)
                    .padding(.top)
                Text("Please check that most of the transactions are correct, meaning that most names are associated with the right prices. If it is not the case, please start again.")
                    .padding(.bottom)
                    .padding(.leading)
                    .padding(.trailing)
                    .onDisappear(){
                        isFirstTimeShowingList = false
                }
            }
        }
        
        NavigationView {
            VStack{

                List() {
                    Section(header: Text("All transactions")){
                    ForEach(listOfProductsAndPrices) { pair in
                        HStack {
                            if pair.id == listOfProductsAndPrices[itemCounter].id {
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
                        .foregroundColor(pair.id == listOfProductsAndPrices[itemCounter].id ? .blue : nil)
                    }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Done")
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(15)
                    .padding(.bottom, 10)
                }
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }
    }
}


struct ListSheetView_Previews: PreviewProvider {
    static var previews: some View {
        Text("Test")
            .sheet(isPresented: .constant(true)) {
                ListSheetView(listOfProductsAndPrices: [PairProductPrice(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBB", name: "Potato Wedges 1kg", price: 4.99), PairProductPrice(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBC", name: "Finger Fish", price: 1.27), PairProductPrice(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBD", name: "Ice Cream Strawberry", price: 3.20)], itemCounter: 1, isFirstTimeShowingList: .constant(true))
            }

    }
}
