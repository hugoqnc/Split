//
//  ErrorBlock.swift
//  Split
//
//  Created by Hugo Queinnec on 02/08/2022.
//

import SwiftUI

struct InfoBlock: View {
    var color: Color
    var icon: String
    var title : String
    var subtitle: String
    
    var body: some View {
        Group {
            HStack(alignment: .center) {
                Image(systemName: icon)
                    .frame(width: 30, height: 30)
                    .font(.largeTitle)
                    .foregroundColor(color)
                    .padding(10)

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(color)

                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
            }
            .padding(10)
            .padding(.trailing,5)
        }
        .background(color.opacity(0.1))
        .cornerRadius(15)
    }
}

struct InfoBlock_Previews: PreviewProvider {
    static var previews: some View {
        InfoBlock(color: .red, icon: "wifi.slash", title: "Connection failure", subtitle: "Please verify your internet connection and start again")
    }
}
