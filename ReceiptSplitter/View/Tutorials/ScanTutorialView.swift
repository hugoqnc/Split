//
//  TutorialView.swift
//  ReceiptSplitter
//
//  Created by Hugo Queinnec on 20/01/2022.
//

import SwiftUI

struct ScanTutorialView: View {
    @EnvironmentObject var model: ModelData
    
    var body: some View {
        
        VStack {
            
            if !model.parameters.bigRecognition {
                VStack {
                    Image("receipt_tutorial")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding()
                        .frame(maxHeight: 300)
                    
                    Button {
                        withAnimation() {
                            model.parameters.bigRecognition = true
                        }
                    } label: {
                        HStack {
                            Image(systemName: "wand.and.stars")
                                .font(.title2)
                                .padding(2)
                            VStack(alignment: .leading) {
                                Text("**Advanced Recognition** is **off**")
                                Text("Tap to enable once.\nChange the default in settings.")
                                    .font(.caption2)
                            }
                            .multilineTextAlignment(.leading)
                        }
                    }
                    .buttonStyle(.bordered)
                    .tint(.teal)
                    .padding(.bottom, 7)
                    
                    VStack(alignment: .leading) {
                        HStack(alignment: .center) {
                            Image(systemName: "viewfinder")
                                .frame(width: 30, height: 30)
                                .font(.largeTitle)
                                .foregroundColor(.yellow)
                                .padding()

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
                }
                .transition(.move(edge: .bottom))

            } else {
                VStack {
                    Image("receipt_tutorial_AR")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding()
                        .frame(maxHeight: 300)
                    
                    Button {
                        withAnimation() {
                            model.parameters.bigRecognition = false
                        }
                    } label: {
                        HStack {
                            Image(systemName: "wand.and.stars")
                                .font(.title2)
                                .padding(2)
                            VStack(alignment: .leading) {
                                Text("**Advanced Recognition** is **on**!")
                                Text("Tap to disable once.\nChange the default in settings.")
                                    .font(.caption2)
                            }
                            .multilineTextAlignment(.leading)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.teal)
                    .padding(.bottom, 7)
                    
                    VStack(alignment: .leading) {
                        HStack(alignment: .center) {
                            Image(systemName: "viewfinder")
                                .frame(width: 30, height: 30)
                                .font(.largeTitle)
                                .foregroundColor(.yellow)
                                .padding()

                            VStack(alignment: .leading, spacing: 2) {
                                Text("Scan the whole receipt")
                                    .font(.headline)
                                    .foregroundColor(.primary)

                                Text("Advanced Recognition automatically identifies your items, and compares them to the total price")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            
                        }

                        
                        HStack(alignment: .center) {
                            Image(systemName: "rectangle.split.2x1.slash")
                                .frame(width: 30, height: 30)
                                .rotationEffect(.degrees(90.0))
                                .font(.largeTitle)
                                .foregroundColor(.yellow)
                                .padding()

                            VStack(alignment: .leading, spacing: 2) {
                                Text("Do not split")
                                    .font(.headline)
                                    .foregroundColor(.primary)

                                Text("Make only one scan per receipt")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }
                }
                .transition(.move(edge: .bottom))
            }

        }
        .frame(maxWidth: 300)
        

    }
}

struct TutorialView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewWrapper()
    }
    struct PreviewWrapper: View {
        @State private var show = true

        var body: some View {
            Text("test")
                .slideOverCard(isPresented: $show, content: {
                    ScanTutorialView()
                })
                .onTapGesture {
                    show=true
                }
        }
    }
}
