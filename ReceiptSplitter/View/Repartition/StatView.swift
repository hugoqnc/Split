//
//  StatView.swift
//  ReceiptSplitter
//
//  Created by Hugo Queinnec on 02/02/2022.
//

import SwiftUI

struct StatView: View {
    @EnvironmentObject var model: ModelData
    @Environment(\.horizontalSizeClass) var horizontalSizeClass //for iPad specificity
    
    var body: some View {
        
        if horizontalSizeClass == .compact {
        VStack {
            HStack {
                Spacer()
                
                StatisticRectangle(iconString: "number", description: "Number of\npurchases", value: String(model.listOfProductsAndPrices.count), color: Color.blue)
                
                StatisticRectangle(iconString: "cart", description: "Average price\nof an item", value: String(round((model.totalPrice/Double(model.listOfProductsAndPrices.count))*100) / 100.0)+model.currency.value, color: Color.orange)
                
                Spacer()
            }
            HStack {
                Spacer()
                
                StatisticRectangle(iconString: "arrow.up.right.circle", description: "Maximum price\n(\(model.listOfProductsAndPrices.sorted(by: {$0.price>$1.price}).first?.name ?? "none"))", value: String(round((model.listOfProductsAndPrices.map({ pair in
                    pair.price
                }).max() ?? 0.0)*100) / 100.0)+model.currency.value, color: Color.green)
                
                StatisticRectangle(iconString: "arrow.down.right.circle", description: "Minimum price\n(\(model.listOfProductsAndPrices.sorted(by: {$0.price<$1.price}).first?.name ?? "none"))", value: String(round((model.listOfProductsAndPrices.map({ pair in
                    pair.price
                }).min() ?? 0.0)*100) / 100.0)+model.currency.value, color: Color.red)
                
                Spacer()
            }
        }
            
        } else {
            
            HStack {
                Spacer()
                
                StatisticRectangle(iconString: "number", description: "Number of\npurchases", value: String(model.listOfProductsAndPrices.count), color: Color.blue)
                
                StatisticRectangle(iconString: "cart", description: "Average price\nof an item", value: String(round((model.totalPrice/Double(model.listOfProductsAndPrices.count))*100) / 100.0)+model.currency.value, color: Color.orange)
                
                StatisticRectangle(iconString: "arrow.up.right.circle", description: "Maximum price\n(\(model.listOfProductsAndPrices.sorted(by: {$0.price>$1.price}).first?.name ?? "none"))", value: String(round((model.listOfProductsAndPrices.map({ pair in
                    pair.price
                }).max() ?? 0.0)*100) / 100.0)+model.currency.value, color: Color.green)
                
                StatisticRectangle(iconString: "arrow.down.right.circle", description: "Minimum price\n(\(model.listOfProductsAndPrices.sorted(by: {$0.price<$1.price}).first?.name ?? "none"))", value: String(round((model.listOfProductsAndPrices.map({ pair in
                    pair.price
                }).min() ?? 0.0)*100) / 100.0)+model.currency.value, color: Color.red)
                
                Spacer()
            }
        }
        
    }
}

struct StatView_Previews: PreviewProvider {
    static var previews: some View {
        StatView()
            .environmentObject(ModelData())
            //.previewDevice(PreviewDevice(rawValue:"iPhone 13 Pro"))
    }
}

//struct StatView_Previews1: PreviewProvider {
//    static var previews: some View {
//        StatView()
//            .environmentObject(ModelData())
//            .previewDevice(PreviewDevice(rawValue:"iPad Air (4th generation)"))
//    }
//}
