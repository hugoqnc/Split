//
//  StatView.swift
//  ReceiptSplitter
//
//  Created by Hugo Queinnec on 08/01/2022.
//

import SwiftUI

struct StatView: View {
    @EnvironmentObject var model: ModelData
    
    var body: some View {
        VStack {
            HStack{
                Text("Number of purchases")
                Spacer()
                Text(String(model.listOfProductsAndPrices.count))
                    .font(.title3)
                    .fontWeight(.semibold)
            }
            .padding(2)
            HStack{
                Text("Average price of an item")
                Spacer()
                Text(String(round((model.totalPrice/Double(model.listOfProductsAndPrices.count))*100) / 100.0)+model.currency.value)
                    .font(.title3)
                    .fontWeight(.semibold)
            }
            .padding(2)
            HStack{
                Text("Maximum price of an item")
                Spacer()
                Text(String(round((model.listOfProductsAndPrices.map({ pair in
                    pair.price
                }).max() ?? 0.0)*100) / 100.0)+model.currency.value)
                    .font(.title3)
                    .fontWeight(.semibold)
            }
            .padding(2)
            HStack{
                Text("Minimum price of an item")
                Spacer()
                Text(String(round((model.listOfProductsAndPrices.map({ pair in
                    pair.price
                }).min() ?? 0.0)*100) / 100.0)+model.currency.value)
                    .font(.title3)
                    .fontWeight(.semibold)
            }
            .padding(2)
        }
    }
}

struct StatView_Previews: PreviewProvider {
    static let model = ModelData()
    static var previews: some View {
        StatView()
            .environmentObject(model)
            .onAppear {
                model.users = [User(name: "Hugo", balance: 13.8), User(name: "Lucas", balance: 17.21), User(name: "Thomas", balance: 8.22)]
                model.listOfProductsAndPrices = [PairProductPrice(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBB", name: "Potato Wedges 1kg", price: 4.99), PairProductPrice(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBC", name: "Finger Fish", price: 1.27), PairProductPrice(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBD", name: "Ice Cream Strawberry", price: 3.20)]
            }
    }
}
