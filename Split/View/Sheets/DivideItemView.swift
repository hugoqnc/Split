//
//  DivideItemView.swift
//  Split
//
//  Created by Hugo Queinnec on 17/06/2022.
//

import SwiftUI

struct DivideItemView: View {
    var pair: PairProductPrice
    @Binding var dividedBy: Int
    @Binding var dividesItemCall: Bool
    @State private var chosenInt = 2
    @EnvironmentObject var model: ModelData
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                HStack(alignment: .center) {
                    Image(systemName: "divide")
                        .frame(width: 30, height: 30)
                        .font(.largeTitle)
                        .foregroundColor(.primary)
                        .padding()

                    VStack(alignment: .leading, spacing: 2) {
                        Text("Divide item")
                            .font(.headline)
                            .foregroundColor(.primary)

                        Text("The item \"\(pair.name)\" will be divided into multiple cards.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    
                }
                .padding(.top)
                .padding(.horizontal, 40)
                
                VStack{
                    VStack {
                        Text("Divide by".uppercased())
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("\(chosenInt)")
                            .font(.largeTitle)
                        Stepper("", value: $chosenInt, in: 2...20)
                            .labelsHidden()
                            .padding(.top, -14)
                    }
                    .padding()
                    .background(Color(uiColor: UIColor.systemBackground).brightness(0.06))
                    .cornerRadius(10)
                    .shadow(color: .black.opacity(0.2), radius: 15.0)
                    
                    Label("The current card \"\(pair.name)\" costing \(model.showPrice(price: pair.price)) will be replaced by \(chosenInt) new cards costing \(model.showPrice(price: pair.price/Double(chosenInt))) each.", systemImage: "info.circle")
                        .font(.subheadline)
                        .padding()
                }
                .padding()
                .padding(.top)
                
                Spacer()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dividedBy = chosenInt
                        dividesItemCall = true
                        dismiss()
                    } label: {
                        Text("Divide")
                            .bold()
                    }
                }
            }
            .navigationBarTitle(Text(""), displayMode: .inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct DivideItemView_Previews: PreviewProvider {
    static var previews: some View {
        Text("test")
            .sheet(isPresented: .constant(true)) {
                DivideItemView(pair: PairProductPrice(id: "aaa", name: "Poulet", price: 3.14), dividedBy: .constant(2), dividesItemCall: .constant(true))
                    .environmentObject(ModelData())
            }
    }
}
