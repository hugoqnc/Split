//
//  StartView.swift
//  ReceiptSplitter
//
//  Created by Hugo Queinnec on 04/01/2022.
//

import SwiftUI

struct StartView: View {
    @EnvironmentObject var model: ModelData
    @State private var names = [String](repeating: "", count: 10)
    @State private var numberOfUsers = 2
    @State private var currencyType = Currency.default.symbol
    @State private var showAlert1 = false
    @State private var showAlert2 = false
    
    @State private var finalUsers: [String] = []
        
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
                            
                            HStack {
                                Text("Number of people")
                                Spacer()
                                Picker("Number of people", selection: $numberOfUsers) {
                                    ForEach(2 ... names.count, id:\.self) { number in
                                        Text("\(number)")
                                    }
                                }
                                .pickerStyle(.menu)
                            }
                        } header: {
                            Text("Parameters")
                        }

                        Section {
                            ForEach(1 ... numberOfUsers, id:\.self) { number in
                                TextField("Name of user \(number)", text: $names[number-1])
                            }
                        } header: {
                            Text("Names")
                        }
                    }
                    
                    
                    Button {
                        var isEmpty = false
                        finalUsers = Array(names[0..<numberOfUsers])
                        
                        for i in 0..<numberOfUsers {
                            finalUsers[i] = finalUsers[i].trimmingCharacters(in: .whitespaces)
                        }

                        for name in finalUsers {
                            if name == "" {
                                isEmpty = true
                            }
                        }
                        if isEmpty {
                            showAlert1 = true
                        } else if Set(finalUsers).count < finalUsers.count { // presence of duplicates
                            showAlert2 = true
                        } else {
                            for name in finalUsers{
                                model.users.append(User(name: name))
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
                    
                    Spacer()
                    
                }
                .navigationTitle("ReceiptSplitter")
                .background(Color.accentColor.opacity(0.15), ignoresSafeAreaEdges: .bottom)
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .alert("Please fill in all user names", isPresented: $showAlert1) {
                Button("OK") { }
            }
            .alert("Users must have distinct names", isPresented: $showAlert2) {
                Button("OK") { }
            }
        }
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
            .environmentObject(ModelData())
    }
}
