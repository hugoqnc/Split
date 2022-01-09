//
//  ResultView.swift
//  ReceiptSplitter
//
//  Created by Hugo Queinnec on 08/01/2022.
//

import SwiftUI

struct ResultView: View {
    @EnvironmentObject var model: ModelData
    @State private var showAllList = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
            VStack {
                VStack{
                    Text("Total".uppercased())
                        .font(.title2)
                    Text(String(round(model.totalPrice * 100) / 100.0)+"€")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                }
                .padding(.top,60)
                
                Divider()
                    .padding(.leading)
                    .padding(.trailing)
                
                HStack {
                    VStack{
                        Image(systemName: "person.2")
                            .resizable(resizingMode: .tile)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 45.0, height: 30.0)
                            .foregroundColor(.blue)
                    }
                    .padding(.leading)
                    .padding(.trailing, 8)
                    
                    Divider()
                    
                    ScrollView(.vertical){
                        VStack {
                            ForEach(model.users.sorted(by: {$0.balance>$1.balance})) { user in
                                HStack{
                                    Text(user.name)
                                        .font(.title3)
                                    Spacer()
                                    Text(String(round(user.balance * 100) / 100.0)+"€")
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                }
                                .padding(8)
                            }
                        }
                    }
                    .padding(6)
                }
                .padding(.leading)
                .padding(.trailing)
                //.frame(height: 195)
                
                Divider()
                    .padding(.leading)
                    .padding(.trailing)
                
                HStack {
                    VStack{
                        Image(systemName: "cart")
                            .resizable(resizingMode: .tile)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 45.0, height: 35.0)
                            .foregroundColor(.orange)
                        Button {
                            showAllList = true
                        } label: {
                            Label("See all", systemImage: "list.bullet")
                                .labelStyle(.iconOnly)
                        }
                        .buttonStyle(.bordered)
                        .foregroundColor(.orange)
                        .padding(.top)
                        
                    }
                    .padding(.leading)
                    .padding(.trailing, 8)
                    
                    Divider()
                    
                    ScrollView(.vertical){
                        StatView()
                    }
                    .padding(10)
                }
                .padding(.leading)
                .padding(.trailing)
                
                Button {
                    dismiss()
                    
                    model.startTheProcess = false
                    model.users = UsersModel().users
                    model.listOfProductsAndPrices = []
                } label: {
                    Label("Done", systemImage: "checkmark")
                }
                .buttonStyle(.borderedProminent)
                .padding(7)
            }
        
        .sheet(isPresented: $showAllList, content: {
            ListSheetView(itemCounter: -1, isFirstTimeShowingList: .constant(false))
        })
        
    }
}

struct ResultView_Previews: PreviewProvider {
    static let model = ModelData()
    static var previews: some View {
        Text("Test")
            .sheet(isPresented: .constant(true)) {
                ResultView()
                    .environmentObject(model)
                    .onAppear {
                        model.users = [User(name: "Hugo"), User(name: "Lucas"), User(name: "Thomas")]
                        model.listOfProductsAndPrices = [PairProductPrice(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBB", name: "Potato Wedges 1kg", price: 4.99), PairProductPrice(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBC", name: "Finger Fish", price: 1.27), PairProductPrice(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBD", name: "Ice Cream Strawberry", price: 3.20)]
                    }
            }
    }
}
