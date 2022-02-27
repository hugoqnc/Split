//
//  HistoryView.swift
//  ReceiptSplitter
//
//  Created by Hugo Queinnec on 26/02/2022.
//

import SwiftUI

struct HistoryView: View {
    @State private var results = Results.default
    
    func date(resultUnit: ResultUnit) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        let dateString = dateFormatter.string(from: resultUnit.date)
        return dateString
    }
    
    var body: some View {
        VStack {
            ScrollView {
                ForEach(results.results) { resultUnit in
                    NavigationLink {
                        ResultViewHistoryWrapper(resultUnit: resultUnit)
                            .navigationTitle(date(resultUnit: resultUnit))
                    } label: {
                        ResultCard(resultUnit: resultUnit)
                    }
                    .contextMenu{
                        Button(role: .destructive){
                            //remove from the view
                            results.results.removeAll { r in
                                r.id == resultUnit.id
                            }
                            
                            //remove from persistent storage
                            ResultsStore.remove(resultUnit: resultUnit) { result in
                                switch result {
                                case .failure(let error):
                                    fatalError(error.localizedDescription)
                                case .success(_):
                                    print("deleted!")
                                }
                            }
                        } label: {
                            Label("Delete this receipt", systemImage: "trash")
                        }
                    }

                }
                .tint(.primary)
                .padding(.top, 25)
            }
        }
        .navigationTitle("History")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            ResultsStore.load { result in
                switch result {
                case .failure(let error):
                    fatalError(error.localizedDescription) //TODO: "Fatal error: The data couldn’t be read because it is missing." 
                case .success(let results):
                    self.results = results
                }
            }
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HistoryView()
        }
    }
}
