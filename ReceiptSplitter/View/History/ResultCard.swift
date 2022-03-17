//
//  ResultCard.swift
//  ReceiptSplitter
//
//  Created by Hugo Queinnec on 26/02/2022.
//

import SwiftUI

struct ResultCard: View {
    var resultUnit: ResultUnit
    
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
                    
                    Label("\(String(round(totalPrice * 100) / 100.0))\(resultUnit.currency.value) • \(resultUnit.listOfProductsAndPrices.count) items", systemImage: "cart")
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
        .padding(.horizontal)
    }
}

import UIKit

extension UIColor {
    /// Generate a color from the given string deterministically.
    ///
    /// Generated colors are *not* evenly distributed in the HSL color space, but you and/or your users also probably won't be able to tell.
    convenience init(_ string: String, saturation: Double = 0.8, brightness: Double = 0.8) {
        let seed = Double.pi // Can be any positive irrational number. Pi was chosen for flavor.
        let hash = string
            .compactMap { $0.unicodeScalars.first?.value.byteSwapped }
            .map(Double.init)
            .reduce(seed) { (hash, unicodeValue) in
                return (hash * seed * unicodeValue)
                    .truncatingRemainder(dividingBy: 360)
            }

        let hue = hash / 360

        self.init(hue: CGFloat(hue), saturation: CGFloat(saturation), brightness: CGFloat(brightness), alpha: 1.0)
    }
}

struct ResultCard_Previews: PreviewProvider {
    static let resultUnit: ResultUnit = {
        let users = [User(name: "Hugo"), User(name: "Lucas"), User(name: "Thomas"), User(name: "Corentin"), User(name: "Nicolas"), User(name: "Hortense")]
        var listOfProductsAndPrices = [PairProductPriceCodable(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBB", name: "Potato Wedges 1kg", price: 4.99), PairProductPriceCodable(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBC", name: "Finger Fish", price: 1.27), PairProductPriceCodable(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBD", name: "Ice Cream Strawberry", price: 3.20)]
        listOfProductsAndPrices[0].chosenBy = [users[0].id]
        listOfProductsAndPrices[1].chosenBy = [users[0].id, users[1].id]
        
        var resultUnit = ResultUnit(id: UUID(), users: users, listOfProductsAndPrices: listOfProductsAndPrices, currency: Currency.default, date: Date(), imagesData: [], receiptName: "ALDI Suisse, Monoprix, Migros")
        
        return resultUnit
    }()
    
    static var previews: some View {
        ResultCard(resultUnit: resultUnit)
    }
}
