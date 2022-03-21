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
    @State private var deleteConfirmation = false
    
    var body: some View {
        HStack {
            NavigationLink(isActive: $showFavoriteView) {
                VStack {
                    let formDetail = FormDetailsView(names: $savedNames, newUserName: $newUserName, currencyType: $savedCurrency.symbol, showAlert1: $showAlert1, showAlert2: $showAlert2)
                    Form {
                        HStack(alignment: .center) {
                            Image(systemName: "star")
                                .frame(width: 30, height: 30)
                                .font(.largeTitle)
                                .foregroundColor(.yellow)
                                .padding()

                            VStack(alignment: .leading, spacing: 2) {
                                Text("Choose your favorites")
                                    .font(.headline)
                                    .foregroundColor(.primary)

                                Text("You will be able to autofill these details in a single tap")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                        .listRowBackground(Color.secondary.opacity(0.0))
                        
                        formDetail
                        
                        Section {
                            Button {
                                deleteConfirmation = true
                            } label: {
                                Label("Delete saved favorites", systemImage: "trash")
                            }
                            .buttonStyle(.borderless)
                            .foregroundColor(.red)
                            .confirmationDialog(
                                "If you confirm, your favorites will be deleted.",
                                isPresented: $deleteConfirmation,
                                titleVisibility: .visible
                            ) {
                                Button("Delete saved favorites", role: .destructive) {
                                    withAnimation() {
                                        var preferences = Preferences()
                                        preferences.names = []
                                        preferences.currency = Currency.default
                                        
                                        PreferencesStore.save(preferences: preferences) { result in
                                            switch result {
                                            case .failure(let error):
                                                fatalError(error.localizedDescription)
                                            case .success(_):
                                                deleteConfirmation = false
                                                showFavoriteView = false
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        .listRowBackground(Color.secondary.opacity(0.1))
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
                                    Image(systemName: "checkmark")
                                    Text("Save favorites")
                                }
                            }
                            .disabled(savedNames.isEmpty)
                            .buttonStyle(.borderedProminent)
                            .tint(.accentColor)
                        }
                    }
                }
                .navigationTitle("Favorites")
                .navigationBarTitleDisplayMode(.inline)

            } label: {
                HStack {
                    Image(systemName: "ellipsis.circle")
                        .foregroundColor(.accentColor)
                        .padding(.trailing, 5)
                        .padding(.leading, 1)
                    Text(savedNames.isEmpty ? "Add favorites" : "Edit favorites")
                    Spacer()
                }
//                HStack {
//                    VStack {
//                        Label(savedNames.isEmpty ? "Add favorites" : "Edit favorites", systemImage: "ellipsis.circle")
//                    }
//                    Spacer()
//                }
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
