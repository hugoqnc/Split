//
//  LoadItemsView.swift
//  ReceiptSplitter
//
//  Created by Hugo Queinnec on 08/01/2022.
//

import SwiftUI

struct LoadItemsView: View {
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
                    Text("No item was found on your scan.\nPlease make sure your receipt is compatible with this application.\nIf it is, you can try to scan it again.")
                        .padding(.top,3)
                        .padding(.bottom,10)
                        .padding(.leading)
                        .padding(.trailing)
                    Button {
                        dismiss()
                        
                        model.startTheProcess = false
                        model.users = UsersModel().users
                        model.listOfProductsAndPrices = []
                    } label: {
                        Label("Start again", systemImage: "arrow.clockwise")
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.bottom)
                    .tint(.orange)
                }
                .padding(5)
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
        LoadItemsView(nothingFound: .constant(true))
    }
}
