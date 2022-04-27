//
//  isValidLabel.swift
//  Split
//
//  Created by Hugo Queinnec on 28/04/2022.
//

import SwiftUI

struct isValidLabel: View {
    @Environment(\.colorScheme) var colorScheme
    var isValid: Bool
    
    var body: some View {
        Group {
            if isValid {
                ZStack {
                    Text("Valid ID")//, systemImage: "checkmark")
                        .font(.caption2)
                }
                .padding(3)
                .padding(.horizontal, 4)
                .foregroundColor(.green)
                .brightness(colorScheme == .dark ? 0.1 : -0.2)
            } else {
                ZStack {
                    Text("Invalid ID")//, systemImage: "xmark")
                        .font(.caption2)
                }
                .padding(3)
                .padding(.horizontal, 4)
                .foregroundColor(.red)
                .brightness(colorScheme == .dark ? 0.1 : -0.1)
            }
        }
        .background((isValid ? Color.green : Color.red).opacity(0.2))
        .cornerRadius(15)
    }

}

struct isValidLabel_Previews: PreviewProvider {
    static var previews: some View {
        isValidLabel(isValid: false)
    }
}
