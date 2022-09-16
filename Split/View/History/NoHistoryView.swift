//
//  NoHistoryView.swift
//  Split
//
//  Created by Hugo Queinnec on 27/02/2022.
//

import SwiftUI

struct NoHistoryView: View {
    @Binding var showHistoryView: Bool
    
    var body: some View {
        VStack {
            VStack {
                
                Image(systemName: "clock.arrow.circlepath")
                    .resizable(resizingMode: .stretch)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 33.0, height: 30.0)
                    .font(.largeTitle)
                    .foregroundColor(.green)
                    .padding(.top)
                    .padding(.bottom,5)
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Welcome to your history!")
                            .font(.headline)
                            .foregroundColor(.primary)
                            .fixedSize(horizontal: false, vertical: true)

                        Text("Here will be saved the reports of your receipts. Start by scanning your first receipt to save it here.")
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

                
                Button {
                    showHistoryView = false
                } label: {
                    Label("Back", systemImage: "arrow.left")
                }
                .buttonStyle(.bordered)
                .padding(.bottom,10)
                .padding(.top,5)

            }
            .padding(10)
            .frame(maxWidth: 400)
        }
        .background(Color(uiColor: UIColor.systemBackground).brightness(0.06))
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.2), radius: 15.0)
        .padding()
    }
}

struct NoHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        NoHistoryView(showHistoryView: .constant(true))
    }
}
