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
    @Binding var isFirstTimeShowingList: Bool
    @Environment(\.dismiss) var dismiss
    @State private var showCurrentItem = false

    var body: some View {
        VStack {
            if isFirstTimeShowingList {
                VStack {
                    Image(systemName: "exclamationmark.triangle")
                        .resizable(resizingMode: .tile)
                        .frame(width: 30.0, height: 30.0)
                        .foregroundColor(.orange)
                        .padding(.top)
                    Text("Please check that most of the transactions are correct, meaning that most names are associated with the right prices. If it is not the case, please cancel and start again.")
                        .padding(.top,3)
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
                                if itemCounter>=0 && !isFirstTimeShowingList{
                                    showCurrentItem = true
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
                            
                            dismiss()
                        } label: {
                            if isFirstTimeShowingList{
                                Text("Cancel")
                            }
                        }
                        .padding()
                        .foregroundColor(.red)
                    }
                    ToolbarItem(placement: .bottomBar) {
                        Button {
                            dismiss()
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
        .interactiveDismissDisabled(isFirstTimeShowingList)
    }
}


struct ListSheetView_Previews: PreviewProvider {
    static let model = ModelData()
    static var previews: some View {
        Text("Test")
            .sheet(isPresented: .constant(true)) {
                ListSheetView(itemCounter: 1, isFirstTimeShowingList: .constant(true))
                    .environmentObject(model)
                    .onAppear {
                        model.users = [User(name: "Hugo"), User(name: "Lucas"), User(name: "Thomas")]
                        model.listOfProductsAndPrices = [PairProductPrice(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBB", name: "Potato Wedges 1kg", price: 4.99), PairProductPrice(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBC", name: "Finger Fish", price: 1.27), PairProductPrice(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBD", name: "Ice Cream Strawberry", price: 3.20)]
                    }
            }

    }
}
