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

                            Text("Please ensure that you have scanned your receipt correctly, following the instructions given on the tutorial card")
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
                                Text("If your receipt is very long, try to scan it in several pictures for better results")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            HStack{
                                Image(systemName: "exclamationmark.triangle")
                                    .frame(width: 10, height: 10)
                                    .foregroundColor(.accentColor)
                                    .padding(7)
                                    .padding(.trailing,5)
                                Text("If the recognition does not work reliably, the format of your shopping receipt may not be supported by this app")
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

                    
                    Button {
                        model.eraseScanData()
                        nothingFound = false
                        withAnimation() {
                            showScanningResults = false
                        }
                        
                    } label: {
                        Label("Try again", systemImage: "arrow.clockwise")
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.bottom,10)
                    .padding(.top,5)
                    .tint(.orange)

                }
                .padding(10)
                .frame(maxWidth: 400)
            }
            .background(Color(uiColor: UIColor.systemBackground).brightness(0.06))
            .cornerRadius(10)
//            .overlay(RoundedRectangle(cornerRadius: 10)
//                        .stroke(.orange, lineWidth: 5))
            .shadow(color: .black.opacity(0.2), radius: 15.0)
            .padding()
            
        } else {
            ZStack {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    //.scaleEffect(2)
            }
        }
    }
    
}

struct LoadItemsView_Previews: PreviewProvider {
    static var previews: some View {
        LoadItemsView(showScanningResults: .constant(true), nothingFound: .constant(false))
    }
}
