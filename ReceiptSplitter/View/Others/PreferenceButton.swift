//
//  PreferenceButton.swift
//  ReceiptSplitter
//
//  Created by Hugo Queinnec on 27/01/2022.
//

import SwiftUI

struct PreferenceButton: View {
    @Binding var names: [String]
    @Binding var currencyType: Currency.SymbolType
    
    @State private var savedNames: [String] = []
    @State private var savedCurrency = Currency.default
    
    @State private var saveWasClicked = false
    @State private var loadWasClicked = false
    
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
    
    var body: some View {
        VStack {
            if (!nothingSaved || !nothingWritten) && names != savedNames {//!(nothingSaved && names.isEmpty) {
                HStack {
                HStack {
                    if !nothingSaved {
                        Button {
                            if !loadWasClicked {
                                PreferencesStore.load { result in
                                    switch result {
                                    case .failure(let error):
                                        fatalError(error.localizedDescription)
                                    case .success(let preferences):
                                        withAnimation() {
                                            names = preferences.names
                                        }
                                        currencyType = preferences.currency.symbol
                                        
                                        withAnimation {
                                            loadWasClicked = true
                                        }
                                        let secondsToDelay = 1.0
                                        DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
                                            withAnimation() {
                                                loadWasClicked = false
                                            }
                                        }
                                    }
                                }
                            }
                        } label: {
                            Group {
                                if loadWasClicked {
                                    HStack {
                                        Image(systemName: "checkmark.circle.fill")
                                            .padding(.trailing, 1)
                                        VStack(alignment: .leading) {
                                            Text("Favorite preferences loaded!")
                                        }
                                    }
                                } else {
                                    HStack {
                                        Image(systemName: "star.fill")
                                            .padding(.trailing, 5)
                                        VStack(alignment: .leading) {
                                            Text("Load favorite preferences ")
                                            Text(descriptiveString)
                                                .font(.caption)
                                        }
                                    }
                                }
                            }
                            .transition(.asymmetric(insertion: .offset(x: 0, y: -60), removal: .offset(x: 0, y: 60)))
                        }
                        //.tint(.yellow)
                        
                        Divider()
                            .padding(.horizontal,3)
                    }
                    
                    Button {
                        if !saveWasClicked {
                            var preferences = Preferences()
                            preferences.names = names
                            preferences.currency = Currency(symbol: currencyType)
                            
                            PreferencesStore.save(preferences: preferences) { result in
                                switch result {
                                case .failure(let error):
                                    fatalError(error.localizedDescription)
                                case .success(_):
                                    withAnimation() {
                                        savedNames = names
                                    }
                                    savedCurrency = Currency(symbol: currencyType)
                                    
                                    withAnimation {
                                        saveWasClicked = true
                                    }
                                    let secondsToDelay = 1.0
                                    DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
                                        withAnimation() {
                                            saveWasClicked = false
                                        }
                                    }
                                }
                            }
                        }
                    } label: {
                        Group {
                            if saveWasClicked {
                                VStack {
                                    Image(systemName: "checkmark.circle.fill")
                                    Text("Saved!")
                                        .font(.caption)
                                }
                            } else {
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
                                        Text("Replace")
                                            .font(.caption)
                                    }
                                }
                            }
                        }
                        .transition(.asymmetric(insertion: .offset(x: 0, y: -60), removal: .offset(x: 0, y: 60)))
                    }
                    .tint(nothingWritten ? .red : .blue)
                    
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                //.scaledToFit()
                .frame(maxHeight: 55)
            }
            .background(Color(uiColor: UIColor.systemBackground).brightness(0.06))
            .cornerRadius(10)
            .shadow(color: .black.opacity(0.2), radius: 15.0)
            } else {
                EmptyView()
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
        PreferenceButton(names: .constant(["Hugo", "Thomas"]), currencyType: .constant(Currency.SymbolType.euro))
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
