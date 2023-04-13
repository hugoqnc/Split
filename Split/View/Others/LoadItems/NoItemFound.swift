//
//  NoItemFound.swift
//  Split
//
//  Created by Hugo Queinnec on 06/03/2022.
//

import SwiftUI

struct NoItemFound: View {
    @EnvironmentObject var model: ModelData
    
    var body: some View {
        VStack {
            Image(systemName: "exclamationmark.triangle")
                .resizable(resizingMode: .stretch)
                .frame(width: 30.0, height: 30.0)
                .font(.largeTitle)
                .foregroundColor(.orange)
                .padding(.top)
                .padding(.bottom,5)
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("No item was found on your scan")
                        .font(.headline)
                        .foregroundColor(.primary)
                        .fixedSize(horizontal: false, vertical: true)

                    Text(model.photoIsImported ? "Make sure you have correctly cropped your receipt image when you import it from the library." : "Please ensure that you have scanned your receipt correctly, following the instructions given on the tutorial card.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer()
            }
            .padding(.horizontal)
            
            Divider()
                .padding(.horizontal)
                .padding(.vertical, 7)

            
            HStack {
                VStack(alignment: .leading) {
                    HStack{
                        Image(systemName: "scissors")
                            .frame(width: 10, height: 10)
                            .foregroundColor(.accentColor)
                            .padding(7)
                            .padding(.trailing,5)
                        Text(model.photoIsImported ? "The edges of the image must match the edges of the receipt perfectly." : "If your receipt is very long, try to scan it in several pictures for better results.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    HStack{
                        Image(systemName: "exclamationmark.triangle")
                            .frame(width: 10, height: 10)
                            .foregroundColor(.accentColor)
                            .padding(7)
                            .padding(.trailing,5)
                        Text("If the recognition does not work reliably, the format of your shopping receipt may not be supported by this app.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal)
                Spacer()
            }
            
            Divider()
                .padding(.horizontal)
                .padding(.vertical, 7)

        }
    }
}

struct NoItemFound_Previews: PreviewProvider {
    static var previews: some View {
        NoItemFound()
            .environmentObject(ModelData())
    }
}
