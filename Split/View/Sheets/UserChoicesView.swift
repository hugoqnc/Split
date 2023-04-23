//
//  UserChoicesDetailView.swift
//  Split
//
//  Created by Hugo Queinnec on 30/01/2022.
//

import SwiftUI

struct UserChoicesView: View {
    @EnvironmentObject var model: ModelData
    var user: User
    @Environment(\.dismiss) var dismiss
    @State private var editPair = PairProductPrice()
    @State private var showSafariView = false
    
    func textTipTax(short: Bool = false) -> String {
        var text = ""
        if short && (model.tipRate != nil || model.taxRate != nil) {
            text = "incl. \(model.tipRate != nil ? "tip" : "")\(model.tipRate != nil && model.taxRate != nil ? " and " : "")\(model.taxRate != nil ? "taxes" : "")"
        } else if !short && (model.tipRate != nil || model.taxRate != nil) {
            text = "Your total amount is composed of \(model.showPrice(price: model.balanceBeforeTaxTip(ofUser: user))) of items, to which is added \(model.tipRate != nil ? "a \(model.showPrice(price: model.tipAmount(ofUser: user))) tip (\(model.tipRate!)% shared \(model.tipEvenly! ? "evenly" : "proportionally"))" : "")\(model.tipRate != nil && model.taxRate != nil ? ", and " : "")\(model.taxRate != nil ? "\(model.showPrice(price: model.taxAmount(ofUser: user))) taxes (\(model.taxRate!)% shared \(model.taxEvenly! ? "evenly" : "proportionally"))" : "")."
        }
        return text
    }

    var body: some View {
        let chosenItems: [PairProductPrice] = model.chosenItems(ofUser: user)
        
        VStack {
            NavigationView {
                VStack{

                    List() {
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text("\(user.name),")
                                    .font(.title)
                                    .fontWeight(.semibold)
                                Text("Here are the details of your purchases")
                                    .font(.title)
                                    .fontWeight(.regular)
                                Text("\(editPair.name)") //due to https://developer.apple.com/forums/thread/652080
                                    .hidden()
                                    .frame(height:0)
                                if textTipTax() != ""{
                                    Text(textTipTax())
                                        .font(.subheadline)
                                        .fontWeight(.regular)
                                }
                            }
                            Spacer()
                        }
                        //.padding(.bottom, -20)
                        .listRowBackground(Color.clear)
                        
                        Section(header: Text("\(chosenItems.count) items — \(model.showPrice(price: model.balance(ofUser: user))) \(textTipTax(short: true))"), footer: Label("Items sorted by decreasing price contribution", systemImage: "arrow.up.arrow.down")){
                        //Section {
                            ForEach(chosenItems.sorted(by: {$0.price/Double($0.chosenBy.count)>$1.price/Double($1.chosenBy.count)})) { item in
                                VStack {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(item.name)
                                                //.padding(.vertical, 3)
                                            MiniRepartitionRow(userIDs: item.chosenBy)
                                                .padding(.horizontal, 4)
                                                //.padding(.bottom, 3)
                                        }
                                        .sheet(isPresented: $showSafariView, content: {
                                            RestrictedBrowserView(isShown: $showSafariView, imageName: editPair.name)
                                        })
                                        .contextMenu{
                                            Button{
                                                editPair = item
                                                showSafariView = true
                                            } label: {
                                                Label("Search for images", systemImage: "magnifyingglass")
                                            }
                                        }
                                        
                                        Spacer()
                                        

                                        VStack {
                                            HStack {
                                                Text(model.showPrice(price: item.price) + " ÷ "+String(item.chosenBy.count))
                                                    .font(.subheadline)
                                                    .fontWeight(.light)
                                            }
                                            Text(model.showPrice(price: item.price/Double(item.chosenBy.count)))
                                                .fontWeight(.semibold)
                                        }

                                    }
                                }
                                
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
        model.listOfProductsAndPrices = [PairProductPrice(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBB", name: "Potato Wedges 1kg", price: 1.99), PairProductPrice(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBC", name: "Finger Fish", price: 1.27), PairProductPrice(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBD", name: "Ice Cream Strawberry", price: 3.20)]
        model.listOfProductsAndPrices[0].chosenBy = [model.users[0].id]
        model.listOfProductsAndPrices[1].chosenBy = [model.users[0].id, model.users[1].id]
        model.listOfProductsAndPrices[2].chosenBy = [model.users[0].id, model.users[1].id, model.users[2].id]
        model.tipRate = 10.0
        model.tipEvenly = true
        model.taxRate = 18.3
        model.taxEvenly = false
        return model
    }()
    
    static var previews: some View {
        Text("Test")
            .sheet(isPresented: .constant(true)) {
                UserChoicesView(user: model.users.first ?? User())
                    .environmentObject(model)
            }

    }
}
