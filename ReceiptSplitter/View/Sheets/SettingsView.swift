//
//  SettingsView.swift
//  ReceiptSplitter
//
//  Created by Hugo Queinnec on 24/02/2022.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationView {
            VStack {
                Form { //TODO: change colors because of transparency
                    Section {
                        Toggle("Always show \"Scan\" tutorial", isOn: .constant(true))
                        Toggle("Always show \"Edition\" tutorial", isOn: .constant(true))
                    } header: {
                        Text("Tutorials")
                    }
                    .listRowBackground(Color.secondary.opacity(0.1))
                    
                    Section {
                        Button {
                            //reset default
                        } label: {
                            Label("Send me an email!", systemImage: "envelope")
                        }
                    } header: {
                        Text("Contact")
                    } footer: {
                        Text("Tell me about an issue with the app, or suggest me an idea for a new feature.")
                    }
                    .listRowBackground(Color.secondary.opacity(0.1))

                    Section {
                        HStack {
                            Text("Multiplicative Height Epsilon")
                            Spacer()
                            TextField("", value: .constant(0.5), format: .number)
                                .textFieldStyle(.roundedBorder)
                                .keyboardType(.decimalPad)
                                .frame(width: 55)
                                .foregroundColor(.accentColor)
                        }
                        HStack {
                            Text("Minimum Area Coverage")
                            Spacer()
                            TextField("", value: .constant(0.53), format: .number)
                                .textFieldStyle(.roundedBorder)
                                .keyboardType(.decimalPad)
                                .frame(width: 55)
                                .foregroundColor(.accentColor)
                        }
                        HStack {
                            Text("Maximum Margin")
                            Spacer()
                            TextField("", value: .constant(1.3), format: .number)
                                .textFieldStyle(.roundedBorder)
                                .keyboardType(.decimalPad)
                                .frame(width: 55)
                                .foregroundColor(.accentColor)
                        }
                        
                        Button {
                            //reset default
                        } label: {
                            Label("Reset Advanced Parameters", systemImage: "gobackward")
                        }

                    } header: {
                        Text("Advanced")
                    } footer: {
                        VStack(alignment: .leading, spacing: 3) {
                            Text("Do not modify these parameters if you don't know what you do!")
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Multiplicative Height Epsilon: ")
                                Text("Minimum Area Coverage: ")
                                Text("Maximum Margin: ")
                            }
                            .padding(.leading, 10)
                        } //TODO: precise what each parameter does
                        
                    }
                    .listRowBackground(Color.secondary.opacity(0.1))
                }
            }
            .navigationTitle("Settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
