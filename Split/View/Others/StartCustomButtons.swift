//
//  StartCustomButtons.swift
//  Split
//
//  Created by Hugo Queinnec on 13/04/2023.
//

import SwiftUI

struct StartCustomButtons: View {
    var role: String // "scan", "library", "files"
    
    var body: some View {
        switch role {
        case "scan":
            Label("Scan", systemImage: "viewfinder")
                .labelStyle(.titleAndIcon)
                .foregroundColor(.white)
                .padding(.horizontal, 15)
                .padding(.vertical, 10)
                .background(Color.accentColor)
                .clipShape(Capsule())

        case "library":
            Label("", systemImage: "photo.on.rectangle.angled")
                .labelStyle(.iconOnly)
                .foregroundColor(.white)
                .padding(10)
                .background(Color.accentColor)
                .clipShape(Circle())
            
        case "files":
            Label("", systemImage: "folder")
                .labelStyle(.iconOnly)
                .foregroundColor(.white)
                .padding(10)
                .background(Color.accentColor)
                .clipShape(Circle())

        default:
            EmptyView()
        }
    }
}

struct StartCustomButtons_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            StartCustomButtons(role: "scan")
            StartCustomButtons(role: "library")
            StartCustomButtons(role: "files")
        }
        .previewLayout(PreviewLayout.sizeThatFits)
        .padding()
        .previewDisplayName("Default preview")
    }
}
