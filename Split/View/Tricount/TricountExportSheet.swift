//
//  TricountExportSheet.swift
//  Split
//
//  Created by Hugo Queinnec on 27/04/2022.
//

import SwiftUI

struct TricountExportSheet: View {

    @EnvironmentObject var model: ModelData
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @State var payer = User()
    @State var chosenTricount = Tricount()
    @State var inProgress = false
    @State var exportStatus = ""
    @State var showTricountDisclaimer = false
    
    var body: some View {
        
        NavigationView {
            VStack {

                HStack(alignment: .center) {
                    Image(systemName: "plus.forwardslash.minus")
                        .frame(width: 30, height: 30)
                        .font(.largeTitle)
                        .foregroundColor(.primary)
                        .padding()

                    VStack(alignment: .leading, spacing: 2) {
                        Text("Export to Tricount")
                            .font(.headline)
                            .foregroundColor(.primary)

                        Text("Select your Tricount and the payer of the receipt")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .padding(.top)
                .padding(.horizontal, 40)
                .padding(.bottom)
                
                // Error message
                Group {
                    Group {
                        if exportStatus == "UNKNOWN_FAILURE" {
                            InfoBlock(color: .red, icon: "xmark.octagon", title: "Export failure", subtitle: "Please try again later")
                        } else if exportStatus == "NETWORK_FAILURE" {
                            InfoBlock(color: .red, icon: "wifi.slash", title: "Connection failure", subtitle: "Please verify your internet connection and start again")
                        }
                    }
                    .transition(.scale)
                }
                .padding(.horizontal, 40)
                .padding(.top)
                .padding(.bottom)


                Group {
                    Menu {
                        Picker("Tricount", selection: $chosenTricount.animation()) {
                            ForEach(compatibleTricounts(users: model.users, tricountList: model.parameters.tricountList), id: \.self, content: { tricount in
                                    Text(tricount.tricountName)
                            })
                        }
                    } label: {
                        HStack {
                            Image(systemName: "plus.forwardslash.minus")
                                .foregroundColor(Color.accentColor)
                                .padding(.trailing, 2)
                            Text("Tricount")
                                .foregroundColor(.primary)
                            Spacer()
                            Text("\(chosenTricount.tricountName)")
                                .fontWeight(.semibold)
                                .padding(.trailing, 5)
                                .lineLimit(1)
                        }
                    }
                    .onAppear {
                        let exactTricounts = exactTricounts(users: model.users, tricountList: model.parameters.tricountList)
                        let compatibleTricounts = compatibleTricounts(users: model.users, tricountList: model.parameters.tricountList)
                        
                        if !exactTricounts.isEmpty {
                            chosenTricount = exactTricounts.first!
                        } else if compatibleTricounts.count == 1 {
                            chosenTricount = compatibleTricounts.first!
                        }
                    }
                    
                    Menu {
                        Picker("Payer", selection: $payer.animation()) {
                            ForEach(model.users, id: \.self, content: { user in
                                Text(user.name)
                            })
                        }
                    } label: {
                        HStack {
                            Image(systemName: "person")
                                .foregroundColor(Color.accentColor)
                                .padding(.trailing, 2)
                            Text("Payer of the receipt")
                                .foregroundColor(.primary)
                            Spacer()
                            Text("\(payer.name)")
                                .fontWeight(.semibold)
                                .padding(.trailing, 5)
                                .lineLimit(1)
                        }
                        
                    }

                }
                .disabled(inProgress)
                .padding(15)
                .background(Color.secondary.opacity(0.1))
                .cornerRadius(10)
                .padding(.horizontal)
                .padding(.top,5)
                
                Spacer()
                
                VStack(spacing: 3) {
                    Text("Split! is not affiliated in any way with Tricount.")
                        .foregroundColor(.secondary)
                        .font(.caption)
                        //.opacity(0.8)
                    Button {
                        showTricountDisclaimer = true
                    } label: {
                        Text("See more...")
                            .font(.caption)
                    }
                    .sheet(isPresented: $showTricountDisclaimer) {
                        TricountDisclaimerSheet()
                    }
                }
                .padding(.bottom, 10)
            }
            .animation(.easeInOut, value: exportStatus)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                    }
                    //.tint(.red)
                    .disabled(inProgress)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    if inProgress {
                        ProgressView()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        Task {
                            inProgress = true
                            exportStatus = "" //reset in case of previous errors
                            let roundedListOfAmounts = roundListOfAmounts(listOfAmounts: model.users.map({ user in model.balance(ofUser: user) }))

                            do {
                                let res = try await addToTricount(tricountID: chosenTricount.tricountID, shopName: model.receiptName, payerName: payer.name, listOfNames: model.users.map({ user in user.name }), listOfAmounts: roundedListOfAmounts)
                                print(res)
                                exportStatus = res
                            } catch {}
                            
                            inProgress = false
                            
                            if exportStatus == "SUCCESS" {
                                dismiss()
                            }
                            
                        }
                        

                    } label: {
                        Text("Export")
                            .bold()
                    }
                    .disabled(!(model.users.contains(payer) && compatibleTricounts(users: model.users, tricountList: model.parameters.tricountList).contains(chosenTricount)) || inProgress)
                }
            }
            //.navigationTitle("Tricount Export")
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .interactiveDismissDisabled(inProgress)
    }
    
