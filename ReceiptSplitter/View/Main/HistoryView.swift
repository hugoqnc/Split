//
//  HistoryView.swift
//  ReceiptSplitter
//
//  Created by Hugo Queinnec on 26/02/2022.
//

import SwiftUI

struct HistoryView: View {
    @State private var results = Results.default
    
    var body: some View {
        //NavigationView {
            VStack {                
                List {
                    ForEach(results.results) { result in
                        NavigationLink("\(result.listOfProductsAndPrices.count) items") {
                            ResultViewHistoryWrapper(users: result.users, listOfProductsAndPricesCodable: result.listOfProductsAndPrices, currency: result.currency)
                        }
                    }
                }
            }
            .navigationTitle("History")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                ResultsStore.load { result in
                    switch result {
                    case .failure(let error):
                        fatalError(error.localizedDescription)
                    case .success(let results):
                        self.results = results
                    }
                }
            }
        //}
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
