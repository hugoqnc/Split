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
                    if model.parameters.bigRecognition {
                        NoMatchFound()
                        Button {
                            model.eraseScanData()
                            nothingFound = false
                            withAnimation() {
                                showScanningResults = false
                            }
                            
                        } label: {
                            HStack {
                                Image(systemName: "arrow.clockwise")
                                VStack(alignment: .leading) {
                                    Text("Try again")
                                    Text("with **Advanced Recognition**")
                                        .font(.caption)
                                        .multilineTextAlignment(.leading)
                                }
                                Spacer()
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .padding(.horizontal, 40)
                        .padding(.bottom,5)
                        .padding(.top,5)
                        
                        Button {
                            model.eraseScanData()
                            model.parameters.bigRecognition = false
                            model.parameters.showScanTutorial = true
                            nothingFound = false
                            withAnimation() {
                                showScanningResults = false
                            }
                            
                        } label: {
                            HStack {
                                Image(systemName: "arrow.clockwise")
                                VStack(alignment: .leading) {
                                    Text("Try again")
                                    Text("and disable **Advanced Recognition** for this scan")
                                        .font(.caption)
                                        .multilineTextAlignment(.leading)
                                }
                                Spacer()
                            }
                            //Label("Try and disable Advanced Recognition once", systemImage: "arrow.clockwise")
                        }
                        .buttonStyle(.bordered)
                        .padding(.horizontal, 40)
                        .padding(.bottom,10)
                        //.foregroundColor(.secondary)
                        
                    } else {
                        NoItemFound()
                        
                        Button {
                            model.eraseScanData()
                            nothingFound = false
                            withAnimation() {
                                showScanningResults = false
                            }
                            
                        } label: {
                            Label("Try again", systemImage: "arrow.clockwise")
                        }
                        .buttonStyle(.bordered)
                        .padding(.bottom,10)
                        .padding(.top,5)
                    }
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
        LoadItemsView(showScanningResults: .constant(true), nothingFound: .constant(true))
            .environmentObject(ModelData())
    }
}
