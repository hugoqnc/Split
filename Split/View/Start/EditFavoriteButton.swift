//
//  EditFavoriteButton.swift
//  Split
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
    
    @Binding public var showFavoriteView: Bool
    @State private var deleteConfirmation = false
    
    func savePreferences() {
        var preferences = Preferences()
        preferences.names = savedNames
        preferences.currency = savedCurrency
        
        PreferencesStore.save(preferences: preferences) { result in
            switch result {
            case .failure(let error):
                fatalError(error.localizedDescription)
            case .success(_):
                showFavoriteView = false
            }
        }
    }
    
    var body: some View {
        let formDetail = FormDetailsView(names: $savedNames, newUserName: $newUserName, currencyType: $savedCurrency.symbol, showAlert1: $showAlert1, showAlert2: $showAlert2)
        HStack {

            Button {
                showFavoriteView = true
            } label: {
                Image(systemName: "ellipsis.circle")
                    .foregroundColor(.accentColor)
                    .padding(.trailing, 5)
                    .padding(.leading, 1)
                Text(savedNames.isEmpty ? "Add favorites" : "Edit favorites")
                Spacer()
            }
            .buttonStyle(.plain)
            .onAppear {
                PreferencesStore.load { result in
                    switch result {
                    case .failure(let error):
                        fatalError(error.localizedDescription)
                        //print("e")
                    case .success(let preferences):
                        savedNames = preferences.names
                        savedCurrency = preferences.currency
                        newUserName = ""
                    }
                }
            }
            .onChange(of: showFavoriteView, perform: { newValue in
                PreferencesStore.load { result in
                    switch result {
                    case .failure(let error):
                        fatalError(error.localizedDescription)
                        //print("e")
                    case .success(let preferences):
                        savedNames = preferences.names
                        savedCurrency = preferences.currency
                        newUserName = ""
                    }
                }
            })
            .sheet(isPresented: $showFavoriteView) {
                NavigationView {
                    VStack {
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
                                if !savedNames.isEmpty {
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
                                            deleteConfirmation = false
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
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
                                }
                            }
                            
                        }
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button {
                                    showFavoriteView = false
                                } label: {
                                    Text("Cancel")
                                }
                                //.tint(.red)
                            }
                            
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button {
                                    if formDetail.isFinalUsersCorrect() {
                                        savePreferences()
                                    }
                                } label: {
                                    Text("Save")
                                        .bold()
                                }
                                .disabled(savedNames.isEmpty)
                            }
                        }
                    }
                    .navigationTitle("")
                    .navigationBarTitleDisplayMode(.inline)
                    .interactiveDismissDisabled()
                    .navigationViewStyle(StackNavigationViewStyle())
                }
            }
        }
    }
}

struct EditFavoriteButton_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EditFavoriteButton(showFavoriteView: .constant(true))
        }
    }
}
