//
//  PreferenceButton.swift
//  ReceiptSplitter
//
//  Created by Hugo Queinnec on 27/01/2022.
//

import SwiftUI

struct PreferenceButton: View {
    @Binding var names: [String]
    @Binding var newUserName: String
    @Binding var currencyType: Currency.SymbolType
    @Binding var showAlert1: Bool
    @Binding var showAlert2: Bool
    
    @State private var savedNames: [String] = []
    @State private var savedCurrency = Currency.default
    
    var buttonHeight: CGFloat = 55.0
    
    var nothingSaved: Bool {
        get {
            return savedNames.isEmpty
        }
    }
    
    var nothingWritten: Bool {
        get {
            return names.isEmpty
        }
    }
    
    var descriptiveString: String {
        get {
            var text = "\(savedCurrency.value) • "
            
            
            var namesText = ""
            for i in 0..<savedNames.count {
                namesText.append(savedNames[i])
                if i<savedNames.count-1 {
                    namesText.append(", ")
                }
            }
            
            text.append(namesText)
            
            return text
        }
    }
    
    var completeNames : [String] {
        get {
            var completeNamesArray = names
            
            let realName = newUserName.trimmingCharacters(in: .whitespaces)
            if !realName.isEmpty {
                if !names.contains(realName) {
                    completeNamesArray.append(realName)
                }
            }
            return completeNamesArray
        }
    }
    
    func checkAndAddName() -> Bool {
        let realName = newUserName.trimmingCharacters(in: .whitespaces)
        if !realName.isEmpty {
            if !names.contains(realName) {
                withAnimation() {
                    names.append(realName)
                }
                newUserName = ""
                return true
            } else {
                showAlert2 = true
            }
        } else {
            showAlert1 = true
        }
        return false
    }
    
    func isFinalUsersCorrect() -> Bool {
        var ok = true
        if !newUserName.isEmpty {
            ok = checkAndAddName()
        }
        if ok {
            return true
        } else {
            return false
        }
    }
    
    var body: some View {
        VStack {
            if (!nothingSaved || !nothingWritten) && (completeNames != savedNames || currencyType != savedCurrency.symbol) {
                HStack {
                HStack {
                    if !nothingSaved {
                        Button {
                            PreferencesStore.load { result in
                                switch result {
                                case .failure(let error):
                                    fatalError(error.localizedDescription)
                                case .success(let preferences):
                                    withAnimation() {
                                        names = preferences.names
                                        currencyType = preferences.currency.symbol
                                        newUserName = ""
                                    }
                                }
                            }
                        } label: {
                            Group {
                                HStack {
                                    Image(systemName: "star.fill")
                                        .padding(.trailing, 5)
                                    VStack(alignment: .leading) {
                                        Text("Load favorite preferences ")
                                        Text(descriptiveString)
                                            .font(.caption)
                                    }
                                }
                                .tint(.orange)
                            }
                            .transition(.asymmetric(insertion: .offset(x: 0, y: -60), removal: .offset(x: 0, y: 60)))
                        }
                        
                        Divider()
                            .padding(.horizontal,3)
                    }
                    
                    Button {
                        if isFinalUsersCorrect() {
                            var preferences = Preferences()
                            preferences.names = completeNames
                            preferences.currency = Currency(symbol: currencyType)
                            
                            PreferencesStore.save(preferences: preferences) { result in
                                switch result {
                                case .failure(let error):
                                    fatalError(error.localizedDescription)
                                case .success(_):
                                    withAnimation() {
                                        savedNames = completeNames
                                        savedCurrency = Currency(symbol: currencyType)
                                    }
                                }
                            }
                        }
                    } label: {
                        Group {
                            if nothingSaved {
                                Image(systemName: "square.and.arrow.down")
                                    .padding(.trailing, 5)
                                VStack(alignment: .leading) {
                                    Text("Save current preferences")
                                    Text("Save names and currency for next time")
                                        .font(.caption)
                                }
                                .padding(.trailing, 5)
                            } else if nothingWritten {
                                VStack {
                                    Image(systemName: "xmark")
                                        .padding(.bottom,-3)
                                        .padding(.top,1)
                                    Text("Delete")
                                        .font(.caption)
                                }
                            } else {
                                VStack {
                                    Image(systemName: "arrow.triangle.2.circlepath")
                                        .padding(.bottom,-3)
                                    Text("Update")
                                        .font(.caption)
                                }
                            }
                        }
                        .transition(.asymmetric(insertion: .offset(x: 0, y: -60), removal: .offset(x: 0, y: 60)))
                    }
                    .tint(nothingWritten ? .red : .accentColor)
                    
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .frame(maxHeight: buttonHeight)
            }
            .background(Color(uiColor: UIColor.systemBackground).brightness(0.06))
            .cornerRadius(10)
            .shadow(color: .black.opacity(0.2), radius: 15.0)
            }
        }
        .transition(.move(edge: .top))
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

struct PreferenceButton_Previews: PreviewProvider {
    static var previews: some View {
        PreferenceButton(names: .constant(["Hugo", "Thomas"]), newUserName: .constant("Lucas"), currencyType: .constant(Currency.SymbolType.euro), showAlert1: .constant(false), showAlert2: .constant(false))
            .onAppear {
                var preferences = Preferences()
                preferences.names = ["Hugo"]

                PreferencesStore.save(preferences: preferences) { result in
                    switch result {
                    case .failure(let error):
                        fatalError(error.localizedDescription)
                    case .success(_):
                        print("")
                    }
                }
            }
        
    }
}
