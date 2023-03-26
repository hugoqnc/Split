//
//  AddPercentButton.swift
//  Split
//
//  Created by Hugo Queinnec on 25/03/2023.
//

import SwiftUI

struct AddPercentButton: View {
    @EnvironmentObject var model: ModelData
    @State var showInputSheet = false
    var isTip:  Bool
    var color: Color
    var isShownInHistory: Bool = false
    
    func buttonLabel() -> String {
        if isTip {
            if model.tipRate != nil {
                return "giftcard"
            } else {
                return "plus.circle"
            }
        } else {
            if model.taxRate != nil {
                return "building.columns"
            } else {
                return "plus.circle"
            }
        }
    }
    
    func buttonTitle() -> String {
        if isTip {
            if model.tipRate != nil {
                return "\(model.showPrice(price: model.tipAmount)) tip"
            } else {
                return "Add a tip"
            }
        } else {
            if model.taxRate != nil {
                return "\(model.showPrice(price: model.taxAmount)) tax"
            } else {
                return "Add taxes"
            }
        }
    }
    
    func buttonDescription() -> String {
        if isTip {
            if model.tipRate != nil {
                return "\(model.tipRate!)%, \(model.tipEvenly! ? "evenly" : "proportionally")"
            } else {
                return "if not included"
            }
        } else {
            if model.taxRate != nil {
                return "\(model.taxRate!)%, \(model.taxEvenly! ? "evenly" : "proportionally")"
            } else {
                return "if not included"
            }
        }
    }
    
    func isFilled() -> Bool { // returns true if the button has content to display
        if isTip {
            if model.tipRate != nil {
                return true
            } else {
                return false
            }
        } else {
            if model.taxRate != nil {
                return true
            } else {
                return false
            }
        }

    }
    
    var body: some View {
        if !isShownInHistory || isFilled() {
            Group {
                Group {
                    HStack {
                        Image(systemName: buttonLabel())
                            .resizable(resizingMode: .stretch)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 25)
                            .foregroundColor((isFilled() ? color : Color.accentColor))
                        
                        Spacer()
                        
                            VStack(alignment: .trailing) {
                                Text(buttonTitle())
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    //.minimumScaleFactor(0.3)
                                    .lineLimit(1)
                                Text(buttonDescription())
                                    .font(.caption)
                                    .multilineTextAlignment(.trailing)
                                    .foregroundColor(.secondary)
                                    .minimumScaleFactor(0.7)
                                    .lineLimit(1)
                            }
                    }
                }
                .frame(idealWidth: 140, maxWidth: 200, idealHeight: 50, maxHeight: 50)
                .padding(10)
                .padding(.horizontal, 4)
            }
            .background((isFilled() ? color : Color.secondary).opacity(0.1))
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke((isFilled() ? color : Color.secondary.opacity(0.3)), lineWidth: isShownInHistory ? 0 : 1.5)
            )
            .onTapGesture {
                if !isShownInHistory {
                    showInputSheet = true
                }
            }
            .sheet(isPresented: $showInputSheet) {
                InputPercentDetails(isTip: isTip)
            }
        }
    }
}

struct AddPercentButton_Previews: PreviewProvider {
    static let model: ModelData = {
        var model = ModelData()
        model.images = [IdentifiedImage(id: "1111", image: UIImage(named: "scan1")), IdentifiedImage(id: "2222", image: UIImage(named: "scan2"))]
        model.users = [User(name: "Hugo"), User(name: "Corentin"), User(name: "Thomas")]
        model.listOfProductsAndPrices = [PairProductPrice(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBB", name: "Potato Wedges 1kg", price: 1.0), PairProductPrice(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBC", name: "Finger Fish 850g x12 from Aldi 2022", price: 2.0), PairProductPrice(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBD", name: "Ice Cream Strawberry", price: 7.0)]
        model.listOfProductsAndPrices[0].chosenBy = [model.users[0].id]
        model.listOfProductsAndPrices[1].chosenBy = [model.users[0].id, model.users[1].id]
        model.listOfProductsAndPrices[2].chosenBy = [model.users[0].id, model.users[1].id, model.users[2].id]
        model.receiptName = "ALDI SUISSE"
        model.tipRate = 10.0
        model.tipEvenly = false
        return model
    }()
    
    static var previews: some View {
        AddPercentButton(isTip: true, color: .blue)
            .environmentObject(model)
    }
}
