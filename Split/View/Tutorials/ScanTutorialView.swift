//
//  TutorialView.swift
//  Split
//
//  Created by Hugo Queinnec on 20/01/2022.
//

import SwiftUI
import SlideOverCard

struct ScanTutorialView: View {
    @Binding var advancedRecognition: Bool
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        VStack {
            
            if !advancedRecognition {
                VStack {
                    Image("receipt_tutorial")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding()
                        .frame(maxHeight: 300)
                    
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

                                Text("Scan the items and their prices, not what is above or below")
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

                                Text("Scan a long receipt in multiple times, but make sure not to scan the same item twice")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }
                }
                .transition(.move(edge: .top))

            } else {
                VStack {
                    Image("receipt_tutorial_AR")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding()
                        .frame(maxHeight: 300)

                    
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

                                Text("Advanced Recognition identifies your items, and compares them to the total price")
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
                
            }
            
            ZStack {
                VStack(alignment: .leading, spacing: 3) {
                    Toggle(isOn: $advancedRecognition) {
                        Text("Advanced Recognition")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .brightness(colorScheme == .dark ? advancedRecognition ? 0.2 : -0.2 : advancedRecognition ? -0.2 : 0.2)
                    }
                    .padding(.horizontal,2)
                    
                    HStack {
                        Image(systemName: "wand.and.stars")
                            .font(.title2)
                            .padding(2)
                        Text("Scan your receipt in one tap.\nNo manual editing, no mistakes.\nChange the default in settings.")
                            .font(.caption2)
                    }
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal,3)
                    .brightness(colorScheme == .dark ? advancedRecognition ? 0.2 : -0.2 : advancedRecognition ? -0.2 : 0.2)
                    
                }
                .padding(10)
                .foregroundColor(advancedRecognition ? .teal : .secondary)
            }
            .background((advancedRecognition ? Color.teal : Color.secondary).opacity(0.1))
            .tint(.teal)
            .cornerRadius(10)
            .padding(.vertical,5)
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
        @State private var toggle = true

        var body: some View {
            Text("test")
                .slideOverCard(isPresented: $show, content: {
                    VStack{
                        ScanTutorialView(advancedRecognition: $toggle)
                    }
                })
                .onTapGesture {
                    show=true
                }
        }
    }
}
