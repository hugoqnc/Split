//
//  ContentView.swift
//  Scan-Ocr
//
//  Created by Haaris Iqubal on 5/21/21.
//

import SwiftUI

struct ContentView: View {
    init() {
        UITableView.appearance().backgroundColor = .clear
    }
    var body: some View {
        //StartView()
        ResultView_Previews.previews
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
