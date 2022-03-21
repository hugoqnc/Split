//
//  FillFavoriteButton.swift
//  ReceiptSplitter
//
//  Created by Hugo Queinnec on 21/03/2022.
//

import SwiftUI

struct FillFavoriteButton: View {
    @Binding var names: [String]
    @Binding var newUserName: String
    @Binding var currencyType: Currency.SymbolType
    
    @State private var savedNames: [String] = []
    @State private var savedCurrency = Currency.default
    
    var nothingSaved: Bool {
        get {
            return savedNames.isEmpty
        }
    }
    
    var descriptiveString: String {
        get {
            if nothingSaved {
                return "No saved favorites"
            } else {
                var namesText = ""
                for i in 0..<savedNames.count {
                    namesText.append(savedNames[i])
                    if i<savedNames.count-1 {
                        namesText.append(", ")
                    }
                }
                namesText.append(" (\(savedCurrency.value))")
                return namesText
            }
        }
    }
    
    var body: some View {
        HStack {
            Button {
                withAnimation() {
                    names = savedNames
                    currencyType = savedCurrency.symbol
                    newUserName = ""
                }
            } label: {
                HStack {
                    Image(systemName: "star")
                        .foregroundColor(.orange)
                        .padding(.trailing, 6)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Fill with favorites")
                            //.foregroundColor(Color.accentColor)
                        Text(descriptiveString)
                            .font(.caption)
                            .foregroundColor(Color.secondary)
                    }
                    Spacer()
                }
            }
            .buttonStyle(.plain)
            .disabled(nothingSaved)
            .onAppear {
                PreferencesStore.load { result in
                    switch result {
                    case .failure(let error):
                        fatalError(error.localizedDescription)
                    case .success(let preferences):
                        savedNames = preferences.names
                        savedCurrency = preferences.currency
                    }
                }
            }
        }
    }
}

struct FillFavoriteButton_Previews: PreviewProvider {
    static var previews: some View {
        FillFavoriteButton(names: .constant(["Hugo", "Thomas"]), newUserName: .constant("Lucas"), currencyType: .constant(Currency.SymbolType.euro))
    }
}
