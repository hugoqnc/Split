//
//  TipTaxParametersView.swift
//  Split
//
//  Created by Hugo Queinnec on 25/03/2023.
//

import SwiftUI

struct TipTaxParametersView: View {
    @Binding var parameters: Parameters
    @FocusState var isKeyboardShown: Bool

    
    var body: some View {
        VStack {
            Form {
                Section {
                    VStack(alignment: .leading, spacing: 3) {
                        Text("Predefined tip percentages")
                        Text("The middle one will be the selected default.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        HStack {
                            Spacer()

                            TextField("", value: $parameters.usualTips[0], format: .number)
                                .textFieldStyle(.roundedBorder)
                                .keyboardType(.decimalPad)
                                .frame(width: 55)
                                .foregroundColor(.accentColor)
                                .focused($isKeyboardShown)
                                .padding(5)
                            
                            TextField("", value: $parameters.usualTips[1], format: .number)
                                .textFieldStyle(.roundedBorder)
                                .keyboardType(.decimalPad)
                                .frame(width: 55)
                                .foregroundColor(.accentColor)
                                .focused($isKeyboardShown)
                                .padding(5)
                            
                            TextField("", value: $parameters.usualTips[2], format: .number)
                                .textFieldStyle(.roundedBorder)
                                .keyboardType(.decimalPad)
                                .frame(width: 55)
                                .foregroundColor(.accentColor)
                                .focused($isKeyboardShown)
                                .padding(5)
                            
                            Spacer()
                        }
                        .padding(.top,5)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Default tip sharing method")
                        Picker("", selection: $parameters.defaultTipEvenly) {
                            Text("Share evenly").tag(true)
                            Text("Share proportionally").tag(false)
                        }
                        .pickerStyle(.segmented)
                        .padding(.vertical, 3)
                    }
                    
                } header: {
                    Text("Tips")
                }
                
                Section {
                    HStack {
                        Text("Default tax percentage")
                        Spacer()
                        TextField("", value: $parameters.defaultTaxRate, format: .number)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.decimalPad)
                            .frame(width: 55)
                            .foregroundColor(.accentColor)
                            .focused($isKeyboardShown)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Default tax sharing method")
                        Picker("", selection: $parameters.defaultTaxEvenly) {
                            Text("Share evenly").tag(true)
                            Text("Share proportionally").tag(false)
                        }
                        .pickerStyle(.segmented)
                        .padding(.vertical, 3)
                    }

                } header: {
                    Text("Taxes")
                }
            }
        }
        .navigationTitle("Tip and tax parameters")
        .navigationViewStyle(.stack)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                Button {
                    isKeyboardShown = false
                } label: {
                    Text("OK")
                }
            }
        }
    }
}

struct TipTaxParametersView_Previews: PreviewProvider {
    static var previews: some View {
        TipTaxParametersView(parameters: .constant(Parameters.default))
    }
}
