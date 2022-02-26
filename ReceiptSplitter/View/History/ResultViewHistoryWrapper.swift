//
//  ResultViewHistoryWrapper.swift
//  ReceiptSplitter
//
//  Created by Hugo Queinnec on 26/02/2022.
//

import SwiftUI

struct ResultViewHistoryWrapper: View {
    internal init(resultUnit: ResultUnit) {
        model = ModelData()
        model.users = resultUnit.users
        model.currency = resultUnit.currency
        model.date = resultUnit.date
        
        var listOfProductsAndPrices: [PairProductPrice] = []
        for pairCod in resultUnit.listOfProductsAndPrices {
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
        ResultView(isShownInHistory: true)
            .environmentObject(model)
    }
}

//struct ResultViewHistoryWrapper_Previews: PreviewProvider {
//    static var previews: some View {
//        ResultViewHistoryWrapper()
//    }
//}
