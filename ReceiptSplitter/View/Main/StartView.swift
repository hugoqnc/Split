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
    
    @State private var finalUsers: [String] = []
    @State private var newUserName: String = ""
        
    var body: some View {
        
        if model.startTheProcess {
            //HomeView()
            ShowScannerView()
        } else {
            NavigationView {
                VStack{
                    Form {
                        Section {} header: {} //necessary to fix bug https://www.hackingwithswift.com/forums/swiftui/issues-with-list-section-headers-in-ios-15/9891
                        

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
                            
//                            HStack {
//                                Text("Number of people")
//                                Spacer()
//                                Picker("Number of people", selection: $numberOfUsers) {
//                                    ForEach(2 ... names.count, id:\.self) { number in
//                                        Text("\(number)")
//                                    }
//                                }
//                                .pickerStyle(.menu)
//                            }
//                            .listRowBackground(Color.secondary.opacity(0.1))
                        } header: {
                            Text("Parameters")
                        }
                        
                        Section {
                            ForEach(names, id:\.self) { name in
                                Text(name)
                            }
                            .onDelete { indices in
                                names.remove(atOffsets: indices)
                            }
                            .listRowBackground(Color.secondary.opacity(0.1))
                            
                            HStack {
                                TextField("New user", text: $newUserName)
                                Button(action: {
                                    checkAndAddName()
                                }) {
                                    Image(systemName: "plus.circle.fill")
                                }
                                .disabled(newUserName.isEmpty)
                            }
                            .listRowBackground(Color.secondary.opacity(0.1))
                        } header: {
                            Text("Names")
                        }
//                        Section {
//                            ForEach(1 ... numberOfUsers, id:\.self) { number in
//                                TextField("Name of user \(number)", text: $names[number-1])
//                                    .listRowBackground(Color.secondary.opacity(0.1))
//                            }
//                        } header: {
//                            Text("Names")
//                        }
                    }
                    
                    
                    Button {
                        var ok = true
                        finalUsers = names
                        if !newUserName.isEmpty {
                            ok = checkAndAddName()
                        }
                        if ok {
                            for name in finalUsers{
                                model.users.append(User(name: name))
                                print(model.users)
                            }
                            withAnimation() {
                                model.startTheProcess = true
                            }
                        }
                    } label: {
                        Label("Next", systemImage: "arrow.right")
                    }
                        .buttonStyle(.borderedProminent)
                        .padding(7)
                        .alert(isPresented: $showAlert1) {
                            Alert(title: Text("Missing information"), message: Text("Please fill in all usernames"), dismissButton: .default(Text("OK")))
                        }
                    
                    Spacer()
                        .alert(isPresented: $showAlert2) {
                            Alert(title: Text("Incorrect names"), message: Text("Users must have distinct names"), dismissButton: .default(Text("OK")))
                        }
                    
                }
                .navigationTitle("ReceiptSplitter")
                //.background(Color.accentColor.opacity(0.15), ignoresSafeAreaEdges: .bottom)
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
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
            .environmentObject(ModelData())
    }
}