    func roundListOfAmounts(listOfAmounts: [Double]) -> [Double] {
        let total = round(listOfAmounts.reduce(0, +) * 100) / 100.0
        
        var roundedListOfAmounts: [Double] = []
        for (index, amount) in listOfAmounts.enumerated() {
            if index == listOfAmounts.count - 1 {
                roundedListOfAmounts.append(total - roundedListOfAmounts.reduce(0, +))
            } else {
                roundedListOfAmounts.append(round(amount * 100) / 100.0)
            }
        }
        
        return roundedListOfAmounts
    }

}

struct TricountExportSheet_Previews: PreviewProvider {
    static let model: ModelData = {
        var model = ModelData()
        model.images = [IdentifiedImage(id: "1111", image: UIImage(named: "scan1")), IdentifiedImage(id: "2222", image: UIImage(named: "scan2"))]
        model.users = [User(name: "Hugo"), User(name: "Lucas"), User(name: "Hortense")]
        model.listOfProductsAndPrices = [PairProductPrice(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBB", name: "Potato Wedges 1kg", price: 4.99), PairProductPrice(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBC", name: "Finger Fish 850g x12 from Aldi 2022", price: 1.27), PairProductPrice(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBD", name: "Ice Cream Strawberry", price: 3.20)]
        model.listOfProductsAndPrices[0].chosenBy = [model.users[0].id]
        model.listOfProductsAndPrices[1].chosenBy = [model.users[0].id, model.users[1].id]
        model.listOfProductsAndPrices[2].chosenBy = [model.users[0].id, model.users[1].id, model.users[2].id]
        model.receiptName = "ALDI SUISSE"
        
        var param = Parameters()
        var tricountTest1 = Tricount()
        tricountTest1.tricountID = "YYY"
        tricountTest1.tricountName = "This Is A Very Long Title For Testing"
        tricountTest1.names = ["Hugo", "Thomas", "Lucas", "Julie", "Mahaut", "Aurélien", "Corentin", "Hortense"]
        var tricountTest2 = Tricount()
        tricountTest2.tricountID = "XXX"
        tricountTest2.tricountName = "Summer Vacations"
        tricountTest2.names = ["Hugo", "Thomas", "Lucas"]
        var tricountTest3 = Tricount()
        tricountTest2.tricountID = "aqFUjtBCMGOyLQhZjq"
        tricountTest2.tricountName = "Test API"
        tricountTest2.names = ["Hugo", "Hortense", "Lucas"]
        param.tricountList = [tricountTest1, tricountTest2, tricountTest3]
        model.parameters = param

        return model
    }()
    
    static var previews: some View {
        TricountExportSheet()
            //.preferredColorScheme(.dark)
            .environmentObject(model)
    }
}
