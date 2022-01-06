//
//  AttributionView.swift
//  ReceiptSplitter
//
//  Created by Hugo Queinnec on 05/01/2022.
//

import SwiftUI

struct AttributionView: View {
    @Binding var pair: PairProductPrice
    @EnvironmentObject var model: ModelData
    @State var selections: [UUID] = []
    @Binding var isValidated: Bool
    @State private var showAlert1 = false
    @State private var isEditorMode = false
    
    var body: some View {
        VStack {
            VStack {
                
                HStack {
                    VStack(alignment: .leading) {
                        Text(pair.name)
                            .font(.title2)
                        if isEditorMode {
                            TextField(String(pair.price)+"€", value: $pair.price, format: .number)
                                .keyboardType(.decimalPad)
                                .textFieldStyle(.roundedBorder)
                                .frame(width: 120)
                                .font(.title)
                                .offset(x: 0, y: -13)
                                .foregroundColor(.blue)
                                
                        } else {
                            Text(String(pair.price)+"€")
                                .font(.title)
                                .fontWeight(.bold)
                                .padding(.bottom,25)
                                .offset(x: 0, y: 5)
                                
                        }
                    }
                    
                    Spacer()
                }
                
                
                SelectableItems(users: model.users, selections: $selections)
        
                
                HStack {
                    
                    Button {
                        isEditorMode.toggle()
                    } label: {
                        Image(systemName: "pencil.circle.fill")
                            .resizable(resizingMode: .tile)
                            .frame(width: 30.0, height: 30.0)
                            .foregroundColor(.blue)
                            .padding(.top)
                            .padding(.trailing,5)
                    }
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .resizable(resizingMode: .tile)
                            .frame(width: 30.0, height: 30.0)
                            .foregroundColor(isEditorMode ? .gray : .yellow)
                            .padding(.top)
                            .padding(.trailing,5)
                    }
                    
                    Button {
                        if !isEditorMode {
                            if let index = model.listOfProductsAndPrices.firstIndex(where: {$0.id == pair.id}) {
                                model.listOfProductsAndPrices.remove(at: index)
                            }
                        }
                        
                    } label: {
                        Image(systemName: "trash.circle.fill")
                            .resizable(resizingMode: .tile)
                            .frame(width: 30.0, height: 30.0)
                            .foregroundColor(isEditorMode ? .gray : .red)
                            .padding(.top)
                    }
                    
                    Spacer()
                    
                    Button {
                        if !isEditorMode {
                            print("BBB")
                            print(pair)
                            print("BBBB")
                            let divider = selections.count
                            if divider==0 {
                                showAlert1 = true
                            } else {
                                for id in selections{
                                    for user in model.users {
                                        if user.id==id {
                                            let index = model.users.firstIndex{$0.id == id}!
                                            //print(model.users[index].name)
                                            //print(model.users[index].balance)
                                            model.users[index].balance+=pair.price/Double(divider)
                                            //print(model.users[index].balance)
                                        }
                                    }
                                }
                                selections = []
                                isValidated = true
                            }
                        }
                    } label: {
                        Image(systemName: "checkmark.circle.fill")
                            .resizable(resizingMode: .tile)
                            .frame(width: 40.0, height: 40.0)
                            .foregroundColor(isEditorMode ? .gray : .green)
                            .padding(.top,5)
                    }
                    
                }
            }
            .padding()
        }
        .cornerRadius(10)
        .overlay(RoundedRectangle(cornerRadius: 10)
                    .stroke(.gray, lineWidth: 1))
        .padding()
        .alert("Select the users who participate in this expense", isPresented: $showAlert1) {
            Button("OK") { }
        }
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
    static let model = ModelData()

    static var previews: some View {
        AttributionView(pair: .constant(PairProductPrice(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBB", name: "Potato Wedges 1kg", price: 4.99)), isValidated: .constant(false))
            .environmentObject(model)
            .onAppear {
                model.users = [User(name: "Hugo"), User(name: "Lucas"), User(name: "Thomas")]
                model.listOfProductsAndPrices = [PairProductPrice(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBB", name: "Potato Wedges 1kg", price: 4.99), PairProductPrice(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBC", name: "Finger Fish", price: 1.27), PairProductPrice(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBD", name: "Ice Cream Strawberry", price: 3.20)]
            }
    }
}
