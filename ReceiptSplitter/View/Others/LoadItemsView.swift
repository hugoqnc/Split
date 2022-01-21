//
//  LoadItemsView.swift
//  ReceiptSplitter
//
//  Created by Hugo Queinnec on 08/01/2022.
//

import SwiftUI

struct LoadItemsView: View {
    @Binding var showScanningResults : Bool
    @Binding var nothingFound: Bool
    @EnvironmentObject var model: ModelData
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        if nothingFound {
            VStack {
                VStack {
                    Image(systemName: "exclamationmark.triangle")
                        .resizable(resizingMode: .tile)
                        .frame(width: 30.0, height: 30.0)
                        .foregroundColor(.orange)
                        .padding(.top)
                    HStack {
                        Text("No item was found on your scan.")
                            .fontWeight(.semibold)
                            .padding(.top,3)
                            .padding(.leading)
                            .padding(.bottom,1)
                            .padding(.trailing)
                        Spacer()
                    }
                    HStack {
                        Text("Please make sure your receipt is compatible with this application.\nIf it is, you can try to scan it again.")
                            .padding(.bottom,10)
                            .padding(.leading)
                            .padding(.trailing)
                        Spacer()
                    }
                    Button {
                        dismiss()
                        
                        model.listOfProductsAndPrices = []
                        withAnimation() {
                            showScanningResults = false
                        }
                        
                    } label: {
                        Label("Start again", systemImage: "arrow.clockwise")
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.bottom)
                    .tint(.orange)
                }
                .padding(10)
            }
            .cornerRadius(10)
            .overlay(RoundedRectangle(cornerRadius: 10)
                        .stroke(.orange, lineWidth: 1))
            .padding()
            .interactiveDismissDisabled(true)
            
        } else {
            ZStack {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(2)
            }
            .interactiveDismissDisabled(true)
        }
    }
    
}

struct LoadItemsView_Previews: PreviewProvider {
    static var previews: some View {
        LoadItemsView(showScanningResults: .constant(true), nothingFound: .constant(true))
    }
}
