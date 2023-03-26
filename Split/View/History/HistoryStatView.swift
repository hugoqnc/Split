//
//  HistoryStatView.swift
//  Split
//
//  Created by Hugo Queinnec on 02/03/2022.
//

import SwiftUI

struct HistoryStatView: View {
    internal init(results: Results, favoriteCurrency: Currency, showTipAndTax: Bool) {
        self.results = results
        self.showTipAndTax = showTipAndTax
        _currencyType = State(initialValue: favoriteCurrency.symbol)
    }
    
    var results: Results
    var showTipAndTax : Bool
    @Environment(\.horizontalSizeClass) var horizontalSizeClass //for iPad specificity
    
    var timeOptions = ["All", "For a year", "For a month", "For a week"]
    @State private var selectedTimeOption = "All"
    @State private var currencyType: Currency.SymbolType
    
    var filteredResultList: [ResultUnitText] {
        get {
            let r = results.results
            let now = Date()
            let rFiltered = r.filter { resultUnit in
                let d = resultUnit.date
                
                switch selectedTimeOption {
                case timeOptions[0]:
                    return true
                case timeOptions[1]:
                    return Calendar.current.date(byAdding: .year, value: -1, to: now)! < d
                case timeOptions[2]:
                    return Calendar.current.date(byAdding: .month, value: -1, to: now)! < d
                case timeOptions[3]:
                    return Calendar.current.date(byAdding: .weekOfYear, value: -1, to: now)! < d
                default:
                    return false
                }
            }
            let rFiltered2 = rFiltered.filter { resultUnit in
                resultUnit.currency.symbol == currencyType
            }
            return rFiltered2
        }
    }
    
    var currencyString: String {
        get {
            let listOfCurrencies = filteredResultList.map { res in
                return res.currency.value
            }
            if Set(listOfCurrencies).count == 1 {
                return listOfCurrencies[0]
            } else {
                return Currency.default.value
            }
        }
    }
    
    var startingDate: String {
        get {
            var d1: Date
            let now = Date()
            
            switch selectedTimeOption {
            case timeOptions[0]:
                d1 = filteredResultList.map { res in
                    return res.date
                }.min() ?? Date()
            case timeOptions[1]:
                d1 = Calendar.current.date(byAdding: .year, value: -1, to: now)!
            case timeOptions[2]:
                d1 = Calendar.current.date(byAdding: .month, value: -1, to: now)!
            case timeOptions[3]:
                d1 = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: now)!
            default:
                d1 = Date() //error
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .long
            dateFormatter.timeStyle = .short
            let dateString = dateFormatter.string(from: d1)
            return dateString
        }
    }
    
    func showPrice(price: Double) -> String {
        return formatPriceAndCurrency(price: price, currency: Currency(symbol: currencyType))
    }
    
    var totalPrice: Double {
        get {
            let listOfTotals = filteredResultList.map { res in
                return res.listOfProductsAndPrices.reduce(0, {$0 + $1.price})
            }
            return listOfTotals.reduce(0, {$0 + $1})
        }
    }
    
    var totalTipAmount: Double {
        get {
            let listOfTips = filteredResultList.map { res in
                return res.listOfProductsAndPrices.reduce(0, {$0 + $1.price}) * (res.tipRate ?? 0)/100
            }
            return listOfTips.reduce(0, {$0 + $1})
        }
    }
    
    var totalTaxAmount: Double {
        get {
            let listOfTaxes = filteredResultList.map { res in
                return res.listOfProductsAndPrices.reduce(0, {$0 + $1.price}) * (res.taxRate ?? 0)/100
            }
            return listOfTaxes.reduce(0, {$0 + $1})
        }
    }
    
