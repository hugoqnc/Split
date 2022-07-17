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
    
    @State private var showFavoriteView = false
    @State private var deleteConfirmation = false
    @Binding var backConfirmation: Bool
    
    @State private var tricountLink = ""
    
    var tricountID: String {
        get {
            let id = (tricountLink.components(separatedBy: "/").last ?? "").trimmingCharacters(in: .whitespaces)
            return id
        }
    }
    
    func savePreferences() {
        var preferences = Preferences()
        preferences.names = savedNames
        preferences.currency = savedCurrency
        preferences.tricountID = tricountID
        
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
    
    var body: some View {
        let formDetail = FormDetailsView(names: $savedNames, newUserName: $newUserName, currencyType: $savedCurrency.symbol, showAlert1: $showAlert1, showAlert2: $showAlert2)
        HStack {
            NavigationLink(isActive: $showFavoriteView) {
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
                            HStack {
                                Image(systemName: "plus.forwardslash.minus")
                                    .foregroundColor(Color.secondary.opacity(0.7))
                                    .padding(.leading, 2)
                                    .padding(.trailing, 3)
                                    .brightness(-0.4)
                                
                                TextField("Tricount Link/ID", text: $tricountLink)
                                
                                if !tricountLink.isEmpty {
                                    isValidLabel(isValid: numberOfCharactersForValidTricountID.contains(tricountID.count))
                                }
                            }
                            
                        } header: {
                            Text("Tricount Integration")
                        } footer: {
                            Text("Activate the integration with Tricount by pasting the share link (or ID) of your favorite Tricount. Make sure that all the members you enter here as favorites are listed on this Tricount with the same exact name.")
                        }
                        .listRowBackground(Color.secondary.opacity(0.1))
                        
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
                                    deleteConfirmation = false
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                                        withAnimation() {
                                            var preferences = Preferences()
                                            preferences.names = []
                                            preferences.currency = Currency.default
                                            preferences.tricountID = ""
                                            
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
                        .listRowBackground(Color.secondary.opacity(0.1))
                    }
                    .toolbar {
                        ToolbarItem(placement: .bottomBar) {
                            Button {
                                if formDetail.isFinalUsersCorrect() {
                                    savePreferences()
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
                .gesture(DragGesture(minimumDistance: 20, coordinateSpace: .global)
                            .onEnded { value in
                                let horizontalAmount = value.translation.width as CGFloat
                                let verticalAmount = value.translation.height as CGFloat
                                let xStart = value.startLocation.x
                                
                                if abs(horizontalAmount) > abs(verticalAmount) && xStart<20 {
                                    if horizontalAmount > 0 { //swipe from left to right
                                        PreferencesStore.load { result in
                                            switch result {
                                            case .failure(let error):
                                                fatalError(error.localizedDescription)
                                                //print("e")
                                            case .success(let preferences):
                                                if savedNames == preferences.names && savedCurrency.value == preferences.currency.value && tricountID == preferences.tricountID {
                                                    showFavoriteView = false
                                                } else {
                                                    backConfirmation = true
                                                }
                                                
                                            }
                                        }
                                    }
                                }
                })
                .navigationTitle("Favorites")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading: Button(action : {
                    PreferencesStore.load { result in
                        switch result {
                        case .failure(let error):
                            fatalError(error.localizedDescription)
                            //print("e")
                        case .success(let preferences):
                            if savedNames == preferences.names && savedCurrency.value == preferences.currency.value && tricountID == preferences.tricountID {
                                showFavoriteView = false
                            } else {
                                backConfirmation = true
                            }
                            
                        }
                    }
                }){
                    HStack(spacing:5) {
                        Image(systemName:"chevron.left")
                            .font(Font.body.weight(.semibold))
                        Text("Back").font(.body)
                    }
                    .padding(.leading, -7)
                    .confirmationDialog(
                        "You have made changes that you have not saved. Do you want to save them?",
                        isPresented: $backConfirmation,
                        titleVisibility: .visible
                    ) {
                        Button {
                            backConfirmation = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { //prevents confirmation dialog to pop up a second time
                                if formDetail.isFinalUsersCorrect() {
                                    savePreferences()
                                }
                            }
                        } label: {
                            Text("Save changes")
                        }

                        
                        Button(role: .destructive) {
                            backConfirmation = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                                showFavoriteView = false
                            }
                        } label: {
                            Text("Quit without saving")
                        }
                    }
                })

            } label: {
                HStack {
                    Image(systemName: "ellipsis.circle")
                        .foregroundColor(.accentColor)
                        .padding(.trailing, 5)
                        .padding(.leading, 1)
                    Text(savedNames.isEmpty ? "Add favorites" : "Edit favorites")
                    Spacer()
                }
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
                        tricountLink = preferences.tricountID
                    }
                }
            }
        }
    }
}

struct EditFavoriteButton_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EditFavoriteButton(backConfirmation: .constant(false))
        }
    }
}
