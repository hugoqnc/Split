//
//  AttributionView.swift
//  ReceiptSplitter
//
//  Created by Hugo Queinnec on 05/01/2022.
//

import SwiftUI

struct AttributionView: View {
    var pair: PairProductPrice
    @EnvironmentObject var model: ModelData
    @State var selections: [UUID] = []
//    @ObservedObject var input = NumbersOnly()
    
    var body: some View {
        VStack {
            
            VStack {
                Text(pair.name)
                    .font(.title2)
                Text(String(pair.price)+"€")
                    .font(.title)
            }
            .padding(.top)
            
//            TextField(String(pair.price)+"€", text: $input.value)
//                .padding()
//                .keyboardType(.decimalPad)
//                .textFieldStyle(.roundedBorder)
//                .frame(width: 120)
//                .scaleEffect(1.5)
            
            SelectableItems(users: model.users, selections: $selections)
                .padding()
            
            Button {
                let divider = selections.count
                for id in selections{
                    for user in model.users {
                        if user.id==id {
                            let index = model.users.firstIndex{$0.id == id}!
                            model.users[index].balance+=pair.price/Double(divider)
                        }
                    }
                }
            } label: {
                Image(systemName: "checkmark.circle.fill")
                    .resizable(resizingMode: .tile)
                    .frame(width: 40.0, height: 40.0)
                    .foregroundColor(.green)
                    .padding(.bottom)
            }
        }
        .cornerRadius(10)
        .overlay(RoundedRectangle(cornerRadius: 10)
                    .stroke(.gray, lineWidth: 1)
                )
        .padding()
    }
}

//class NumbersOnly: ObservableObject {
//    @Published var value = "" {
//        didSet {
//            let filtered = value.filter { $0.isNumber }
//
//            if value != filtered {
//                value = filtered
//            }
//        }
//    }
//}

struct AttributionView_Previews: PreviewProvider {    
    static var previews: some View {
        AttributionView(pair: PairProductPrice(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBB", name: "Potato Wedges 1kg", price: 4.99))
            .environmentObject(ModelData())
    }
}
