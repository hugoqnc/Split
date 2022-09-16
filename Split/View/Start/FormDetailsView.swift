//
//  FormDetailsView.swift
//  Split
//
//  Created by Hugo Queinnec on 21/03/2022.
//

import SwiftUI

struct FormDetailsView: View {
    
    @Binding var names: [String]
    @Binding var newUserName: String
    @Binding var currencyType: Currency.SymbolType
    @Binding var showAlert1: Bool
    @Binding var showAlert2: Bool
    
    @State var showInfo = false
    
    var body: some View {
        Section {
            
            Menu {
                Picker("Currency", selection: $currencyType.animation()) {
                    ForEach(Currency.SymbolType.allCases, id: \.self, content: { currencyType in
                        Text(Currency(symbol: currencyType).value)
                    })
                }
            } label: {
                HStack {
                    Image(systemName: "creditcard")
                        .foregroundColor(Color.purple)
                        .padding(.trailing, 1)
                    Text("Currency")
                        .foregroundColor(.primary)
                    Spacer()
                    Text("\(Currency(symbol: currencyType).value)")
                        .fontWeight(.semibold)
                        .padding(.trailing, 5)
                }
                
            }
            .onAppear {
                ParametersStore.load { result in
                    switch result {
                    case .failure(let error):
                        fatalError(error.localizedDescription)
                    case .success(let parameters):
                        if names.isEmpty && newUserName.isEmpty {
                            currencyType = parameters.defaultCurrency.symbol
                        }
                    }
                }
            }
            
            ForEach(names, id:\.self) { name in
                HStack {
                    Image(systemName: "person")
                        .foregroundColor(Color.secondary.opacity(0.7))
                        .padding(.leading, 2)
                        .padding(.trailing, 3)
                    Text(name)
                }
            }
            .onDelete { indices in
                withAnimation() {
                    names.remove(atOffsets: indices)
                }
            }
            
            HStack {
                Image(systemName: "person")
                    .foregroundColor(Color.secondary.opacity(0.7))
                    .padding(.leading, 2)
                    .padding(.trailing, 3)
                TextField("New user", text: $newUserName.animation())
                Button(action: {
                    let _ = checkAndAddName()
                }) {
                    Image(systemName: "plus.circle.fill")
                }
                .disabled(newUserName.isEmpty)
            }
        } header: {
            HStack {
                Text("Details")
                    .alert(isPresented: $showAlert1) {
                        Alert(title: Text("Missing information"), message: Text("Please fill in all usernames"), dismissButton: .default(Text("OK")))
                    }
                Text("")
                    .alert(isPresented: $showAlert2) {
                        Alert(title: Text("Incorrect names"), message: Text("Users must have distinct names"), dismissButton: .default(Text("OK")))
                    }
            }
        } footer: {
            //Label("To delete a name, swipe from right to left. To edit a name, delete it and add it again.", systemImage: "info.circle")
        }
        
    }
    
    func checkAndAddName() -> Bool {
        let realName = newUserName.trimmingCharacters(in: .whitespaces)
        if !realName.isEmpty {
            if !names.contains(realName) {
                withAnimation() {
                    names.append(realName)
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

struct FormDetailsView_Previews: PreviewProvider {
    
    static var previews: some View {
        List {
            let v = FormDetailsView(names: .constant(["Hugo", "Thomas"]), newUserName: .constant("Lucas"), currencyType: .constant(Currency.SymbolType.euro), showAlert1: .constant(false), showAlert2: .constant(false))
            v
        }
    }
}
