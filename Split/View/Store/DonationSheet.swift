//
//  DonationSheet.swift
//  Split
//
//  Created by Hugo Queinnec on 15/04/2023.
//

import SwiftUI
import ConfettiSwiftUI

struct DonationSheet: View {
    @Environment(\.dismiss) var dismiss
    @State private var counter: Int = 0
    
    var titleFont = UIFont.preferredFont(forTextStyle: .largeTitle)

    var body: some View {
        VStack {

            Button {
                counter += 1
            } label: {
                Label("", systemImage: "heart")
                    .font(Font.system(size: 55, design: .default))
                    .foregroundColor(.pink)
            }
            .confettiCannon(counter: $counter, num: 60, confettiSize: 12, rainHeight: 1000, openingAngle: Angle.degrees(40), closingAngle: Angle.degrees(140), repetitions: 2, repetitionInterval: 2.5)
            .onAppear {
                counter += 1
            }
            .padding(.top, 40)
            
            Group{
                Text("Thank ") +
                Text("you") +//.foregroundColor(.pink) +
                Text("!")
            }
            .font(Font(UIFont(
                descriptor:
                    titleFont.fontDescriptor
                    .withDesign(.rounded)? /// make rounded
                    .withSymbolicTraits(.traitBold) /// make bold
                    ??
                    titleFont.fontDescriptor, /// return the normal title if customization failed
                size: 38
            )))
            .padding()
            
            Text(
"""
I started developing Split! for my own needs and those of my friends. This led me to winning the Swift Student Challenge in 2022, and presenting this project to Apple CEO Tim Cook!
I continue to improve this project in my spare time. With your donation, you help me considerably, especially to cover the costs of publishing this app.
Do not hesitate to contact me if you want to discuss potential missing features, or bugs to fix.

Thanks again,
Hugo
"""         )
            .padding(.horizontal, 30)
            .font(Font.system(size: 18, design: .default))
            
            Button("Close") {
                dismiss()
            }
            .tint(.pink)
            .padding(.top)
        }
    }
}

struct DonationSheet_Previews: PreviewProvider {
    static var previews: some View {
        DonationSheet()
    }
}
