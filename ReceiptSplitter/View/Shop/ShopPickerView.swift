//
//  ShopListView.swift
//  ReceiptSplitter
//
//  Created by Hugo Queinnec on 16/01/2022.
//

import SwiftUI

struct ShopListView: View {
    @State private var selectedIndex = Shop.ShopReceiptType.aldi_suisse
    
    var body: some View {
        NavigationView {
            Form {
                VStack {
                    Picker("", selection: $selectedIndex, content: { // <2>
                        ForEach(Shop.ShopReceiptType.allCases, id: \.self, content: { shopType in
                            ShopRow(shop: Shop(shop: shopType))
                        })
                    })
                        .foregroundColor(.primary)
                    //ShopRow(shop: Shop(shop: selectedIndex))
                }
            }
        }
    }
}

struct ShopListView_Previews: PreviewProvider {
    static var previews: some View {
        ShopListView()
    }
}
