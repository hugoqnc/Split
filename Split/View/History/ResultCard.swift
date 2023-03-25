//
//  ResultCard.swift
//  Split
//
//  Created by Hugo Queinnec on 26/02/2022.
//

import SwiftUI

struct ResultCard: View {
    var resultUnit: ResultUnitText
    
    @Environment(\.colorScheme) var colorScheme
    
    var date: String {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .long
            dateFormatter.timeStyle = .none
            let dateString = dateFormatter.string(from: resultUnit.date)
            return dateString
        }
    }
    
    var time: String {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .none
            dateFormatter.timeStyle = .short
            let timeString = dateFormatter.string(from: resultUnit.date)
            return timeString
        }
    }
    
    var namesText: String {
        get {
            var namesText = ""
            for i in 0..<resultUnit.users.count {
                let u = resultUnit.users[i]
                namesText.append(u.name)
                if i<resultUnit.users.count-1 {
                    namesText.append(", ")
                }
            }
            return namesText
        }
    }
    
    var totalPrice: Double {
        get {
            var total: Double = 0
            for item in resultUnit.listOfProductsAndPrices{
                total += item.price
            }
            let totalPriceBeforeTaxTip = total
            if let t = resultUnit.tipRate {
                total += t*totalPriceBeforeTaxTip/100
            }
            if let t = resultUnit.taxRate {
                total += t*totalPriceBeforeTaxTip/100
            }
            return total
        }
    }
    
    var colorMatching: Color {
        get {
            return Color.init(uiColor: UIColor(date))
        }
    }
    
    var body: some View {
        HStack {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(date.uppercased())
                            .font(.footnote)
                            .fontWeight(.semibold)
                        Spacer()
                        Text(time.uppercased())
                            .font(.footnote)
                            .fontWeight(.semibold)
                    }
                    
                    HStack(spacing:0) {
                        Text(resultUnit.receiptName)
                            .font(.title)
                            .fontWeight(.semibold)
                            .lineLimit(1)
                    }
                    .foregroundColor(colorMatching)
                    .brightness(colorScheme == .dark ? 0.2 : -0.3)
                    
                    Label("\(formatPriceAndCurrency(price: totalPrice, currency: resultUnit.currency)) • \(resultUnit.listOfProductsAndPrices.count) items", systemImage: "cart")
                        .font(.subheadline)
                        .foregroundColor(colorMatching)
                        .brightness(colorScheme == .dark ? 0 : -0.1)
                        .lineLimit(1)
                    
                    Label(namesText, systemImage: "person.2")
                        .font(.subheadline)
                        .foregroundColor(colorMatching)
                        .brightness(colorScheme == .dark ? 0 : -0.1)
                        .lineLimit(1)
                }
                Spacer()
                Image(systemName: "chevron.right")
            }
            .padding()
        }
        .background(colorMatching.opacity(0.1))
        .brightness(colorScheme == .dark ? 0.4 : 0)
        .background(colorScheme == .dark ? .black : .white)
        .cornerRadius(15)
    }
}

import UIKit

struct ResultCard_Previews: PreviewProvider {
    static let resultUnit: ResultUnitText = {
        let users = [User(name: "Hugo"), User(name: "Lucas"), User(name: "Thomas"), User(name: "Corentin"), User(name: "Nicolas"), User(name: "Hortense")]
        var listOfProductsAndPrices = [PairProductPriceCodable(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBB", name: "Potato Wedges 1kg", price: 4.99), PairProductPriceCodable(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBC", name: "Finger Fish", price: 1.27), PairProductPriceCodable(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBD", name: "Ice Cream Strawberry", price: 3.20)]
        listOfProductsAndPrices[0].chosenBy = [users[0].id]
        listOfProductsAndPrices[1].chosenBy = [users[0].id, users[1].id]
        
        var resultUnit = ResultUnitText(id: UUID(), users: users, listOfProductsAndPrices: listOfProductsAndPrices, currency: Currency.default, date: Date(), receiptName: "ALDI Suisse, Monoprix, Migros")
        
        return resultUnit
    }()
    
    static var previews: some View {
        ResultCard(resultUnit: resultUnit)
    }
}
