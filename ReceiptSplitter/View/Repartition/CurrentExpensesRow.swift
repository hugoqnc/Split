//
//  CurrentExpenses.swift
//  ReceiptSplitter
//
//  Created by Hugo Queinnec on 05/01/2022.
//

import SwiftUI

struct CurrentExpensesRow: View {
    @EnvironmentObject var model: ModelData
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            HStack{
                Text("Total".uppercased())
                Text(String(round(model.totalPrice * 100) / 100.0)+"€")
                    .font(.title2)
                    .fontWeight(.semibold)
            }
            .padding(.top,40)
            
            Divider()
            HStack {
                VStack{
                    Image(systemName: "person.3")
                        .resizable(resizingMode: .tile)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 45.0, height: 30.0)
                        .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                }
                .padding(.leading)
                .padding(.trailing, 8)
                
                Divider()
                
                ScrollView(.horizontal){
                    HStack {
                        ForEach(model.users) { user in
                            VStack{
                                Text(user.name.uppercased())
                                    .font(.caption)
                                Text(String(round(user.balance * 100) / 100.0)+"€")
                                    .font(.headline)
                            }
                            .padding(8)
                        }
                    }
                }
            }
        }
    }
}

struct CurrentExpensesRow_Previews: PreviewProvider {
    static let model = ModelData()
    static var previews: some View {
        CurrentExpensesRow()
            .environmentObject(model)
            .onAppear {
                model.users = [User(name: "Hugo"), User(name: "Lucas"), User(name: "Thomas")]
                model.listOfProductsAndPrices = [PairProductPrice(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBB", name: "Potato Wedges 1kg", price: 4.99), PairProductPrice(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBC", name: "Finger Fish", price: 1.27), PairProductPrice(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBD", name: "Ice Cream Strawberry", price: 3.20)]
            }
    }
}
