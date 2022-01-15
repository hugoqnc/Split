//
//  ShopRow.swift
//  ReceiptSplitter
//
//  Created by Hugo Queinnec on 16/01/2022.
//

import SwiftUI

struct ShopRow: View {
    var shop: Shop
    
    var body: some View {
        HStack {
            shop.image
                .resizable()
                .frame(width: 50, height: 50)
                .cornerRadius(10)
                .padding(.top, 5)
                .padding(.bottom, 5)
                .padding(.trailing, 10)
            Text(shop.name)
            Spacer()
        }
    }
}

struct ShopRow_Previews: PreviewProvider {
    static var previews: some View {
        ShopRow(shop: Shop.default)
    }
}
