//
//  TutorialView.swift
//  ReceiptSplitter
//
//  Created by Hugo Queinnec on 20/01/2022.
//

import SwiftUI

struct TutorialView: View {
    var body: some View {
        VStack {
            Image("receipt_tutorial")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding()
            //.frame(width: 300, alignment: .center)
            
            VStack(alignment: .leading) {
                HStack(alignment: .center) {
                    Image(systemName: "viewfinder")
                        .frame(width: 30, height: 30)
                        .font(.largeTitle)
                        .foregroundColor(.yellow)
                        .padding()
                        .accessibility(hidden: true)

                    VStack(alignment: .leading, spacing: 2) {
                        Text("Center your scan ")
                            .font(.headline)
                            .foregroundColor(.primary)

                        Text("Scan the items and their prices, not what is above or below on the receipt")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    
                }
                
                HStack(alignment: .center) {
                    Image(systemName: "skew")
                        .frame(width: 30, height: 30)
                        .font(.largeTitle)
                        .foregroundColor(.yellow)
                        .padding()
                        .accessibility(hidden: true)

                    VStack(alignment: .leading, spacing: 2) {
                        Text("Adjust if necessary")
                            .font(.headline)
                            .foregroundColor(.primary)

                        Text("You can manually adjust the frame such that only the right content appears")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                
                HStack(alignment: .center) {
                    Image(systemName: "goforward.plus")
                        .frame(width: 30, height: 30)
                        .font(.largeTitle)
                        .foregroundColor(.yellow)
                        .padding()
                        .accessibility(hidden: true)

                    VStack(alignment: .leading, spacing: 2) {
                        Text("Add several scans")
                            .font(.headline)
                            .foregroundColor(.primary)

                        Text("If you have a long receipt, you can add multiple scans, but make sure not to scan the same item twice")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
            .padding(.horizontal)
        }
            
        

    }
}

struct TutorialView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialView()
    }
}
