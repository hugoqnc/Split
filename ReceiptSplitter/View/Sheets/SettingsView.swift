//
//  SettingsView.swift
//  ReceiptSplitter
//
//  Created by Hugo Queinnec on 24/02/2022.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.openURL) var openURL

    @State var parameters = Parameters()
    @FocusState var isKeyboardShown: Bool
    
    var year: String {
        get {
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy"
            let yearString = dateFormatter.string(from: date)
            return yearString
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section {
                        Toggle("Always show \"Scan\" tutorial", isOn: $parameters.showScanTutorial)
                        Toggle("Always show \"Edition\" tutorial", isOn: $parameters.showEditTutorial)
                    } header: {
                        Text("Tutorials")
                    }
                    .listRowBackground(Color.secondary.opacity(0.1))
                    
                    Section {
                        Toggle("Select everyone per default", isOn: $parameters.selectAllUsers)
                    } header: {
                        Text("Attribution")
                    } footer: {
                        parameters.selectAllUsers ? Text("Currently, when assigning items to users, they will **all** be selected by default.") : Text("Currently, when assigning items to users, **no one** will be selected by default.")
                    }
                    .listRowBackground(Color.secondary.opacity(0.1))
                    
                    Section {
                        Button {
                            openURL(URL(string: "mailto:hugo.queinnec@gmail.com?subject=%5BReceiptSplitter%5D%20New%20Request&body=Please%20write%20here%20about%20an%20issue%2C%20or%20suggest%20me%20a%20new%20feature%20I%20should%20add%20to%20ReceiptSplitter.%0D%0AIf%20it%20is%20about%20an%20issue%2C%20first%20make%20sure%20you%20are%20using%20the%20latest%20version%20of%20ReceiptSplitter.%20Then%2C%20specify%20the%20device%20you%20are%20using%2C%20and%20what%20exact%20steps%20led%20to%20the%20bug.")!)
                        } label: {
                            Label("Send me an email!", systemImage: "envelope")
                        }
                        .buttonStyle(.borderless)
                        
                        Button {
                            openURL(URL(string: "https://github.com/hugoqnc/ReceiptSplitter")!)
                        } label: {
                            Label("Project's Github", systemImage: "chevron.left.forwardslash.chevron.right")
                        }
                        .buttonStyle(.borderless)
                    } header: {
                        Text("Contact")
                    } footer: {
                        Text("Tell me about an issue with the app, or suggest me an idea for a new feature! You can also contribute on Github, by submitting an issue or a pull request.")
                    }
                    .listRowBackground(Color.secondary.opacity(0.1))

                    Section {
                        HStack {
                            VStack(alignment: .leading, spacing: 3) {
                                Text("Multiplicative Height Epsilon")
                                    .padding(.top,3)
                                Text("Should be between 0 and 1")
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
                                Text("Should be between 0 and 1")
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
                                Text("Should be between 0 and 1")
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
                        
                        Button {
                            withAnimation() {
                                parameters.visionParameters = Parameters().visionParameters
                            }
                        } label: {
                            Label("Reset Advanced Parameters", systemImage: "gobackward")
                        }
                        .buttonStyle(.borderless)

                    } header: {
                        Text("Advanced — Image Recognition")
                    } footer: {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Do not modify these parameters if you don't understand what you do!")
                            VStack(alignment: .leading, spacing: 4) {
                                Label("**Multiplicative Height Epsilon**: *accepted* lines of the receipt have a median height more or less this value in percentage.", systemImage: "plus.forwardslash.minus")
                                Label("**Minimum Area Coverage**: minimum overlap percentage between the *text rectangle* extended on the right and the *price rectangle*.", systemImage: "rectangle.on.rectangle")
                                Label("**Maximum Margin**: *accepted* lines of the receipt protrude to the left and right outside the margins defined by this percentage.", systemImage: "arrow.left.and.right")
                            }
                        }
                        
                    }
                    .listRowBackground(Color.secondary.opacity(0.1))
                    
                    HStack{
                        Spacer()
                        Text("© \(year) Hugo Queinnec ")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Spacer()
                    }

                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        ParametersStore.save(parameters: self.parameters) { result in
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
                        isKeyboardShown = false
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
                case .failure(_):
                    //fatalError(error.localizedDescription)
                    print("No previous preferences found")
                case .success(let parameters):
                    self.parameters = parameters
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            SettingsView()
                .onAppear {
                    UITableView.appearance().backgroundColor = .clear
            }
        }
    }
}
