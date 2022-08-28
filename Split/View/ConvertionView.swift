//
//  ConvertionView.swift
//  Split
//
//  Created by Hugo Queinnec on 28/08/2022.
//

import SwiftUI

struct ConvertionView: View {
    @State private var oldResults: [ResultUnit] = []
    @State public var loading = false
    @State public var dataIndex = 0
    
    var body: some View {
        VStack {
            Text(oldResults.isEmpty ? "Data not loaded" : "\(oldResults.count) receipts loaded")
            
            Button {
                ResultsStoreOLD.load { result in
                     switch result {
                     case .failure(let error):
                         fatalError(error.localizedDescription)
                     case .success(let results):
                         oldResults = results.results
                     }
                 }
            } label: {
                Text("Load data")
            }
            .padding()
            
            Text("Converted \(dataIndex) out of \(oldResults.count)")
            
            Button {
                if dataIndex < oldResults.count {
                    loading = true
                    let oldResult = oldResults[dataIndex]
                    
                    let newResultText = ResultUnitText(id: oldResult.id, users: oldResult.users, listOfProductsAndPrices: oldResult.listOfProductsAndPrices, currency: oldResult.currency, date: oldResult.date, receiptName: oldResult.receiptName)
                    
                    ResultsStore.append(resultUnit: newResultText, imagesData: oldResult.imagesData) { result in
                        switch result {
                        case .failure(let error):
                            fatalError(error.localizedDescription)
                        case .success(_):
                            print("DONE: \(newResultText.receiptName)")
                            dataIndex += 1
                            loading = false
                        }
                    }
                }
            } label: {
                Text("Convert next one!")
            }
            .padding()
            
            if loading {
                ProgressView()
            }
            
        }
    }
}

struct ConvertionView_Previews: PreviewProvider {
    static var previews: some View {
        ConvertionView()
    }
}
