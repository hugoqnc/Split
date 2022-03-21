//
//  ListItem.swift
//  Split
//
//  Created by Hugo Queinnec on 08/02/2022.
//

import SwiftUI

struct ListItem: View {
    @EnvironmentObject var model: ModelData
    @Binding var pair: PairProductPrice
    @State var isCurrentItem: Bool
    @State var editSelection = false
    @State var chosenByTemp: [UUID] = []
    
    var body: some View {
        HStack {
            if isCurrentItem {
                VStack(alignment: .leading) {
                    Text("Current item".uppercased())
                        .font(.caption)
                        .padding(.top,3)
                    Text(pair.name)
                        .font(.headline)
                }
            } else {
                if !pair.chosenBy.isEmpty {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(pair.name)
                            .padding(.vertical, 3)
                        Group {
                            if editSelection {
                                SelectableItems(users: model.users, selections: $chosenByTemp, showSelectAllButton: false)
                            } else {
                                MiniRepartitionRow(userIDs: pair.chosenBy)
                            }
                        }
                        .padding(.horizontal, 4)
                        .padding(.bottom, 3)
                        .animation(.easeInOut, value: editSelection)
                    }
                    .contextMenu{
                        Button{
                            withAnimation() {
                                editSelection = true //make appear toggles below for multi selection + close button
                            }
                        } label: {
                            Label("Edit repartition", systemImage: "checkmark.circle")
                        }
                        Button{
                            print("A") //TODO: edit
                        } label: {
                            Label("Edit name and price", systemImage: "pencil")
                        }
                        Button(role: .destructive){
                            print("A") //TODO: delete
                        } label: {
                            Label("Delete item", systemImage: "trash")
                        }
                    }
                } else {
                    Text(pair.name)
                }
            }

            Spacer()
            
            VStack {
                Text(model.showPrice(price: pair.price))
                    .fontWeight(.semibold)
                if editSelection {
                    Button {
                        withAnimation() {
                            editSelection = false
                        }
                        if !chosenByTemp.isEmpty {
                            pair.chosenBy = chosenByTemp
                        }
                    } label: {
                        Text("OK")
                    }
                    .padding(.top,7)
                    .disabled(chosenByTemp.isEmpty)
                }
            }
        }
        .listRowBackground(Color.secondary.opacity(0.1))
        .foregroundColor(isCurrentItem ? .blue : nil)
        .onAppear {
            chosenByTemp = pair.chosenBy
        }
    }
}

struct ListItem_Previews: PreviewProvider {
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
        List {
            ListItem(pair: .constant(model.listOfProductsAndPrices[0]), isCurrentItem: false)
            ListItem(pair: .constant(model.listOfProductsAndPrices[1]), isCurrentItem: false)
        }
        .environmentObject(model)
    }
}
