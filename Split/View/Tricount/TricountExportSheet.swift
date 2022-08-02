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
    
    var body: some View {
        
        NavigationView {
            VStack {
                HStack {
                    Image("tricount_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 200)
                        .brightness(colorScheme == .dark ? 0.2 : 0.0)
                }
                //.padding(.top, 40)
                .padding(.bottom, 20)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Select the payer of the receipt, then export to Tricount.")
                        .font(.title2)
                        .fontWeight(.medium)
                    Text("The export only works if all members who share the receipt are also listed on the provided Tricount under the exact same name.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 25)

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
                .padding(15)
                .background(Color.secondary.opacity(0.1))
                .cornerRadius(10)
                .padding(.horizontal)
                .padding(.top,5)
                
                TricountWebView(payerName: payer.name)
                    .padding(.horizontal, 35)
                    //.disabled(!model.users.contains(payer))
                
                Text("Split! is not affiliated in any way with Tricount.")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .opacity(0.8)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Done")
                    }
                }
            }
            //.navigationTitle("Tricount Export")
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct TricountExportSheet_Previews: PreviewProvider {
    static let model: ModelData = {
        var model = ModelData()
        model.images = [IdentifiedImage(id: "1111", image: UIImage(named: "scan1")), IdentifiedImage(id: "2222", image: UIImage(named: "scan2"))]
        model.users = [User(name: "Hugo"), User(name: "Lucas"), User(name: "Thomas")]
        model.listOfProductsAndPrices = [PairProductPrice(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBB", name: "Potato Wedges 1kg", price: 4.99), PairProductPrice(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBC", name: "Finger Fish 850g x12 from Aldi 2022", price: 1.27), PairProductPrice(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBD", name: "Ice Cream Strawberry", price: 3.20)]
        model.listOfProductsAndPrices[0].chosenBy = [model.users[0].id]
        model.listOfProductsAndPrices[1].chosenBy = [model.users[0].id, model.users[1].id]
        model.listOfProductsAndPrices[2].chosenBy = [model.users[0].id, model.users[1].id, model.users[2].id]
        model.receiptName = "ALDI SUISSE"
        
        var param = Parameters()
        var tricountTest1 = Tricount()
        tricountTest1.tricountID = "YYY"
        tricountTest1.tricountName = "This Is A Very Long Title For Testing"
        tricountTest1.names = ["Hugo", "Thomas", "Lucas", "Julie", "Mahaut", "Aurélien", "Corentin", "Octave"]
        var tricountTest2 = Tricount()
        tricountTest2.tricountID = "XXX"
        tricountTest2.tricountName = "Summer Vacations"
        tricountTest2.names = ["Hugo", "Thomas", "Julie", "Octave", ""]
        param.tricountList = [tricountTest1, tricountTest2]
        model.parameters = param

        return model
    }()
    
    static var previews: some View {
        TricountExportSheet()
            //.preferredColorScheme(.dark)
            .environmentObject(model)
    }
}
