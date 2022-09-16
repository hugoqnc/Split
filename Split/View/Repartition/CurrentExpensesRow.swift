//
//  CurrentExpenses.swift
//  Split
//
//  Created by Hugo Queinnec on 05/01/2022.
//

import SwiftUI

struct CurrentExpensesRow: View {
    @EnvironmentObject var model: ModelData    
    @Binding var isValidated: Bool
    
    var body: some View {
        VStack {
            HStack{
                Text("Total:")
                    .font(.system(size: 26))
                Text(model.showPrice(price: model.totalBalance))
                    //.font(.title2)
                    .fontWeight(.semibold)
                    .font(.system(size: 38))
            }
            .padding(.top,40)
            .padding(.bottom,5)
            
            Divider()
            
            HStack {
                VStack{
                    Image(systemName: "person.2")
                        .resizable(resizingMode: .stretch)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 35.0, height: 30.0)
                        .foregroundColor(.primary)
                }
                .padding(.leading)
                .padding(.trailing, 8)
                
                Divider()
                
                ScrollView(.horizontal){
                    HStack {
                        ForEach(model.users) { user in
                            VStack{
                                Text(user.name)
                                    .font(.subheadline)
                                Text(model.showPrice(price: model.balance(ofUser: user)))
                                    .font(.title3)
                            }
                            .padding(8)
                        }
                    }
                }
            }
        }
        .onChange(of: isValidated) { newValue in
            //print("changed")
            //allows to force refresh show prices at each new validated item (weirdly, sometimes, the view would not refresh despite the model being updated)
        }
    }
}

struct CurrentExpensesRow_Previews: PreviewProvider {
    static let model = ModelData()
    static var previews: some View {
        CurrentExpensesRow(isValidated: .constant(true))
            .environmentObject(model)
            .onAppear {
                model.users = [User(name: "Hugo"), User(name: "Lucas"), User(name: "Thomas")]
                model.listOfProductsAndPrices = [PairProductPrice(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBB", name: "Potato Wedges 1kg", price: 4.99), PairProductPrice(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBC", name: "Finger Fish", price: 1.27), PairProductPrice(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBD", name: "Ice Cream Strawberry", price: 3.20)]
            }
    }
}
