//
//  AttributionView.swift
//  ReceiptSplitter
//
//  Created by Hugo Queinnec on 05/01/2022.
//

import SwiftUI

struct AttributionView: View {
    internal init(pair: Binding<PairProductPrice>, isValidated: Binding<Bool>, itemCounter: Int) {
        self._pair = pair
        self._isValidated = isValidated
        self.itemCounter = itemCounter
        self.isEditorMode = pair.isNewItem.wrappedValue //edit mode activated for new products
    }
    
    @Binding var pair: PairProductPrice
    @Binding var isValidated: Bool
    var itemCounter: Int
    
    @EnvironmentObject var model: ModelData
    @State var selections: [UUID] = []
    @State private var showAlert1 = false
    @State private var isEditorMode: Bool
    @State private var showSafariView = false
    
    @State private var createsNewItemCall = false
    @State private var deletesItemCall = false
    
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
                    
                        if pair.isNewItem {
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
                            if !(pair.isNewItem){
                                showSafariView = true
                            }
                        }) {
                                Image(systemName: "photo.on.rectangle")
                                    .resizable(resizingMode: .tile)
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 30.0, height: 25.0)
                                    .foregroundColor(pair.isNewItem ? colorDisabledButton : .blue)
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
                    
                    Button {
                        if !isEditorMode && !pair.isNewItem {
                            withAnimation(.easeInOut(duration: 4)) {
                                createsNewItemCall = true
                            }
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .resizable(resizingMode: .tile)
                            .frame(width: 30.0, height: 30.0)
                            .foregroundColor(isEditorMode || pair.isNewItem ? colorDisabledButton : .yellow)
                            .padding(.top)
                            .padding(.trailing,5)
                    }
                    
                    Button {
                        if !isEditorMode {
                            withAnimation(.easeInOut(duration: 4)) {
                                deletesItemCall = true
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
        }
        .background(Color(uiColor: UIColor.systemBackground).brightness(0.06))
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.2), radius: 15.0)
        
        .padding()
        .alert("Select the users who participate in this expense", isPresented: $showAlert1) {
            Button("OK") { }
        }
        .offset(x: xOffset, y: yOffset)
        .opacity(opacity)
        .onChange(of: createsNewItemCall) { newValue in
            if newValue {
                withAnimation(.easeInOut(duration: 0.35)) {
                    xOffset = 300
                    opacity = 0.0
                }
                let secondsToDelay = 0.35
                DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
                    createsNewItemCall = false
                }

            } else {
                var newPair = PairProductPrice(id: UUID().uuidString, name: AttributionView.textOfNewItem, price: 0.0)
                newPair.isNewItem = true
                model.listOfProductsAndPrices.insert(newPair, at: itemCounter)
            }
        }
        .onChange(of: deletesItemCall) { newValue in
            if newValue {
                withAnimation(.easeInOut(duration: 0.35)) {
                    yOffset = 300
                    opacity = 0.0
                }
                let secondsToDelay = 0.35
                DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
                    deletesItemCall = false
                }

            } else {
                if let index = model.listOfProductsAndPrices.firstIndex(where: {$0.id == pair.id}) {
                    model.listOfProductsAndPrices.remove(at: index)
                }
            }
        }
        .transition(
            pair.isNewItem ?
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
