//
//  UpdateSheet.swift
//  Split
//
//  Created by Hugo Queinnec on 13/04/2023.
//

import SwiftUI

// TO MODIFY AT EACH NEW VERSION
struct UpdateSheet: View {
    
    @Environment(\.dismiss) var dismiss
    
    var titleFont = UIFont.preferredFont(forTextStyle: .largeTitle)
    
    var body: some View {
        
        VStack {
            
            VStack {
                Text("MAJOR UPDATE")
                    .font(.headline)
                    .foregroundColor(.accentColor)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 6)
                    .background(Color.accentColor.opacity(0.15))
                    .clipShape(Capsule())
                
                Group{
                    Text("What's New in ") +
                    Text("Split!").foregroundColor(.accentColor)
                }
                    .font(Font(UIFont(
                        descriptor:
                            titleFont.fontDescriptor
                            .withDesign(.rounded)? /// make rounded
                            .withSymbolicTraits(.traitBold) /// make bold
                            ??
                            titleFont.fontDescriptor, /// return the normal title if customization failed
                        size: titleFont.pointSize
                    )))
            }
            .padding(.top, 50)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    HStack(alignment: .center) {
                        Image(systemName: "photo.on.rectangle.angled")
                            .frame(width: 35, height: 35)
                            .font(.largeTitle)
                            .foregroundColor(.accentColor)
                            .padding()

                        VStack(alignment: .leading, spacing: 2) {
                            Text("Photo import")
                                .font(.headline)
                                .foregroundColor(.primary)

                            Text("Use your receipt photos directly from your photo library or files, without having to scan.")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        
                    }
                    .padding(.top, 40)
                    
                    HStack(alignment: .center) {
                        Image(systemName: "building.columns")
                            .frame(width: 35, height: 35)
                            .font(.largeTitle)
                            .foregroundColor(.green)
                            .padding()

                        VStack(alignment: .leading, spacing: 2) {
                            Text("Tips and taxes")
                                .font(.headline)
                                .foregroundColor(.primary)

                            Text("Easily specify tip and tax percentages to apply to your receipts. Choose whether you want to split them evenly or proportionally to each person's expenses.")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    
                    HStack(alignment: .center) {
                        Image(systemName: "hand.draw")
                            .frame(width: 35, height: 35)
                            .font(.largeTitle)
                            .foregroundColor(.pink)
                            .padding()

                        VStack(alignment: .leading, spacing: 2) {
                            Text("Swipe back")
                                .font(.headline)
                                .foregroundColor(.primary)

                            Text("When assigning items, swipe through the cards to go back and correct a mistake.")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    
                }
                .padding(.horizontal, 30)
            .padding(.trailing, 10)
            }
            
            Spacer()
            
            VStack {
                
                Label("If you like this app, you can support its evolution by giving a tip in the Settings tab", systemImage: "heart")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.bottom, 5)
                    .lineLimit(3)
                
                Button{
                    dismiss()
                } label: {
                    HStack {
                        Spacer()
                        Text("Continue")
                            .font(.headline)
                            .padding(10)
                        Spacer()
                    }
                    
                }
                .buttonStyle(.borderedProminent)
            
            }
            .padding([.horizontal, .bottom], 35)
        }
    }
}

struct UpdateSheet_Previews: PreviewProvider {
    static var previews: some View {
        UpdateSheet()
    }
}
