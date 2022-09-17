//
//  TricountDisclaimerSheet.swift
//  Split
//
//  Created by Hugo Queinnec on 16/09/2022.
//

import SwiftUI

struct TricountDisclaimerSheet: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    
                    HStack(alignment: .center) {
                        Image(systemName: "plus.forwardslash.minus")
                            .frame(width: 30, height: 30)
                            .font(.largeTitle)
                            .foregroundColor(.primary)
                            .padding()
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Information about using Tricount's services")
                                .font(.headline)
                                .foregroundColor(.primary)
            
                        }
                    }
                    //.padding(.top)
                    .padding(.horizontal, 30)
                    .padding(.bottom)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Label("Non-Affiliation Disclaimer", systemImage: "exclamationmark.triangle")
                            .font(.headline)
                        Text("""
    This app is not affiliated, associated, authorized, endorsed by, or in any way officially connected with TRICOUNT S.A., or any of its subsidiaries or its affiliates. The official Tricount website can be found at https://www.tricount.com/.
    The name \"Tricount\" as well as related names, marks, emblems and images are registered trademarks of their respective owners.
    """)
                        .font(.footnote)
                        .padding(.bottom, 15)
                        
                        Label("Terms of Use", systemImage: "hand.tap")
                            .font(.headline)
                        Text("""
    By using Tricount's services in this app, you agree to the Tricount Terms of Use, which can be found at https://www.tricount.com/en/terms. Tricount is free to modify these terms at any time and without prior notice.
    """)
                        .font(.footnote)
                        .padding(.bottom, 15)
                        
                        Label("Privacy Policy", systemImage: "hand.raised")
                            .font(.headline)
                        Text("""
    By using Tricount's services in this app, some of your information may be processed by Tricount as described in their privacy policy, which can be found at https://www.tricount.com/en/privacy-policy.
    """)
                        .font(.footnote)
                        .padding(.bottom, 15)
                        
                        Label("Technical Details", systemImage: "wrench.and.screwdriver")
                            .font(.headline)
                        Text("""
    The Tricount services in this app are not provided by the Tricount API, but are made possible by an open-source auto-completion algorithm on the Tricount website, running in the background. The code can be found [here](https://github.com/hugoqnc/Split/blob/main/Split/Model/Tricount.swift).
    The service \"Export to Tricount\" in this app is provided as is, and Split! disclaims any warranty of its operation.
    """)
                        .font(.footnote)
                        .padding(.bottom, 15)
                    }
                    
                    Spacer()
                }
                .padding()
                .padding(.horizontal, 10)
            }
            .navigationBarTitle("", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Close")
                    }
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}

struct TricountDisclaimerSheet_Previews: PreviewProvider {
    static var previews: some View {
        TricountDisclaimerSheet()
    }
}
