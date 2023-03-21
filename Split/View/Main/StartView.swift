//
//  StartView.swift
//  Split
//
//  Created by Hugo Queinnec on 04/01/2022.
//

import SwiftUI

struct StartView: View {
    @EnvironmentObject var model: ModelData
    @State private var names: [String] = []
    @State private var currencyType = Currency.default.symbol
    @State private var showAlert1 = false
    @State private var showAlert2 = false
    @State private var showAlert3 = false
    @State private var showSettings = false
    @State private var showHistoryView = false
    @State private var showFavoriteView = false
    @State private var disabledBecauseOfTiming = false
        
    @State private var newUserName: String = ""
        
    var body: some View {
        
        if model.startTheProcess {
            if model.photoFromLibrary {
                ShowLibraryView()
            } else {
                ShowScannerView()
            }
        } else {
            
            let formDetails = FormDetailsView(names: $names, newUserName: $newUserName, currencyType: $currencyType, showAlert1: $showAlert1, showAlert2: $showAlert2)
            
            NavigationView {
                VStack{
                    NavigationLink(destination: HistoryView(showHistoryView: $showHistoryView), isActive: $showHistoryView) { EmptyView() }
                        .isDetailLink(false)
                        .navigationViewStyle(.stack)
                    
                    Form {
                        Section {
                            EmptyView()
                            //to fix this bug: https://www.hackingwithswift.com/forums/swiftui/issues-with-list-section-headers-in-ios-15/9891
                        }
                        
                        Section {
                            FillFavoriteButton(names: $names, newUserName: $newUserName, currencyType: $currencyType, update: $showFavoriteView)
                            EditFavoriteButton(showFavoriteView: $showFavoriteView)
                        } header: {
                            //Text("Favorites")
                        }
                        
                        
                        formDetails
                        
                    }
                }
                .toolbar {
                    ToolbarItemGroup(placement: .bottomBar) {
                        Spacer()
                        
                        Group {
                            Button {
                                let ok = formDetails.isFinalUsersCorrect()
                                if ok {
                                    ParametersStore.load { result in
                                        switch result {
                                        case .failure(let error):
                                            fatalError(error.localizedDescription)
                                        case .success(let parameters):
                                            model.parameters = parameters
                                        }
                                    }
                                    for name in names{
                                        model.users.append(User(name: name))
                                    }
                                    model.currency = Currency(symbol: currencyType)
                                    withAnimation() {
                                        model.photoFromLibrary = true
                                        model.startTheProcess = true
                                    }
                                }
                            } label: {
                                HStack {
                                    Image(systemName: "photo.stack")
                                    Text("Load")
                                }
                            }
                            
                            Button {
                                let ok = formDetails.isFinalUsersCorrect()
                                if ok {
                                    ParametersStore.load { result in
                                        switch result {
                                        case .failure(let error):
                                            fatalError(error.localizedDescription)
                                        case .success(let parameters):
                                            model.parameters = parameters
                                        }
                                    }
                                    for name in names{
                                        model.users.append(User(name: name))
                                    }
                                    model.currency = Currency(symbol: currencyType)
                                    withAnimation() {
                                        model.startTheProcess = true
                                    }
                                }
                            } label: {
                                HStack {
                                    Image(systemName: "viewfinder")
                                    Text("Scan")
                                }
                            }
                        }
                        .padding(.horizontal, 10)
                        .disabled(names.isEmpty || disabledBecauseOfTiming)
                        .onTapGesture {
                            if names.isEmpty {
                                showAlert3 = true
                            }
                        }
                        .alert(isPresented: $showAlert3) {
                            Alert(title: Text("No users"), message: Text("Please add the name of at least one user to start"), dismissButton: .default(Text("OK")))
                        }
                        .buttonStyle(.borderedProminent)
                        .onChange(of: model.startTheProcess) { newValue in
                            if !newValue {
                                disabledBecauseOfTiming = true //disables the "next" button for a short moment when "startTheProcess" has changed, but the rest of the model may not have been cleaned yet
                                let secondsToDelay = 0.4
                                DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
                                    disabledBecauseOfTiming = false
                                }
                            }
                        }
                        
                        Spacer()
                    }
                    
                    ToolbarItemGroup(placement: .navigationBarTrailing){
                        Button {
                            ParametersStore.load { result in
                                switch result {
                                case .failure(let error):
                                    fatalError(error.localizedDescription)
                                case .success(let parameters):
                                    model.parameters = parameters
                                }
                            }
                            withAnimation() {
                                showHistoryView = true
                            }
                        } label: {
                            Image(systemName: "clock.arrow.circlepath")
                                .frame(height: 96, alignment: .trailing) // because of https://stackoverflow.com/questions/58512344/swiftui-navigation-bar-button-not-clickable-after-sheet-has-been-presented
                        }
                        
                        Button {
                            showSettings = true
                        } label: {
                            Image(systemName: "gear")
                                .frame(height: 96, alignment: .trailing)
                        }
                        .padding(.trailing,10)
                        .sheet(isPresented: $showSettings) {
                            SettingsView()
                        }
                    }
                }
                .navigationTitle("Split!")
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
            .environmentObject(ModelData())
    }
}
