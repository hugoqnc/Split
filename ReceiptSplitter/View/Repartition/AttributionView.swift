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
    
    
    private let textOfNewItem = "Additional Product"
        
    var body: some View {
        VStack {
            VStack {
                                
                HStack {
                    VStack(alignment: .leading) {
                    
                        if pair.name==textOfNewItem {
                            Text(pair.name)
                                .font(.title2)
                                .italic()
                                .foregroundColor(.gray)
                        } else {
                            Text(pair.name)
                                .font(.title2)
                        }
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
                                showSafariView = true
                        }) {
                                Image(systemName: "photo.on.rectangle")
                                    .resizable(resizingMode: .tile)
                                    .frame(width: 30.0, height: 25.0)
                                    .foregroundColor(.blue)
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
                        Image(systemName: "pencil.circle.fill")
                            .resizable(resizingMode: .tile)
                            .frame(width: 30.0, height: 30.0)
                            .foregroundColor(.blue)
                            .padding(.top)
                            .padding(.trailing,5)
                    }
                    
                    Button {
                        if !isEditorMode {
                            withAnimation(.easeInOut(duration: 4)) {
                                isNewItem = true
                            }
                        }
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
                            withAnimation(.easeInOut(duration: 4)) {
                                isDeleteItem = true
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
            .padding(20)
            .background(Color(red: 160 / 255, green: 160 / 255, blue: 160 / 255).opacity(0.1))
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
                xOffset = 0
                yOffset = 300
                let newPair = PairProductPrice(id: UUID().uuidString, name: textOfNewItem, price: 0.0)
                model.listOfProductsAndPrices.insert(newPair, at: itemCounter)
                
                withAnimation() {
                    yOffset = 0
                    opacity = 1.0
                }
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
                yOffset = 0
                xOffset = 300
                if let index = model.listOfProductsAndPrices.firstIndex(where: {$0.id == pair.id}) {
                    model.listOfProductsAndPrices.remove(at: index)
                }
                
                withAnimation() {
                    xOffset = 0
                    opacity = 1.0
                }
            }
        }

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
