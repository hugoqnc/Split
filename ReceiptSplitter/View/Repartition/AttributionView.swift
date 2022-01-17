//
//  AttributionView.swift
//  ReceiptSplitter
//
//  Created by Hugo Queinnec on 05/01/2022.
//

import SwiftUI

struct AttributionView: View {
    @Binding var pair: PairProductPrice
    @Binding var isValidated: Bool
    var itemCounter: Int
    
    @EnvironmentObject var model: ModelData
    @State var selections: [UUID] = []
    @State private var showAlert1 = false
    @State private var isEditorMode = false
    @State private var showSafariView = false
    
    @State private var isNewItem = false
    @State private var isDeleteItem = false
    
    @State private var xOffset: CGFloat = 0.0
    @State private var yOffset: CGFloat = 0.0
    @State private var opacity = 1.0
    
    static let textOfNewItem = "Additional Product"
    private let colorDisabledButton = Color(red: 140 / 255, green: 140 / 255, blue: 140 / 255).opacity(0.2)
        
    var body: some View {
        VStack {
            VStack {
                                
                HStack {
                    VStack(alignment: .leading) {
                    
                        if pair.name==AttributionView.textOfNewItem {
                            Text(pair.name)
                                .font(.title2)
                                .italic()
                                .foregroundColor(.gray)
                        } else {
                            Text(pair.name)
                                .font(.title2)
                        }
                        if isEditorMode {
                            TextField(String(pair.price)+model.currency.value, value: $pair.price, format: .number)
                                .keyboardType(.decimalPad)
                                .textFieldStyle(.roundedBorder)
                                .frame(width: 120)
                                .font(.title)
                                .offset(x: 0, y: -13)
                                .foregroundColor(.blue)
                                
                        } else {
                            Text(String(pair.price)+model.currency.value)
                                .font(.title)
                                .fontWeight(.bold)
                                .padding(.bottom,25)
                                .offset(x: 0, y: 5)
                                .foregroundColor(pair.price==0 ? .red : nil)
                                
                        }
                    }
                    
                    Spacer()
                    
                    VStack {
                        
                        Text("\(itemCounter+1)/\(model.listOfProductsAndPrices.count)")
                            .font(.caption)
                            .fontWeight(.bold)
                            .padding(.trailing, 5)
                            .padding(.bottom, 10)
                            .padding(.top, -20)
                            .foregroundColor(.secondary)
                                                
                        Button(action: {
                            if !(pair.name==AttributionView.textOfNewItem){
                                showSafariView = true
                            }
                        }) {
                                Image(systemName: "photo.on.rectangle")
                                    .resizable(resizingMode: .tile)
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 30.0, height: 25.0)
                                    .foregroundColor(pair.name==AttributionView.textOfNewItem ? colorDisabledButton : .blue)
                        }
                        .padding(.trailing, 5)
                        
                    }
                }
                .fullScreenCover(isPresented: $showSafariView) {
                    let urlString = ("http://www.google.com/images?q="+pair.name).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                    SafariView(url: URL(string: urlString!)!).edgesIgnoringSafeArea(.all)}
                .padding(.top,5)
                
                Divider()
                
                SelectableItems(users: model.users, selections: $selections)
                    .padding(.top)
                    .padding(.bottom,25)
                
                Divider()
                
                HStack {
                    
                    Button {
                        isEditorMode.toggle()
                    } label: {
                        if isEditorMode {
                            Image(systemName: "checkmark.circle.fill")
                                .resizable(resizingMode: .tile)
                                .frame(width: 30.0, height: 30.0)
                                .foregroundColor(.blue)
                                .padding(.top)
                                .padding(.trailing,5)
                        } else {
                            Image(systemName: "pencil.circle.fill")
                                .resizable(resizingMode: .tile)
                                .frame(width: 30.0, height: 30.0)
                                .foregroundColor(.blue)
                                .padding(.top)
                                .padding(.trailing,5)
                        }
                    }
                    .onAppear {
                        if pair.name==AttributionView.textOfNewItem {
                            isEditorMode = true
                        }
                    }
                    
                    Button {
                        if !isEditorMode && !(pair.name==AttributionView.textOfNewItem) {
                            withAnimation(.easeInOut(duration: 4)) {
                                isNewItem = true
                            }
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .resizable(resizingMode: .tile)
                            .frame(width: 30.0, height: 30.0)
                            .foregroundColor(isEditorMode || (pair.name==AttributionView.textOfNewItem) ? colorDisabledButton : .yellow)
                            .padding(.top)
                            .padding(.trailing,5)
                    }
                    
                    Button {
                        if !isEditorMode {
                            withAnimation(.easeInOut(duration: 4)) {
                                isDeleteItem = true
                            }
        
                        }
                        
                    } label: {
                        Image(systemName: "trash.circle.fill")
                            .resizable(resizingMode: .tile)
                            .frame(width: 30.0, height: 30.0)
                            .foregroundColor(isEditorMode ? colorDisabledButton : .red)
                            .padding(.top)
                    }
                    
                    Spacer()
                    
                    Button {
                        if !isEditorMode {
                            
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
                            .foregroundColor(isEditorMode ? colorDisabledButton : .green)
                            .padding(.top,5)
                    }
                    
                }
            }
            .padding(20)
            .background(isDeleteItem ? Color.red : Color(red: 160 / 255, green: 160 / 255, blue: 160 / 255).opacity(0.1))
        }
        .cornerRadius(10)
        .overlay(RoundedRectangle(cornerRadius: 10)
                    .stroke(pair.price==0 ? .red : .gray, lineWidth: 1))
        .padding()
        .alert("Select the users who participate in this expense", isPresented: $showAlert1) {
            Button("OK") { }
        }
        .offset(x: xOffset, y: yOffset)
        .opacity(opacity)
//        .onChange(of: isNewItem) { newValue in
//                let newPair = PairProductPrice(id: UUID().uuidString, name: textOfNewItem, price: 0.0)
//                model.listOfProductsAndPrices.insert(newPair, at: itemCounter)
//        }
//        .onChange(of: isDeleteItem) { newValue in
//                if let index = model.listOfProductsAndPrices.firstIndex(where: {$0.id == pair.id}) {
//                    model.listOfProductsAndPrices.remove(at: index)
//                }
//        }
//        .transition(
//            pair.name==textOfNewItem && isNewItem ?
//            .asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing)) :
//            pair.name==textOfNewItem && isDeleteItem ?
//            .asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .bottom)) :
//            pair.name==textOfNewItem ?
//            .asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .leading)) :
//            isNewItem ?
//            .asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .trailing)) :
//            isDeleteItem ?
//            .asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .bottom)) :
//            .asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading))
//        )

        .onChange(of: isNewItem) { newValue in
            if newValue {
                withAnimation(.easeInOut(duration: 0.35)) {
                    xOffset = 300
                    opacity = 0.0
                }
                let secondsToDelay = 0.35
                DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
                    isNewItem = false
                }

            } else {
                let newPair = PairProductPrice(id: UUID().uuidString, name: AttributionView.textOfNewItem, price: 0.0)
                model.listOfProductsAndPrices.insert(newPair, at: itemCounter)
            }
        }
        .onChange(of: isDeleteItem) { newValue in
            if newValue {
                withAnimation(.easeInOut(duration: 0.35)) {
                    yOffset = 300
                    opacity = 0.0
                }
                let secondsToDelay = 0.35
                DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
                    isDeleteItem = false
                }

            } else {
                if let index = model.listOfProductsAndPrices.firstIndex(where: {$0.id == pair.id}) {
                    model.listOfProductsAndPrices.remove(at: index)
                }
            }
        }
        .transition(
            pair.name==AttributionView.textOfNewItem ?
                .asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .leading)) :
                    .asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
    }
    
}

struct AttributionView_Previews: PreviewProvider {
    static let model = ModelData()

    static var previews: some View {
        AttributionView(pair: .constant(PairProductPrice(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBB", name: "Potato Wedges 1kg", price: 4.99)), isValidated: .constant(false), itemCounter: 0)
            .environmentObject(model)
            .onAppear {
                model.users = [User(name: "Hugo"), User(name: "Lucas"), User(name: "Thomas")]
                model.listOfProductsAndPrices = [PairProductPrice(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBB", name: "Potato Wedges 1kg", price: 4.99), PairProductPrice(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBC", name: "Finger Fish", price: 1.27), PairProductPrice(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBD", name: "Ice Cream Strawberry", price: 3.20)]
            }
    }
}
