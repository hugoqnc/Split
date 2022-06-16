//
//  StatView.swift
//  Split
//
//  Created by Hugo Queinnec on 02/02/2022.
//

import SwiftUI

struct StatView: View {
    @EnvironmentObject var model: ModelData
    @Environment(\.horizontalSizeClass) var horizontalSizeClass //for iPad specificity

    
    var averageItemPrice: Double {
        get {
            return model.totalPrice / Double(model.listOfProductsAndPrices.count)
        }
    }
    
    var maximumItemPrice: Double {
        get {
            return (model.listOfProductsAndPrices.map({ pair in
                pair.price
            }).max() ?? 0.0)
        }
    }
    
    var maximumItemName: String {
        get {
           return (model.listOfProductsAndPrices.sorted(by: {$0.price>$1.price}).first?.name ?? "none")
        }
    }
    
    var minimumItemName: String {
        get {
            return (model.listOfProductsAndPrices.sorted(by: {$0.price<$1.price}).filter{$0.price>0}.first?.name ?? "none")
        }
    }
    
    var minimumItemPrice: Double {
        get {
            return (model.listOfProductsAndPrices.map({ pair in
                pair.price
            }).filter{$0>0}.min() ?? 0.0)
        }
    }
    
    var body: some View {
        
        if horizontalSizeClass == .compact {
        VStack {
            HStack {
                Spacer()
                
                StatisticRectangle(iconString: "number", description: "Number of\npurchases", value: String(model.listOfProductsAndPrices.count), color: Color.blue)
                
                StatisticRectangle(iconString: "cart", description: "Average price\nof an item", value: model.showPrice(price: averageItemPrice), color: Color.orange)
                
                Spacer()
            }
            HStack {
                Spacer()
                
                StatisticRectangle(iconString: "arrow.up.right.circle", description: "Maximum price\n(\(maximumItemName))", value: model.showPrice(price: maximumItemPrice), color: Color.green)
                
                StatisticRectangle(iconString: "arrow.down.right.circle", description: "Minimum price\n(\(minimumItemName))", value: model.showPrice(price: minimumItemPrice), color: Color.red)
                
                Spacer()
            }
        }
            
        } else {
            
            HStack {
                Spacer()
                
                StatisticRectangle(iconString: "number", description: "Number of\npurchases", value: String(model.listOfProductsAndPrices.count), color: Color.blue)
                
                StatisticRectangle(iconString: "cart", description: "Average price\nof an item", value: model.showPrice(price: averageItemPrice), color: Color.orange)
                
                StatisticRectangle(iconString: "arrow.up.right.circle", description: "Maximum price\n(\(maximumItemName))", value: model.showPrice(price: maximumItemPrice), color: Color.green)
                
                StatisticRectangle(iconString: "arrow.down.right.circle", description: "Minimum price\n(\(minimumItemName))", value: model.showPrice(price: minimumItemPrice), color: Color.red)
                
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
