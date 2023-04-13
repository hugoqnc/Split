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
                .font(.subheadline)
                .labelStyle(.titleAndIcon)
                .foregroundColor(.white)
                .padding(.horizontal, 15)
                .padding(.vertical, 10)
                .background(Color.accentColor)
                .clipShape(Capsule())

        case "library":
            Label("", systemImage: "photo.on.rectangle.angled")
                .font(.subheadline)
                .labelStyle(.iconOnly)
                .foregroundColor(.accentColor)
                .padding(10)
                .background(Color.accentColor.opacity(0.15))
                .clipShape(Circle())
            
        case "files":
            Label("", systemImage: "folder")
                .font(.subheadline)
                .labelStyle(.iconOnly)
                .foregroundColor(.accentColor)
                .padding(10)
                .background(Color.accentColor.opacity(0.15))
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
