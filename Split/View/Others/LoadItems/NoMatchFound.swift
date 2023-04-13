//
//  NoMatchFound.swift
//  Split
//
//  Created by Hugo Queinnec on 06/03/2022.
//

import SwiftUI

struct NoMatchFound: View {
    @EnvironmentObject var model: ModelData
    
    var body: some View {
        VStack {
            Image(systemName: "doc.viewfinder")
                .resizable(resizingMode: .stretch)
                .frame(width: 30.0, height: 30.0)
                .font(.largeTitle)
                .foregroundColor(.orange)
                .padding(.top)
                .padding(.bottom,5)
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("No match with your receipt")
                        .font(.headline)
                        .foregroundColor(.primary)
                        .fixedSize(horizontal: false, vertical: true)

                    Text("Advanced Recognition is enabled and attempts to get the exact content of your receipt, but it has failed.\nYou can try again, or turn off Advanced Recognition.")
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
                        Image(systemName: "info.circle")
                            .frame(width: 10, height: 10)
                            .foregroundColor(.accentColor)
                            .padding(7)
                            .padding(.trailing,5)
                        Text("Advanced Recognition works best with receipts under 40 items, and where the total price is visible.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    HStack{
                        Image(systemName: "skew")
                            .frame(width: 10, height: 10)
                            .foregroundColor(.accentColor)
                            .padding(7)
                            .padding(.trailing,5)
                        Text(model.photoIsImported ? "Make sure you have correctly cropped your receipt when you import it from the photo library. The edges of the image must match the edges of the receipt perfectly." : "If you disable Advanced Recognition, you should manually crop your receipt.")
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

struct NoMatchFound_Previews: PreviewProvider {
    static var previews: some View {
        NoMatchFound()
            .environmentObject(ModelData())
    }
}
