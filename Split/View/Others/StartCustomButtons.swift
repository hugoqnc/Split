//
//  StartCustomButtons.swift
//  Split
//
//  Created by Hugo Queinnec on 13/04/2023.
//

import SwiftUI

struct StartCustomButtons: View {
    var role: String // "scan", "library"
    
    var body: some View {
        switch role {
        case "scan":
//            Group {
//                ZStack {
//                    VStack(spacing: 1) {
//                        Image(systemName: "viewfinder")
//                            .font(Font.system(size: 20, weight: .semibold))
//                        Text("Scan")
//                            .font(.subheadline)
//                            .fontWeight(.semibold)
//                    }
//                    .foregroundColor(.white)
//                    .padding(10)
//                    .background(Color.accentColor)
//                    .clipShape(RoundedRectangle(cornerRadius: 15))
//                }
//            }
            Label("Scan", systemImage: "viewfinder")
                .labelStyle(.titleAndIcon)
                .foregroundColor(.white)
                .padding(.horizontal, 15)
                .padding(.vertical, 10)
                .background(Color.accentColor)
                .clipShape(Capsule())

        case "library":
//            Group {
//                ZStack {
//                    VStack(spacing: 1) {
//                        Image(systemName: "photo.on.rectangle.angled")
//                            .font(Font.system(size: 20, weight: .semibold))
//                        Text("Load")
//                            .font(.subheadline)
//                            .fontWeight(.semibold)
//                    }
//                    .foregroundColor(.white)
//                    .padding(10)
//                    .background(Color.accentColor)
//                    .clipShape(RoundedRectangle(cornerRadius: 15))
//                }
//            }
            Label("", systemImage: "photo.on.rectangle.angled")
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
        }
        .previewLayout(PreviewLayout.sizeThatFits)
        .padding()
        .previewDisplayName("Default preview")
    }
}
