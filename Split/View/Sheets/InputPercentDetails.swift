//
//  InputPercentDetails.swift
//  Split
//
//  Created by Hugo Queinnec on 21/03/2023.
//

import SwiftUI

struct InputPercentDetails: View {
    @EnvironmentObject var model: ModelData
    @Environment(\.dismiss) var dismiss
    @FocusState var isKeyboardShown: Bool

    public var isTip: Bool // "false" means that it is Tax
    
    @State private var doubleState: Double = 20
    @State private var sharingSelection: String = "even" // or "proportional"

    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    
                    HStack(alignment: .center) {
                        Image(systemName: isTip ? "giftcard" : "building.columns")
                            .frame(width: 30, height: 30)
                            .font(.largeTitle)
                            .foregroundColor(.primary)
                            .padding()

                        VStack(alignment: .leading, spacing: 2) {
                            Text(isTip ? "Add a tip" : "Add taxes")
                                .font(.headline)
                                .foregroundColor(.primary)

                            Text(isTip ? "Choose what tip percentage you want to add to your bill" : "Set the tax percentage that applies to your receipt. You can choose a precise amount by tapping on the number.")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        
                    }
                    .padding(.horizontal)
                    .listRowBackground(Color.clear)
                    
                    Section {
                        VStack(spacing: 2) {
                            HStack {
                                Spacer()
                                TextField(isTip ? "" : "", value: $doubleState, format: .number)
                                    .keyboardType(.decimalPad)
                                    .textFieldStyle(.automatic)
                                    .multilineTextAlignment(.trailing)
                                    .focused($isKeyboardShown)
                                Text("%")
                            }
                            .font(Font.system(size: 55, design: .default))
                            
                            HStack {
                                Spacer()
                                Text("= \(model.showPrice(price: model.totalPriceBeforeTaxTip*(doubleState/100))) ")
                                    .font(.title2)
                            }
                        }
                    }
                    .listRowBackground(Color.clear)
                    
                    Section {
                        
                        Slider(value: $doubleState, in: 0...40, step: 1)
                            .padding(5)

                        Group {
                            if isTip {
                                VStack(alignment: .leading) {
                                    HStack {
                                        Spacer()
                                        ForEach(model.parameters.usualTips, id: \.self) { tipAmount in
                                            Button {
                                                doubleState = tipAmount
                                            } label: {
                                                Text(String(round(tipAmount * 100) / 100.0)+"%")
                                                    .font(.headline)
                                                    .padding(3)
                                            }
                                            .buttonStyle(.bordered)
                                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(.blue, lineWidth: doubleState == tipAmount ? 1.5 : 0))
                                            .padding(3)
                                            
                                        }
                                        Spacer()
                                    }
                                    HStack {
                                        Spacer()
                                        Text("Define your favorite tip percentages in settings")
                                            .font(.caption2)
                                            .foregroundColor(.secondary)
                                        Spacer()
                                    }
                                }
                            }
                        }
                                                
                        Picker("", selection: $sharingSelection) {
                            Text("Share evenly").tag("even")
                            Text("Share proportionally").tag("proportional")
                        }
                        .pickerStyle(.segmented)
                        .padding(.vertical, 5)
                        
                    } footer: {
                        if sharingSelection == "even" {
                            Label("Everyone will pay the same amount of \(isTip ? "tip" : "tax"), regardless of what they bought.", systemImage: "percent")
                        }
                        else {
                            Label("\(isTip ? "The tip" : "Taxes") will be shared in proportion to the expenses of each person.", systemImage: "percent")
                        }
                    }
                    
                    Section {
                        Button {
                            if isTip {
                                model.tipRate = nil
                                model.tipEvenly = nil
                            } else {
                                model.taxRate = nil
                                model.taxEvenly = nil
                            }
                            dismiss()
                        } label: {
                            Label("Remove \(isTip ? "the tip" : "taxes")", systemImage: "gobackward")
                        }
                        .foregroundColor(.red)
                    }
                    
                }

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
                        if isTip {
                            model.tipEvenly = sharingSelection == "even"
                            model.tipRate = doubleState
                        } else {
                            model.taxEvenly = sharingSelection == "even"
                            model.taxRate = doubleState
                        }
                        dismiss()
                    } label: {
                        Text("Done")
                            .bold()
                    }
                }
            }
            .navigationBarTitle(Text(""), displayMode: .inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .interactiveDismissDisabled()
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                Button {
                    isKeyboardShown = false
                } label: {
                    Text("OK")
                }
            }
        }
        .onAppear {
            if isTip {
                if let t = model.tipRate, let even = model.tipEvenly {
                    doubleState = t
                    sharingSelection = even ? "even" : "proportional"
                } else {
                    doubleState = model.parameters.usualTips[1]
                    sharingSelection = model.parameters.defaultTipEvenly ? "even" : "proportional"
                }
            } else {
                if let t = model.taxRate, let even = model.taxEvenly {
                    doubleState = t
                    sharingSelection = even ? "even" : "proportional"
                } else {
                    doubleState = model.parameters.defaultTaxRate
                    sharingSelection = model.parameters.defaultTaxEvenly ? "even" : "proportional"
                }
            }
        }
    }
}

struct InputPercentDetails_Previews: PreviewProvider {
    static let model: ModelData = {
        var model = ModelData()
        model.users = [User(name: "Hugo"), User(name: "Lucas"), User(name: "Thomas")]
        model.listOfProductsAndPrices = [PairProductPrice(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBB", name: "Potato Wedges 1kg", price: 4.99), PairProductPrice(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBC", name: "Finger Fish", price: 1.27), PairProductPrice(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBD", name: "Ice Cream Strawberry", price: 3.20)]
        model.listOfProductsAndPrices[0].chosenBy = [model.users[0].id]
        //model.listOfProductsAndPrices[1].chosenBy = [model.users[0].id, model.users[1].id]
        //model.listOfProductsAndPrices[2].chosenBy = [model.users[0].id, model.users[1].id, model.users[2].id]
        return model
    }()
    
    static var previews: some View {
        
        InputPercentDetails(isTip: true)
            .environmentObject(model)
    }
}
