//
//  HistoryView.swift
//  Split
//
//  Created by Hugo Queinnec on 26/02/2022.
//

import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var model: ModelData
    @Binding var showHistoryView: Bool
    @State private var results = Results.default
    @State private var loadingDataIsFinished = false
    @State private var showStats = false
    
    func date(resultUnit: ResultUnitText) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        let dateString = dateFormatter.string(from: resultUnit.date)
        return dateString
    }
    
    var body: some View {
        VStack {
            if results.results.isEmpty && !loadingDataIsFinished {
                ZStack {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                }
            } else if results.results.isEmpty && loadingDataIsFinished {
                NoHistoryView(showHistoryView: $showHistoryView)
            } else {
                ScrollView {
                    HStack {
                        Text("\(results.results.count) saved reports".uppercased())
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.leading, 25)
                            .padding(.top, 20)
                            .padding(.bottom, -4)
                        Spacer()
                    }

                    ForEach(results.results.sorted(by: {$0.date > $1.date})) { resultUnit in
                        NavigationLink {
                            ResultViewHistoryWrapper(resultUnit: resultUnit, tricountList: model.parameters.tricountList)
                                .navigationTitle(date(resultUnit: resultUnit))
                                .navigationBarTitleDisplayMode(.inline)
                        } label: {
                            ResultCard(resultUnit: resultUnit)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .contextMenu{
                            Button(role: .destructive){
                                //remove from the view
                                withAnimation(){
                                    results.results.removeAll { r in
                                        r.id == resultUnit.id
                                    }
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
                        .padding(.horizontal)

                    }
                    .tint(.primary)
                    .padding(.top, 4)
                    
                    HStack {
                        Label("Receipts ordered chronologically", systemImage: "arrow.up.arrow.down")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 25)
                            .padding(.vertical, 5)
                        Spacer()
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            showStats = true
                        } label: {
                            Image(systemName: "chart.pie")
                        }
                        //.padding(.trailing, 10)
                        .sheet(isPresented: $showStats) {
                            HistoryStatView(results: results, favoriteCurrency: model.parameters.defaultCurrency, showTipAndTax: model.parameters.showTipAndTax)
                        }
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
                    loadingDataIsFinished = true
                }
            }
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HistoryView(showHistoryView: .constant(true))
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
