//
//  EditFavoriteButton.swift
//  ReceiptSplitter
//
//  Created by Hugo Queinnec on 21/03/2022.
//

import SwiftUI

struct EditFavoriteButton: View {
    @State private var savedNames: [String] = []
    @State private var savedCurrency = Currency.default
    
    @State private var newUserName: String = ""
    @State private var showAlert1 = false
    @State private var showAlert2 = false
    
    @State private var showFavoriteView = false
    
    var nothingSaved: Bool {
        get {
            return savedNames.isEmpty
        }
    }
    
    var body: some View {
        HStack {
            NavigationLink(isActive: $showFavoriteView) {
                VStack {
                    let formDetail = FormDetailsView(names: $savedNames, newUserName: $newUserName, currencyType: $savedCurrency.symbol, showAlert1: $showAlert1, showAlert2: $showAlert2)
                    Form {
                        formDetail
                    }
                    .toolbar {
                        ToolbarItem(placement: .bottomBar) {
                            Button {
                                if formDetail.isFinalUsersCorrect() {
                                    var preferences = Preferences()
                                    preferences.names = savedNames
                                    preferences.currency = savedCurrency
                                    
                                    PreferencesStore.save(preferences: preferences) { result in
                                        switch result {
                                        case .failure(let error):
                                            fatalError(error.localizedDescription)
                                        case .success(_):
                                            //print("Favorites saved")
                                            showFavoriteView = false
                                        }
                                    }
                                }
                            } label: {
                                HStack {
                                    Image(systemName: "star.fill")
                                    Text("Save Favorites")
                                }
                            }
                            .disabled(savedNames.isEmpty)
                            .buttonStyle(.borderedProminent)
                            .tint(.orange)
                        }
                    }
                }
                .navigationTitle("Favorites")
                .navigationBarTitleDisplayMode(.inline)

            } label: {
                HStack {
                    VStack {
                        Label(nothingSaved ? "Add favorites" : "Edit favorites", systemImage: "ellipsis.circle")
                    }
                    Spacer()
                }
            }
            .buttonStyle(.plain)
            .onAppear {
                PreferencesStore.load { result in
                    switch result {
                    case .failure(let error):
                        fatalError(error.localizedDescription)
                    case .success(let preferences):
                        savedNames = preferences.names
                        savedCurrency = preferences.currency
                        newUserName = ""
                    }
                }
            }
        }
    }
}

struct EditFavoriteButton_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EditFavoriteButton()
        }
    }
}
