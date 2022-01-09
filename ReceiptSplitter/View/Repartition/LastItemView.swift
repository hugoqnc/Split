//
//  LastItemView.swift
//  ReceiptSplitter
//
//  Created by Hugo Queinnec on 09/01/2022.
//

import SwiftUI

struct LastItemView: View {
    @Binding var showResult: Bool
    @EnvironmentObject var model: ModelData
    
    @State private var xOffset: CGFloat = 0.0
    @State private var yOffset: CGFloat = 0.0
    @State private var opacity = 1.0

    @State private var isNewItem = false
    
    //@State private var debug = "nothing"

    
    var body: some View {
        VStack {
            VStack {
                VStack {
                    //Text(debug)
                    
                    Image(systemName: "cart")
                        .resizable(resizingMode: .tile)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 45, height: 45)
                        .foregroundColor(.orange)
                        .padding(.top,5)
                        .padding(.bottom,15)
                    
                                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Any additional item to add?")
                                .font(.title2)
                        }
                        
                        Spacer()
                        
                        }
                        
                    }
                    .padding(.top,5)
                    .padding(.leading,3)
                    
                    Divider()
                    
                    VStack {
                        
                        HStack {
                            Button {
                                withAnimation(.easeInOut(duration: 4)) {
                                    isNewItem = true
                                    //debug = "clicked, isNewItem: \(String(isNewItem))"
                                }
                            } label: {
                                HStack {
                                    Image(systemName: "plus.circle.fill")
                                        .resizable(resizingMode: .tile)
                                    .frame(width: 30, height: 30)
                                    Text("Add a new item")
                                        .font(.title3)
                                }
                                .padding(3)
                            }
                            .tint(.yellow)
                            .padding(7)
                            
                            Spacer()
                        }
                        
                        Divider()
                        
                        HStack {
                            Button {
                                showResult = true
                            } label: {
                                HStack {
                                    Image(systemName: "checkmark.circle.fill")
                                        .resizable(resizingMode: .tile)
                                    .frame(width: 30, height: 30)
                                    Text("Finish")
                                        .font(.title3)
                                }
                                .padding(3)
                            }
                            .tint(.green)
                            .padding(.top, 7)
                            .padding(.leading, 7)
                            .padding(.trailing, 7)
                            
                            Spacer()
                        }
                        
                    }
                }
                .padding(20)
                .background(Color(red: 160 / 255, green: 160 / 255, blue: 160 / 255).opacity(0.1))
        }
        .cornerRadius(10)
        .overlay(RoundedRectangle(cornerRadius: 10)
                    .stroke(.gray, lineWidth: 1))
        .padding()
        .offset(x: xOffset, y: yOffset)
        .opacity(opacity)
        .onChange(of: isNewItem) { newValue in
            //debug = "onChange 0, isNewItem: \(String(isNewItem))"
            if newValue {
                //debug = "onChange 1, isNewItem: \(String(isNewItem))"
                withAnimation(.easeInOut(duration: 0.35)) {
                    xOffset = 300
                    opacity = 0.0
                }
                let secondsToDelay = 0.35
                DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
                    isNewItem = false
                }

            } else {
                //debug = "onChange 2, isNewItem: \(String(isNewItem))"
                let newPair = PairProductPrice(id: UUID().uuidString, name: AttributionView.textOfNewItem, price: 0.0)
                model.listOfProductsAndPrices.append(newPair)
            }
        }
        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))

    }
    
}

struct LastItemView_Previews: PreviewProvider {
    static var previews: some View {
        LastItemView(showResult: .constant(false))
    }
}
