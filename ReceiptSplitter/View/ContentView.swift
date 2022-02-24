//
//  ContentView.swift
//  ReceiptSplitter
//
//  Created by Hugo Queinnec on 04/01/2022.
//

import SwiftUI

struct ContentView: View {
    init() {
        UITableView.appearance().backgroundColor = .clear
    }
    var body: some View {
        StartView()
        //FirstListView_Previews.previews
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
