//
//  AdvancedParametersView.swift
//  ReceiptSplitter
//
//  Created by Hugo Queinnec on 10/03/2022.
//

import SwiftUI

struct AdvancedParametersView: View {
    @Binding var parameters: Parameters
    @FocusState var isKeyboardShown: Bool
    
    var body: some View {
        VStack {
            Form {
                Section {
                    HStack {
                        VStack(alignment: .leading, spacing: 3) {
                            Text("Multiplicative Height Epsilon")
                                .padding(.top,3)
                            Text("From 0 to 1")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        TextField("", value: $parameters.visionParameters.epsilonHeight, format: .number)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.decimalPad)
                            .frame(width: 55)
                            .foregroundColor(.accentColor)
                            .focused($isKeyboardShown)
                    }
                    HStack {
                        VStack(alignment: .leading, spacing: 3) {
                            Text("Minimum Area Coverage")
                                .padding(.top,3)
                            Text("From 0 to 1")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        TextField("", value: $parameters.visionParameters.minAreaCoverage, format: .number)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.decimalPad)
                            .frame(width: 55)
                            .foregroundColor(.accentColor)
                            .focused($isKeyboardShown)
                    }
                    HStack {
                        VStack(alignment: .leading, spacing: 3) {
                            Text("Maximum Margin")
                                .padding(.top,3)
                            Text("From 0 to 1")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        TextField("", value: $parameters.visionParameters.maxMargin, format: .number)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.decimalPad)
                            .frame(width: 55)
                            .foregroundColor(.accentColor)
                            .focused($isKeyboardShown)
                    }
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 3) {
                            Text("Multiplicative Height Epsilon")
                                .padding(.top,3)
                            Text("**Advanced Recognition** — From 0 to 1")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        TextField("", value: $parameters.visionParameters.epsilonHeightAR, format: .number)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.decimalPad)
                            .frame(width: 55)
                            .foregroundColor(.accentColor)
                            .focused($isKeyboardShown)
                    }
                    HStack {
                        VStack(alignment: .leading, spacing: 3) {
                            Text("Minimum Area Coverage")
                                .padding(.top,3)
                            Text("**Advanced Recognition** — From 0 to 1")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        TextField("", value: $parameters.visionParameters.minAreaCoverageAR, format: .number)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.decimalPad)
                            .frame(width: 55)
                            .foregroundColor(.accentColor)
                            .focused($isKeyboardShown)
                    }
                    HStack {
                        VStack(alignment: .leading, spacing: 3) {
                            Text("Price Right Margin")
                                .padding(.top,3)
                            Text("**Advanced Recognition** — From 0 to 1")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        TextField("", value: $parameters.visionParameters.priceMarginRight, format: .number)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.decimalPad)
                            .frame(width: 55)
                            .foregroundColor(.accentColor)
                            .focused($isKeyboardShown)
                    }
                    HStack {
                        VStack(alignment: .leading, spacing: 3) {
                            Text("Total Bottom Proportion")
                                .padding(.top,3)
                            Text("**Advanced Recognition** — From 0 to 1")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        TextField("", value: $parameters.visionParameters.proportionWithTotal, format: .number)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.decimalPad)
                            .frame(width: 55)
                            .foregroundColor(.accentColor)
                            .focused($isKeyboardShown)
                    }
                    HStack {
                        VStack(alignment: .leading, spacing: 3) {
                            Text("Contrast Factor")
                                .padding(.top,3)
                            Text("**Advanced Recognition** — From 1 to ∞")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        TextField("", value: $parameters.visionParameters.contrastFactor, format: .number)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.decimalPad)
                            .frame(width: 55)
                            .foregroundColor(.accentColor)
                            .focused($isKeyboardShown)
                    }
                    HStack {
                        VStack(alignment: .leading, spacing: 3) {
                            Text("Minimum Text Height")
                                .padding(.top,3)
                            Text("**Advanced Recognition** — From 0 to 1")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        TextField("", value: $parameters.visionParameters.minimumTextHeight, format: .number)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.decimalPad)
                            .frame(width: 65)
                            .foregroundColor(.accentColor)
                            .focused($isKeyboardShown)
                    }
                    
                    Button {
                        withAnimation() {
                            parameters.visionParameters = Parameters().visionParameters
                        }
                    } label: {
                        Label("Reset Advanced Parameters", systemImage: "gobackward")
                    }
                    .buttonStyle(.borderless)

                } header: {
                    Text("Image Recognition")
                } footer: {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Do not modify these parameters if you don't understand what you do!")
                        VStack(alignment: .leading, spacing: 4) {
                            Label("**Multiplicative Height Epsilon**: *accepted* lines of the receipt have a median height more or less this value in percentage.", systemImage: "plus.forwardslash.minus")
                            Label("**Minimum Area Coverage**: minimum overlap percentage between the *text rectangle* extended on the right and the *price rectangle*.", systemImage: "rectangle.on.rectangle")
                            Label("**Maximum Margin**: *accepted* lines of the receipt protrude to the left and right outside the margins defined by this percentage.", systemImage: "arrow.left.and.right")
                            Label("**Price Right Margin**: proportion right of the receipt containing the price column.", systemImage: "dollarsign.circle")
                            Label("**Total Bottom Proportion**: bottom proportion which contains the total price of the receipt.", systemImage: "sum")
                            Label("**Contrast Factor**: increases the contrast of the black and white scan.", systemImage: "circle.lefthalf.filled")
                            Label("**Minimum Text Height**: percentage of font size over the height of the receipt.", systemImage: "textformat.size")
                            
                        }
                    }
                    
                }
                .listRowBackground(Color.secondary.opacity(0.1))
            }
        }
        //.navigationBarHidden(true)
        .navigationTitle("Advanced Parameters")
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

struct AdvancedParametersView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            AdvancedParametersView(parameters: .constant(Parameters()))
        }
    }
}
