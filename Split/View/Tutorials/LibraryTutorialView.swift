//
//  LibraryTutorialView.swift
//  Split
//
//  Created by Hugo Queinnec on 19/03/2023.
//

import SwiftUI

struct LibraryTutorialView: View {
    @Binding var advancedRecognition: Bool
    
    var body: some View {
        VStack {
            VStack {
                Image("library_tutorial")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
                    .frame(maxHeight: 300)
                
                VStack(alignment: .leading) {
                    
                    HStack(alignment: .center) {
                        Image(systemName: "skew")
                            .frame(width: 30, height: 30)
                            .font(.largeTitle)
                            .foregroundColor(.accentColor)
                            .padding()

                        VStack(alignment: .leading, spacing: 2) {
                            Text("Cropped receipts only")
                                .font(.headline)
                                .foregroundColor(.primary)

                            Text(advancedRecognition ? "The edges of the image should match the edges of the receipt\n(if not, start by cropping your receipt in the Photos app)" : "The image should contain only the items and their prices, not what is above or below them")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    
                    HStack(alignment: .center) {
                        Image(systemName: "goforward.plus")
                            .frame(width: 30, height: 30)
                            .font(.largeTitle)
                            .foregroundColor(.accentColor)
                            .padding()

                        VStack(alignment: .leading, spacing: 2) {
                            Text("Add several images")
                                .font(.headline)
                                .foregroundColor(.primary)

                            Text("Select multiple receipts to process them all at once ")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
            }
        }
        .frame(maxWidth: 300)
        

    }
}

struct LibraryTutorialView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryTutorialView(advancedRecognition: .constant(true))
    }
}
