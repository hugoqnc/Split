//
//  SettingsView.swift
//  ReceiptSplitter
//
//  Created by Hugo Queinnec on 24/02/2022.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.dismiss) var dismiss
    @State var visionParameters = Parameters().visionParameters
    @State var showScanTutorial = Parameters().showScanTutorial
    @State var showEditTutorial = Parameters().showEditTutorial
    //@FocusState var isKeyboardShown: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                Form { //TODO: change colors because of transparency
                    Section {
                        Toggle("Always show \"Scan\" tutorial", isOn: $showScanTutorial)
                        Toggle("Always show \"Edition\" tutorial", isOn: $showEditTutorial)
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
                        .buttonStyle(.borderless)
                    } header: {
                        Text("Contact")
                    } footer: {
                        Text("Tell me about an issue with the app, or suggest me an idea for a new feature!")
                    }
                    .listRowBackground(Color.secondary.opacity(0.1))

                    Section {
                        HStack {
                            VStack(alignment: .leading, spacing: 3) {
                                Text("Multiplicative Height Epsilon")
                                    .padding(.top,3)
                                Text("Between 0 and 1")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            TextField("", value: $visionParameters.epsilonHeight, format: .number)
                                .textFieldStyle(.roundedBorder)
                                .keyboardType(.decimalPad)
                                .frame(width: 55)
                                .foregroundColor(.accentColor)
                                //.focused($isKeyboardShown)
                        }
                        HStack {
                            VStack(alignment: .leading, spacing: 3) {
                                Text("Minimum Area Coverage")
                                    .padding(.top,3)
                                Text("Between 0 and 1")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            TextField("", value: $visionParameters.minAreaCoverage, format: .number)
                                .textFieldStyle(.roundedBorder)
                                .keyboardType(.decimalPad)
                                .frame(width: 55)
                                .foregroundColor(.accentColor)
                                //.focused($isKeyboardShown)
                        }
                        HStack {
                            VStack(alignment: .leading, spacing: 3) {
                                Text("Maximum Margin")
                                    .padding(.top,3)
                                Text("Between 0 and 1")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            TextField("", value: $visionParameters.maxMargin, format: .number)
                                .textFieldStyle(.roundedBorder)
                                .keyboardType(.decimalPad)
                                .frame(width: 55)
                                .foregroundColor(.accentColor)
                                //.focused($isKeyboardShown)
                        }
                        
                        Button {
                            withAnimation() {
                                visionParameters = Parameters().visionParameters
                            }
                        } label: {
                            Label("Reset Advanced Parameters", systemImage: "gobackward")
                        }
                        .buttonStyle(.borderless)

                    } header: {
                        Text("Advanced (image recognition)")
                    } footer: {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Do not modify these parameters if you don't know what you do!")
                            VStack(alignment: .leading, spacing: 4) {
                                Label("Multiplicative Height Epsilon: \"accepted\" lines of the receipt have a median height more or less this value in percentage", systemImage: "plus.forwardslash.minus")
                                Label("Minimum Area Coverage: minimum overlap percentage between the \"text rectangle\" extended on the right and the \"price rectangle\"", systemImage: "rectangle.on.rectangle")
                                Label("Maximum Margin: \"accepted\" lines of the receipt protrude to the left and right outside the margins defined by this percentage", systemImage: "arrow.left.and.right")
                            }
                        } //TODO: precise what each parameter does
                        
                    }
                    .listRowBackground(Color.secondary.opacity(0.1))
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        ParametersStore.save(parameters: Parameters(showScanTutorial: showScanTutorial, showEditTutorial: showEditTutorial, visionParameters: visionParameters)) { result in
                            switch result {
                            case .failure(let error):
                                fatalError(error.localizedDescription)
                            case .success(_):
                                print("Settings Saved")
                            }
                        }
                        
                        dismiss()
                    } label: {
                        Text("Done")
                    }
                }
                ToolbarItem(placement: .keyboard) {
                    Button {
                        //isKeyboardShown = false
                    } label: {
                        Text("OK")
                    }
                }
            }
        }
        .interactiveDismissDisabled()
        .onAppear {
            ParametersStore.load { result in
                switch result {
                case .failure(let error):
                    fatalError(error.localizedDescription)
                case .success(let parameters):
                    visionParameters = parameters.visionParameters
                    showScanTutorial = parameters.showScanTutorial
                    showEditTutorial = parameters.showEditTutorial
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .onAppear {
                UITableView.appearance().backgroundColor = .clear
            }
    }
}
