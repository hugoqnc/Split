//
//  FirstListView.swift
//  ReceiptSplitter
//
//  Created by Hugo Queinnec on 20/01/2022.
//

import SwiftUI

struct FirstListView: View {
    @EnvironmentObject var model: ModelData

    var body: some View {
        VStack {
//            VStack {
//                Image(systemName: "exclamationmark.triangle")
//                    .resizable(resizingMode: .tile)
//                    .frame(width: 30.0, height: 30.0)
//                    .foregroundColor(.orange)
//                    .padding(.top)
//                Text("Please check that most of the transactions are correct, meaning that most names are associated with the right prices. If it is not the case, please cancel and start again.")
//                    .padding(.top,3)
//                    .padding(.bottom)
//                    .padding(.leading)
//                    .padding(.trailing)
//            }
            
            
            NavigationView {
                VStack{

                    List() {
                        Section(header: Text("\(model.listOfProductsAndPrices.count) transactions — \(model.showPrice(price: model.totalPrice))")){
                            ForEach(model.listOfProductsAndPrices) { pair in
                                HStack {
                                    Text(pair.name)
                                    Spacer()
                                    Text(String(pair.price)+model.currency.value)
                                }
                            }
                        }
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .bottomBar) {
                        Button {
                            model.startTheProcess = false
                            model.users = UsersModel().users
                            model.listOfProductsAndPrices = []
                            
                        } label: {
                            Text("Cancel")
                        }
                        .padding()
                        .foregroundColor(.red)
                    }
                    ToolbarItem(placement: .bottomBar) {
                        Button {
                            
                        } label: {
                            Text("Done")
                        }
                        .padding()
                    }
                }
                .navigationBarTitle("")
                .navigationBarHidden(true)
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
        .background(Color(red: 255 / 255, green: 225 / 255, blue: 51 / 255).opacity(0.2).ignoresSafeArea(.all))
    }

}

struct FirstListView_Previews: PreviewProvider {
    static let model = ModelData()
    static var previews: some View {
        FirstListView()
            .environmentObject(model)
            .onAppear {
                model.users = [User(name: "Hugo"), User(name: "Lucas"), User(name: "Thomas")]
                model.listOfProductsAndPrices = [PairProductPrice(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBB", name: "Potato Wedges 1kg", price: 4.99), PairProductPrice(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBC", name: "Finger Fish", price: 1.27), PairProductPrice(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBD", name: "Ice Cream Strawberry", price: 3.20)]
            }
    }
}
