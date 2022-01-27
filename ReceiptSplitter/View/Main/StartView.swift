//
//  StartView.swift
//  ReceiptSplitter
//
//  Created by Hugo Queinnec on 04/01/2022.
//

import SwiftUI

struct StartView: View {
    @EnvironmentObject var model: ModelData
    @State private var names: [String] = []//(repeating: "", count: 10)
    @State private var currencyType = Currency.default.symbol
    @State private var showAlert1 = false
    @State private var showAlert2 = false
    
    @State private var newUserName: String = ""
        
    var body: some View {
        
        if model.startTheProcess {
            ShowScannerView()
        } else {
            NavigationView {
                VStack{
                    
                    PreferenceButton(names: $names, currencyType: $currencyType)
                        .padding(10)
                        .padding(.top,10)
                    
                    Form {
                        Section {
                            HStack {
                                Text("Currency")
                                Spacer()
                                Picker("Currency", selection: $currencyType) {
                                    ForEach(Currency.SymbolType.allCases, id: \.self, content: { currencyType in
                                        Text(Currency(symbol: currencyType).value)
                                    })
                                }
                                .pickerStyle(.menu)
                            }
                            .listRowBackground(Color.secondary.opacity(0.1))
                            
                        } header: {
                            //Text("Parameters")
                        }
                        
                        Section {
                            ForEach(names, id:\.self) { name in
                                Text(name)
                            }
                            .onDelete { indices in
                                withAnimation() {
                                    names.remove(atOffsets: indices)
                                }
                            }
                            .listRowBackground(Color.secondary.opacity(0.1))
                            
                            HStack {
                                TextField("New user", text: $newUserName)
                                Button(action: {
                                    let _ = checkAndAddName()
                                }) {
                                    Image(systemName: "plus.circle.fill")
                                }
                                .disabled(newUserName.isEmpty)
                            }
                            .listRowBackground(Color.secondary.opacity(0.1))
                        } header: {
                            HStack {
                                Text("Names")
                                    .alert(isPresented: $showAlert1) {
                                        Alert(title: Text("Missing information"), message: Text("Please fill in all usernames"), dismissButton: .default(Text("OK")))
                                    }
                                Text("")
                                    .alert(isPresented: $showAlert2) {
                                        Alert(title: Text("Incorrect names"), message: Text("Users must have distinct names"), dismissButton: .default(Text("OK")))
                                    }
                            }
                        }
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .bottomBar) {
                        Button {
                            let ok = isFinalUsersCorrect()
                            if ok {
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
                                Image(systemName: "arrow.right")
                                Text("Next")
                            }
                            //.frame(minWidth: 0, maxWidth: .infinity)
                        }
                        .disabled(names.isEmpty)
                        .padding()
                        .buttonStyle(.borderedProminent)
                    }
                }
                .navigationTitle("ReceiptSplitter")
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
    
    func checkAndAddName() -> Bool {
        let realName = newUserName.trimmingCharacters(in: .whitespaces)
        if !realName.isEmpty {
            if !names.contains(realName) {
                withAnimation() {
                    names.append(newUserName)
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
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
            .environmentObject(ModelData())
            .onAppear {
                UITableView.appearance().backgroundColor = .clear
            }
    }
}
