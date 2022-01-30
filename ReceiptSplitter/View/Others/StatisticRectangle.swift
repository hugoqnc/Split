//
//  StatisticRectangle.swift
//  ReceiptSplitter
//
//  Created by Hugo Queinnec on 30/01/2022.
//

import SwiftUI

struct StatisticRectangle: View {
    var iconString: String
    var description: String
    var value: String
    var color: Color
    
    var body: some View {
        Group {
            Group {
                ZStack {

                    HStack {
                        VStack {
                            Image(systemName: iconString)
                                .resizable(resizingMode: .tile)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 65.0, height: 65.0)
                                .foregroundColor(color)
                            Spacer()
                        }
                        Spacer()
                    }

                    HStack {
                        Spacer()
                        VStack(alignment: .trailing) {
                            Spacer()
                            VStack(alignment: .trailing) {
                                Text(value)
                                    .font(.largeTitle)
                                    .fontWeight(.semibold)
                                Text(description)
                                    .font(.footnote)
                                    .multilineTextAlignment(.trailing)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                
//                VStack {
//                    HStack {
//                        Image(systemName: iconString)
//                            .resizable(resizingMode: .tile)
//                            .aspectRatio(contentMode: .fit)
//                            .frame(width: 65.0, height: 65.0)
//                            .foregroundColor(color)
//                        Spacer()
//                    }
//                    HStack {
//                        Spacer()
//                        VStack(alignment: .trailing) {
//                            Text(value)
//                                .font(.largeTitle)
//                                .fontWeight(.semibold)
//                            Text(description)
//                                .font(.footnote)
//                                .multilineTextAlignment(.trailing)
//                                .foregroundColor(.secondary)
//                        }
//                    }
//                }
            }
            .frame(idealWidth: 140, maxWidth: 200, idealHeight: 140, maxHeight: 200)
            .padding()
        }
        .background(color.opacity(0.1))
        .cornerRadius(15)
    }
}

struct StatisticRectangle_Previews: PreviewProvider {
    static var previews: some View {
        StatisticRectangle(iconString: "cart", description: "Average price\nof an item", value: "3,45€", color: Color.orange)
    }
}
