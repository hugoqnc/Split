//
//  LoadItemsView.swift
//  ReceiptSplitter
//
//  Created by Hugo Queinnec on 08/01/2022.
//

import SwiftUI

struct LoadItemsView: View {
    var body: some View {
        ZStack {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .scaleEffect(2)
        }
        .interactiveDismissDisabled(true)
    }
    
}

struct LoadItemsView_Previews: PreviewProvider {
    static var previews: some View {
        LoadItemsView()
    }
}
