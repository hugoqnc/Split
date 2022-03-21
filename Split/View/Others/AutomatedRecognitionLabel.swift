//
//  AutomatedRecognitionLabel.swift
//  Split
//
//  Created by Hugo Queinnec on 11/03/2022.
//

import SwiftUI

struct AutomatedRecognitionLabel: View {
    @Environment(\.colorScheme) var colorScheme
    var isEnabled: Bool
    
    var body: some View {
        Group {
            if isEnabled {
                ZStack {
                    Label("Advanced Recognition", systemImage: "wand.and.stars")
                        .font(.caption2)
                }
                .padding(3)
                .padding(.horizontal, 4)
                .foregroundColor(.teal)
                .brightness(colorScheme == .dark ? 0.1 : -0.2)
            } else {
                ZStack {
                    Label("Standard Recognition", systemImage: "eye")
                        .font(.caption2)
                }
                .padding(3)
                .padding(.horizontal, 4)
                .foregroundColor(.secondary)
            }
        }
        .background((isEnabled ? Color.teal : Color.secondary).opacity(0.2))
        .cornerRadius(15)
    }
}

struct AutomatedRecognitionLabel_Previews: PreviewProvider {
    static var previews: some View {
        AutomatedRecognitionLabel(isEnabled: true)
            //.preferredColorScheme(.dark)
    }
}
