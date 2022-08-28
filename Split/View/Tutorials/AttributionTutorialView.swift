//
//  AttributionTutorialView.swift
//  Split
//
//  Created by Hugo Queinnec on 20/01/2022.
//

import SwiftUI

struct AttributionTutorialView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        VStack {
                VStack {
                    Image("product_card")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding()
                        .frame(maxHeight: 250)

                    
                    VStack(alignment: .leading) {
                        HStack(alignment: .center) {
                            Image(systemName: "checkmark.circle")
                                .frame(width: 30, height: 30)
                                .font(.largeTitle)
                                .foregroundColor(.accentColor)
                                .padding()

                            VStack(alignment: .leading, spacing: 2) {
                                Text("Attribute each item")
                                    .font(.headline)
                                    .foregroundColor(.primary)

                                Text("An item is represented by a card, with its name and price. Check names to assign them the item.")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            
                        }

                    }
                }
                .transition(.move(edge: .top))

        }
        .frame(maxWidth: 300)
        

    }
}

struct AttributionTutorialView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewWrapper()
            
            
            
    }
    struct PreviewWrapper: View {
        @State private var show = true
        @State private var toggle = true

        var body: some View {
            Text("test")
                .slideOverCard(isPresented: $show, content: {
                    AttributionTutorialView()
                })
                .onTapGesture {
                    show=true
                }
        }
    }
}

