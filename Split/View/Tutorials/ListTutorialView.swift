//
//  ListTutorialView.swift
//  Split
//
//  Created by Hugo Queinnec on 21/01/2022.
//

import SwiftUI

struct ListTutorialView: View {
    @Binding var advancedRecognition: Bool
    
    var body: some View {
        VStack {
            
            if advancedRecognition {
                VStack(alignment: .leading) {
                    HStack(alignment: .center) {
                        Image(systemName: "text.magnifyingglass")
                            .frame(width: 30, height: 30)
                            .font(.largeTitle)
                            .foregroundColor(.accentColor)
                            .padding()

                        VStack(alignment: .leading, spacing: 2) {
                            Text("Check the total")
                                .font(.headline)
                                .foregroundColor(.primary)

                            Text("With Advanced Recognition, if the total of the receipt is correct, then all prices are correct")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        
                    }
                    
                    HStack(alignment: .center) {
                        Image(systemName: "pencil")
                            .frame(width: 30, height: 30)
                            .font(.largeTitle)
                            .foregroundColor(.accentColor)
                            .padding()

                        VStack(alignment: .leading, spacing: 2) {
                            Text("Edit small mistakes")
                                .font(.headline)
                                .foregroundColor(.primary)

                            Text("Some product names may be missing or misattributed, they can be changed")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    
                        HStack(alignment: .center) {
                            Image(systemName: "goforward")
                                .frame(width: 30, height: 30)
                                .font(.largeTitle)
                                .foregroundColor(.accentColor)
                                .padding()

                            VStack(alignment: .leading, spacing: 2) {
                                Text("Start again if necessary")
                                    .font(.headline)
                                    .foregroundColor(.primary)

                                Text("If the recognition does not provide good results, try again")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }

                    
                }

            } else {
                VStack(alignment: .leading) {
                    HStack(alignment: .center) {
                        Image(systemName: "text.magnifyingglass")
                            .frame(width: 30, height: 30)
                            .font(.largeTitle)
                            .foregroundColor(.accentColor)
                            .padding()

                        VStack(alignment: .leading, spacing: 2) {
                            Text("Check transactions")
                                .font(.headline)
                                .foregroundColor(.primary)

                            Text("Verify if most of the transactions have been correctly detected")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        
                    }
                    
                    HStack(alignment: .center) {
                        Image(systemName: "pencil")
                            .frame(width: 30, height: 30)
                            .font(.largeTitle)
                            .foregroundColor(.accentColor)
                            .padding()

                        VStack(alignment: .leading, spacing: 2) {
                            Text("Edit small mistakes")
                                .font(.headline)
                                .foregroundColor(.primary)

                            Text("You can add new items, delete existing ones or change their names and prices")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    
                        HStack(alignment: .center) {
                            Image(systemName: "goforward")
                                .frame(width: 30, height: 30)
                                .font(.largeTitle)
                                .foregroundColor(.accentColor)
                                .padding()

                            VStack(alignment: .leading, spacing: 2) {
                                Text("Start again if necessary")
                                    .font(.headline)
                                    .foregroundColor(.primary)

                                Text("If the recognition does not provide good results, try again")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                        
                        Divider()
                            .padding(.vertical)
                        
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
            }
        }
        .frame(maxWidth: 300)
        

    }
}

struct ListTutorialView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewWrapper()
    }
    struct PreviewWrapper: View {
        @State private var show = true

        var body: some View {
            Text("test")
                .slideOverCard(isPresented: $show, content: {
                    ListTutorialView(advancedRecognition: .constant(false))
                })
                .onTapGesture {
                    show=true
                }
        }
    }
}
