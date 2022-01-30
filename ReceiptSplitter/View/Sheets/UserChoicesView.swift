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
        VStack {
            NavigationView {
                VStack{

                    List() {
                        //Section(header: Text("\(user.chosenItems.count) items — \(model.showPrice(price: user.balance))")){
                        Section {
                            ForEach(user.chosenItems) { item in
                                    HStack {
                                        Text(item.name)
                                        Spacer()
                                        Text(model.showPrice(price: item.price))
                                        Spacer()
                                        Text("1/"+String(item.dividedBy))
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

//    static var user: User {
//        get {
//            var user = User(name: "Hugo")
//            user.chosenItems = [ChosenItem(name: "Potato Wedges", price: 3.76, dividedBy: 3),
//                         ChosenItem(name: "Spinat", price: 1.78, dividedBy: 2),
//                         ChosenItem(name: "Beef 250g", price: 5.10, dividedBy: 1),
//                         ChosenItem(name: "Ricola Sweets", price: 2.89, dividedBy: 2)]
//            return user
//        }
//    }
    
    static var previews: some View {
        UserChoicesDetailView(user: User(name: "Hugo"))
    }
}
