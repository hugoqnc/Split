//
//  TricountExportSheet.swift
//  Split
//
//  Created by Hugo Queinnec on 27/04/2022.
//

import SwiftUI

struct TricountExportSheet: View {

    @EnvironmentObject var model: ModelData
    @State var payer = User()
    
    var body: some View {
        
        VStack {
            HStack {
                Image("tricount_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 200)
            }
            .padding(.top, 40)
            .padding(.bottom, 20)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Select the payer of the receipt, then export to Tricount.")
                    .font(.title2)
                    .fontWeight(.semibold)
                Text("Note: the export only works if all members who share the receipt are also listed on the provided Tricount with the exact same name.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 25)

            
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
                }
                
            }
            .padding(15)
            .background(Color.secondary.opacity(0.1))
            .cornerRadius(10)
            .padding()
            
            TricountWebView(payerName: "Hugo")
                .padding(.horizontal, 35)
                .disabled(!model.users.contains(payer))
            
            Text("Split! is not affiliated in any way with Tricount.")
                .font(.caption2)
                .foregroundColor(.secondary)
                .opacity(0.8)
        }
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
        return model
    }()
    
    static var previews: some View {
        TricountExportSheet()
            .environmentObject(model)
    }
}
