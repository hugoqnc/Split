//
//  ResultViewHistoryWrapper.swift
//  ReceiptSplitter
//
//  Created by Hugo Queinnec on 26/02/2022.
//

import SwiftUI

struct ResultViewHistoryWrapper: View {
    internal init(users: [User], listOfProductsAndPricesCodable: [PairProductPriceCodable], currency: Currency) {
        model = ModelData()
        model.users = users
        model.currency = currency
        
        var listOfProductsAndPrices: [PairProductPrice] = []
        for pairCod in listOfProductsAndPricesCodable {
            var pair = PairProductPrice()
            pair.id = pairCod.id
            pair.name = pairCod.name
            pair.price = pairCod.price
            pair.chosenBy = pairCod.chosenBy
            listOfProductsAndPrices.append(pair)
        }
        model.listOfProductsAndPrices = listOfProductsAndPrices
    }
    
    var model: ModelData
    
    var body: some View {
        ResultView()
            .environmentObject(model)
    }
}

struct ResultViewHistoryWrapper_Previews: PreviewProvider {
    static var previews: some View {
        ResultViewHistoryWrapper(users: [User(name: "Hugo"), User(name: "Lucas"), User(name: "Thomas")], listOfProductsAndPricesCodable: [PairProductPriceCodable(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBB", name: "Potato Wedges 1kg", price: 4.99), PairProductPriceCodable(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBC", name: "Finger Fish", price: 1.27), PairProductPriceCodable(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBD", name: "Ice Cream Strawberry", price: 3.20)], currency: Currency.default)
        
    }
}
