//
//  HistoryStatView.swift
//  ReceiptSplitter
//
//  Created by Hugo Queinnec on 02/03/2022.
//

import SwiftUI

struct HistoryStatView: View {
    var results: Results
    @Environment(\.horizontalSizeClass) var horizontalSizeClass //for iPad specificity
    
    func showPrice(price: Double) -> String {
        return String(round(price * 100) / 100.0)+"-"
    }
    
    var totalPrice: Double {
        get {
            let listOfTotals = results.results.map { res in
                return res.listOfProductsAndPrices.reduce(0, {$0 + $1.price})
            }
            return listOfTotals.reduce(0, {$0 + $1})
        }
    }
    
    var totalItems: Int {
        get {
            let listOfTotals = results.results.map { res in
                return res.listOfProductsAndPrices.count
            }
            return listOfTotals.reduce(0, {$0 + $1})
        }
    }
    
    var averageItemPrice: Double {
        get {
            return totalPrice / Double(totalItems)
        }
    }
    
    var maximumItemPrice: Double {
        get {
            let listOfMax = results.results.map { res in
                return res.listOfProductsAndPrices.map({ pair in pair.price }).max() ?? 0.0
            }
            return listOfMax.max() ?? 0.0
        }
    }
    
    var minimumItemPrice: Double {
        get {
            let listOfMin = results.results.map { res in
                return res.listOfProductsAndPrices.map({ pair in pair.price }).min() ?? 0.0
            }
            return listOfMin.min() ?? 0.0
        }
    }
    
    var numberDifferentUsers: Int {
        get {
            let listOfUsers = results.results.flatMap { res in
                return res.users
            }
            let set = Set(listOfUsers)
            return set.count
        }
    }
    
    var numberOfReceipts: Int {
        get {
            return results.results.count
        }
    }
    
    var daysSinceFirstReceipt: Int {
        get {
            let minDate = results.results.map { res in
                return res.date
            }.min()!
            
            let delta = Date().timeIntervalSince(minDate)
            return Int(delta/(60*60*24))
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                Group {
                    if horizontalSizeClass == .compact {
                    VStack {
                        HStack {
                            Spacer()
                            
                            StatisticRectangle(iconString: "doc.plaintext", description: "Number of receipts\n", value: String(numberOfReceipts), color: Color.yellow)
                            
                            StatisticRectangle(iconString: "number", description: "Total number of\npurchases", value: String(totalItems), color: Color.blue)
                            
                            Spacer()
                        }
                        HStack {
                            Spacer()
                            
                            StatisticRectangle(iconString: "creditcard", description: "Total paid price\n", value: showPrice(price: totalPrice), color: Color.purple)
                            
                            StatisticRectangle(iconString: "cart", description: "Average price\nof an item", value: showPrice(price: averageItemPrice), color: Color.orange)
                            
                            Spacer()
                        }
                        HStack {
                            Spacer()
                            
                            StatisticRectangle(iconString: "arrow.up.right.circle", description: "Maximum price\nof an item", value: showPrice(price: maximumItemPrice), color: Color.green)
                            
                            StatisticRectangle(iconString: "arrow.down.right.circle", description: "Minimum price\nof an item", value: showPrice(price: minimumItemPrice), color: Color.red)
                            
                            Spacer()
                        }
                        HStack {
                            Spacer()
                            
                            StatisticRectangle(iconString: "calendar", description: "Days passed since\nfirst receipt", value: String(daysSinceFirstReceipt), color: Color(red: 255 / 255, green: 101 / 255, blue: 227 / 255))
                            
                            StatisticRectangle(iconString: "person.2", description: "Number of\ndifferent users", value: String(numberDifferentUsers), color: Color.teal)
                            
                            Spacer()
                        }

                        Spacer()
                    }
                        
                    } else {
                        
                        VStack {
                            HStack {
                                Spacer()

                                StatisticRectangle(iconString: "doc.plaintext", description: "Number of receipts\n", value: String(numberOfReceipts), color: Color.yellow)
                                
                                StatisticRectangle(iconString: "number", description: "Total number of\npurchases", value: String(totalItems), color: Color.blue)

                                StatisticRectangle(iconString: "creditcard", description: "Total paid price\n", value: showPrice(price: totalPrice), color: Color.purple)
                                
                                StatisticRectangle(iconString: "cart", description: "Average price\nof an item", value: showPrice(price: averageItemPrice), color: Color.orange)

                                Spacer()
                            }
                            
                            HStack {
                                Spacer()

                                StatisticRectangle(iconString: "arrow.up.right.circle", description: "Maximum price\nof an item", value: showPrice(price: maximumItemPrice), color: Color.green)
                                
                                StatisticRectangle(iconString: "arrow.down.right.circle", description: "Minimum price\nof an item", value: showPrice(price: minimumItemPrice), color: Color.red)

                                StatisticRectangle(iconString: "calendar", description: "Days passed since\nfirst receipt", value: String(daysSinceFirstReceipt), color: Color(red: 255 / 255, green: 101 / 255, blue: 227 / 255))
                                
                                StatisticRectangle(iconString: "person.2", description: "Number of\ndifferent users", value: String(numberDifferentUsers), color: Color.teal)
                                
                                Spacer()
                            }
                            
                            Spacer()
                        }
                    }
                }
                .padding(.vertical)
                .padding(.horizontal,5)
                .navigationTitle("Statistics")
            }
        }
    }
}

struct HistoryStatView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryStatView(results: Results(results: [ResultUnit(users: [], listOfProductsAndPrices: [], currency: Currency.default, date: Date(), imagesData: [])]))
    

        HistoryStatView(results: Results(results: [ResultUnit(users: [], listOfProductsAndPrices: [], currency: Currency.default, date: Date(), imagesData: [])]))
        .previewDevice(PreviewDevice(rawValue:"iPad Air (4th generation)"))
        .navigationViewStyle(.stack)
        .previewInterfaceOrientation(.portrait)

    }
}

