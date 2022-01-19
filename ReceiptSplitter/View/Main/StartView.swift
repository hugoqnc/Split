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
        
    var body: some View {
        
        if model.startTheProcess {
            HomeView()
        } else {
            NavigationView {
                VStack{
                    Form {
                        
                        Section(header: Text("Currency")) {
                            Picker("Currency", selection: $currencyType) {
                                ForEach(Currency.SymbolType.allCases, id: \.self, content: { currencyType in
                                    Text(Currency(symbol: currencyType).value)
                                })
                            }
                            .pickerStyle(.segmented)
                            .padding(8)
                        }
                        
                        
                        Section(header: Text("Names")) {
                            Picker("Number of people", selection: $numberOfUsers) {
                                ForEach(2 ... names.count, id:\.self) { number in
                                    Text("\(number)")
                                }
                            }
                            
                            ForEach(1 ... numberOfUsers, id:\.self) { number in
                                TextField("Name of user \(number)", text: $names[number-1])
                            }
                        }

                    }
                    
                    Button {
                        var isEmpty = false
                        let finalUsers: [String] = Array(names[0..<numberOfUsers])
                        
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
                            model.currency = Currency(symbol: currencyType)
                            model.startTheProcess = true
                        }
                    } label: {
                        Label("Scan", systemImage: "doc.text.viewfinder")
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(7)
                    
                    Spacer()
                    
                }
                .navigationTitle("ReceiptSplitter")
                .background(Color(red: 0 / 255, green: 130 / 255, blue: 255 / 255).opacity(0.15), ignoresSafeAreaEdges: .bottom)
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
