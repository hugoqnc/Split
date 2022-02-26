//
//  HistoryView.swift
//  ReceiptSplitter
//
//  Created by Hugo Queinnec on 26/02/2022.
//

import SwiftUI

struct HistoryView: View {
    
    @Binding var showHistoryView: Bool
    
    var body: some View {
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            Button {
                withAnimation() {
                    showHistoryView = false
                }
            } label: {
                Text("Back")
            }
        }
        .transition(.slide)

    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView(showHistoryView: .constant(true))
    }
}
