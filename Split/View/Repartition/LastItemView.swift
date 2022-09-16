//
//  LastItemView.swift
//  Split
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
                        .resizable(resizingMode: .stretch)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                        .foregroundColor(.orange)
                        .padding(.top,1)
                        .padding(.bottom,5)
                    
                                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Any additional item to add?")
                                .font(.title2)
                                .padding(.bottom,1)
                            Text("If you want to add an additional item to your receipt, you can do so here. Otherwise, finish now to view the results.")
                                .font(.subheadline)
                                .padding(.bottom,5)
                                .fixedSize(horizontal: false, vertical: true) //for small screen sizes
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
                                        .resizable(resizingMode: .stretch)
                                    .frame(width: 30, height: 30)
                                    Text("Add a new item")
                                        .font(.title3)
                                }
                                .padding(3)
                                
                                Spacer()
                            }
                            //.tint(.yellow)
                            .padding(4)
                        }
                        
                        Divider()
                        
                        HStack {
                            Button {
                                withAnimation(.easeInOut) {
                                    model.date = Date()
                                    showResult = true
                                }
                            } label: {
                                HStack {
                                    Image(systemName: "checkmark.circle.fill")
                                        .resizable(resizingMode: .stretch)
                                    .frame(width: 30, height: 30)
                                    Text("Finish")
                                        .font(.title3)
                                }
                                .padding(3)
                                
                                Spacer()
                            }
                            .tint(.green)
                            .padding(.top, 4)
                            .padding(.leading, 4)
                            .padding(.trailing, 4)
                            
                        }
                        
                    }
                }
                .padding(20)
                //.background(Color(red: 160 / 255, green: 160 / 255, blue: 160 / 255).opacity(0.1))
        }
        .background(Color(uiColor: UIColor.systemBackground).brightness(0.06))
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.2), radius: 15.0)
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
                var newPair = PairProductPrice(id: UUID().uuidString, name: AttributionCard.textOfNewItem, price: 0.0)
                newPair.isNewItem = true
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