    var totalItems: Int {
        get {
            let listOfTotals = filteredResultList.map { res in
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
            let listOfMax = filteredResultList.map { res in
                return res.listOfProductsAndPrices.map({ pair in pair.price }).max() ?? 0.0
            }
            return listOfMax.max() ?? 0.0
        }
    }
    
    var maximumItemName: String {
        get {
            let listOfMax = filteredResultList.compactMap { res in
                return res.listOfProductsAndPrices.sorted(by: {$0.price>$1.price}).first
            }
            return listOfMax.sorted(by: {$0.price>$1.price}).first?.name ?? "none"
        }
    }
    
    var minimumItemName: String {
        get {
            let listOfMin = filteredResultList.compactMap { res in
                return res.listOfProductsAndPrices.sorted(by: {$0.price<$1.price}).filter{$0.price>0}.first
            }
            return listOfMin.sorted(by: {$0.price<$1.price}).first?.name ?? "none"
        }
    }
    
    var minimumItemPrice: Double {
        get {
            let listOfMin = filteredResultList.map { res in
                return res.listOfProductsAndPrices.map({ pair in pair.price }).filter{$0>0}.min() ?? 0.0
            }
            return listOfMin.min() ?? 0.0
        }
    }
    
    var numberDifferentUsers: Int {
        get {
            let listOfUsers = filteredResultList.flatMap { res in
                return res.users.map {u in return u.name}
            }
            return Set(listOfUsers).count
        }
    }
    
    var numberOfReceipts: Int {
        get {
            return filteredResultList.count
        }
    }
    
    var daysSince: Int {
        get {
            let d: Date
            if selectedTimeOption == timeOptions[0] { // since first receipt
                d = filteredResultList.map { res in
                    return res.date
                }.min()!
            } else { // since last receipt
                d = filteredResultList.map { res in
                    return res.date
                }.max()!
            }
            
            let delta = Date().timeIntervalSince(d)
            return Int(delta/(60*60*24))
        }
    }
    
    var body: some View {
        NavigationView {
            Group {
                if !filteredResultList.isEmpty {
                    ScrollView {
                        VStack {
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
                                        
                                        StatisticRectangle(iconString: "arrow.up.right.circle", description: "Maximum price\n(\(maximumItemName))", value: showPrice(price: maximumItemPrice), color: Color.green)
                                        
                                        StatisticRectangle(iconString: "arrow.down.right.circle", description: "Minimum price\n(\(minimumItemName))", value: showPrice(price: minimumItemPrice), color: Color.red)
                                        
                                        Spacer()
                                    }
                                    if showTipAndTax {
                                        HStack {
                                            Spacer()
                                            
                                            StatisticRectangle(iconString: "giftcard", description: "Total amount of tips\n", value: showPrice(price: totalTipAmount), color: Color.pink)
                                            
                                            StatisticRectangle(iconString: "building.columns", description: "Total amount of taxes\n", value: showPrice(price: totalTaxAmount), color: CustomColor.bankGreen)
                                            
                                            Spacer()
                                        }
                                    }
                                    HStack {
                                        Spacer()
                                        
                                        StatisticRectangle(iconString: "calendar", description: selectedTimeOption == timeOptions[0] ? "Days passed since\nfirst receipt" : "Days passed since\nlast receipt", value: String(daysSince), color: CustomColor.realPink)
                                        
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
                                            
                                            Spacer()
                                        }
                                        
                                        HStack {
                                            Spacer()
                                            
                                            StatisticRectangle(iconString: "cart", description: "Average price\nof an item", value: showPrice(price: averageItemPrice), color: Color.orange)

                                            StatisticRectangle(iconString: "arrow.up.right.circle", description: "Maximum price\n(\(maximumItemName))", value: showPrice(price: maximumItemPrice), color: Color.green)
                                            
                                            StatisticRectangle(iconString: "arrow.down.right.circle", description: "Minimum price\n(\(minimumItemName))", value: showPrice(price: minimumItemPrice), color: Color.red)
                                            
                                            Spacer()
                                        }
                                        
                                        if showTipAndTax {
                                            HStack {
                                                Spacer()

                                                StatisticRectangle(iconString: "giftcard", description: "Total amount of tips\n", value: showPrice(price: totalTipAmount), color: Color.pink)
                                                
                                                StatisticRectangle(iconString: "building.columns", description: "Total amount of taxes\n", value: showPrice(price: totalTaxAmount), color: CustomColor.bankGreen)
                                                
                                                StatisticRectangle(iconString: "calendar", description: selectedTimeOption == timeOptions[0] ? "Days passed since\nfirst receipt" : "Days passed since\nlast receipt", value: String(daysSince), color: CustomColor.realPink)
                                                
                                                Spacer()
                                            }
                                            
                                            HStack {
                                                Spacer()
                                                
                                                StatisticRectangle(iconString: "person.2", description: "Number of\ndifferent users", value: String(numberDifferentUsers), color: Color.teal)
                                                
                                                Text("") //empty stat rectangle
                                                    .frame(idealWidth: 140, maxWidth: 200, idealHeight: 140, maxHeight: 200)
                                                    .padding()
                                                
                                                Text("") //empty stat rectangle
                                                    .frame(idealWidth: 140, maxWidth: 200, idealHeight: 140, maxHeight: 200)
                                                    .padding()
                                                
                                                Spacer()
                                            }
                                            
                                        } else {
                                            HStack {
                                                Spacer()

                                                StatisticRectangle(iconString: "calendar", description: selectedTimeOption == timeOptions[0] ? "Days passed since\nfirst receipt" : "Days passed since\nlast receipt", value: String(daysSince), color: CustomColor.realPink)
                                                
                                                StatisticRectangle(iconString: "person.2", description: "Number of\ndifferent users", value: String(numberDifferentUsers), color: Color.teal)
                                                
                                                Text("") //empty stat rectangle
                                                    .frame(idealWidth: 140, maxWidth: 200, idealHeight: 140, maxHeight: 200)
                                                    .padding()
                                                
                                                Spacer()
                                            }
                                        }
                                        
                                        Spacer()
                                    }
                                }
                            }
                            .padding(.vertical)
                            .padding(.horizontal,5)
                            
                            Text("Statistics since "+startingDate)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                    }
                } else {
                    VStack {
                        Image(systemName: "square.stack.3d.up.slash")
                            .foregroundColor(.red)
                            .font(.largeTitle)
                            
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Unfortunately, there are no receipts in \(Currency(symbol: currencyType).value) saved since \(startingDate).")
                                .font(.headline)
                            Text("To see other statistics, change the currency or the time scale.")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .padding(.horizontal)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Picker("Choose a time scale", selection: $selectedTimeOption) {
                        ForEach(timeOptions, id: \.self) {
                            Text($0)
                        }
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    Picker("Currency", selection: $currencyType.animation()) {
                        ForEach(Currency.SymbolType.allCases, id: \.self, content: { currencyType in
                            Text(Currency(symbol: currencyType).value)
                        })
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Statistics")
        }
    }
}

struct HistoryStatView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryStatView(results: Results(results: [ResultUnitText(users: [], listOfProductsAndPrices: [], currency: Currency.default, date: Date(timeIntervalSince1970: 1645000000), receiptName: "ALDI"), ResultUnitText(users: [], listOfProductsAndPrices: [], currency: Currency.default, date: Date(timeIntervalSince1970: 1640000000), receiptName: "Migros")]), favoriteCurrency: Currency.default, showTipAndTax: true)
        //HistoryStatView(results: Results(results: []))
    

//        HistoryStatView(results: Results(results: [ResultUnit(users: [], listOfProductsAndPrices: [], currency: Currency.default, date: Date(), imagesData: [])]))
//        .previewDevice(PreviewDevice(rawValue:"iPad Air (4th generation)"))
//        .navigationViewStyle(.stack)
//        .previewInterfaceOrientation(.portrait)

    }
}

