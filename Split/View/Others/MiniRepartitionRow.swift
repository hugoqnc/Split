//
//  MiniRepartitionRow.swift
//  Split
//
//  Created by Hugo Queinnec on 30/01/2022.
//

import SwiftUI

struct MiniRepartitionRow: View {
    @EnvironmentObject var model: ModelData
    let userIDs: [UUID]
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(model.users) { user in
                    let prefix: String = String(user.name.prefix(2))
                    
                    if userIDs.contains(user.id) {
                        Group {
                            Text(prefix)
                                .font(.caption2)
                                .foregroundColor(.white)
                                .padding(2)
                        }
                        .background(Color.accentColor)
                        .cornerRadius(5)
                    } else {
                        Group {
                            Text(prefix)
                                .font(.caption2)
                                .foregroundColor(.gray)
                                .padding(2)
                        }
                        .background(Color.gray.opacity(0.3))
                        .cornerRadius(5)
                    }
                }
            }
        }
    }
}

struct MiniRepartitionRow_Previews: PreviewProvider {
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
        MiniRepartitionRow(userIDs: model.listOfProductsAndPrices[1].chosenBy)
            .environmentObject(model)
    }
}
