//
//  UserChoicesDetailView.swift
//  ReceiptSplitter
//
//  Created by Hugo Queinnec on 30/01/2022.
//

import SwiftUI

struct UserChoicesDetailView: View {
    @EnvironmentObject var model: ModelData
    var user: User
    @Environment(\.dismiss) var dismiss

    var body: some View {
        let chosenItems: [PairProductPrice] = model.chosenItems(ofUser: user)
        
        VStack {
            NavigationView {
                VStack{

                    List() {
                        Section(header: Text("\(chosenItems.count) items — \(model.showPrice(price: model.balance(ofUser: user)))")){
                        //Section {
                            ForEach(chosenItems) { item in
                                    HStack {
                                        Text(item.name)
                                        Spacer()

                                        VStack {
                                            HStack {
                                                Text(model.showPrice(price: item.price) + " × 1/"+String(item.chosenBy.count))
                                                    .font(.caption)
                                            }
                                            Text(model.showPrice(price: item.price/Double(item.chosenBy.count)))
                                        }

                                    }
                                    .listRowBackground(Color.secondary.opacity(0.1))
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

struct UserChoicesDetailView_Previews: PreviewProvider {
    static let model: ModelData = {
        var model = ModelData()
        model.users = [User(name: "Hugo"), User(name: "Lucas"), User(name: "Thomas")]
        model.listOfProductsAndPrices = [PairProductPrice(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBB", name: "Potato Wedges 1kg", price: 4.99), PairProductPrice(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBC", name: "Finger Fish", price: 1.27), PairProductPrice(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBD", name: "Ice Cream Strawberry", price: 3.20)]
        model.listOfProductsAndPrices[0].chosenBy = [model.users[0].id]
        model.listOfProductsAndPrices[1].chosenBy = [model.users[0].id, model.users[1].id]
        model.listOfProductsAndPrices[2].chosenBy = [model.users[0].id, model.users[1].id, model.users[2].id]
        return model
    }()
    
    static var previews: some View {
        Text("Test")
            .sheet(isPresented: .constant(true)) {
                UserChoicesDetailView(user: model.users.first ?? User())
                    .environmentObject(model)
            }

    }
}
