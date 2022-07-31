//
//  SettingsView.swift
//  Split
//
//  Created by Hugo Queinnec on 24/02/2022.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.openURL) var openURL
    @Environment(\.colorScheme) var colorScheme
    
    var githubLink = "https://github.com/hugoqnc/Split"

    @State var parameters = Parameters()
    @State private var showSharingOptions = false
    @State var showAdvancedParameters = false
    
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
                        VStack(alignment: .leading, spacing: 3) {
                            Toggle(isOn: $parameters.advancedRecognition) {
                                Text("Advanced Recognition")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .brightness(colorScheme == .dark ? parameters.advancedRecognition ? 0.1 : -0.2 : parameters.advancedRecognition ? -0.1 : 0.2)
                            }
                            .padding(.horizontal,2)
                            .tint(.teal)
                            
                            Group {
                                HStack {
                                    Image(systemName: "wand.and.stars")
                                        .font(.title2)
                                        .padding(2)
                                    VStack(alignment: .leading) {
                                        Text("Scan your receipt in one tap.")
                                        Text("No manual editing, no mistakes.")
                                    }
                                    .font(.caption)
                                }
                                .padding(.bottom,8)
                                
                                Text("Depending on your device, Advanced Recognition can be slower and more energy consuming than standard image recognition. It also may not work with all receipts.")
                                    .font(.caption2)
                            }
                            .multilineTextAlignment(.leading)
                            .padding(.horizontal,3)
                            .brightness(colorScheme == .dark ? parameters.advancedRecognition ? 0.1 : -0.2 : parameters.advancedRecognition ? -0.1 : 0.2)
                        }
                        .padding(.vertical, 5)
                        .foregroundColor(parameters.advancedRecognition ? .teal : .secondary)
                        //.background((parameters.advancedRecognition ? Color.teal : Color.secondary).opacity(0.1))
                        
                        NavigationLink(destination: AdvancedParametersView(parameters: $parameters), isActive: $showAdvancedParameters) { Text("Advanced Parameters") }
                            .navigationViewStyle(.stack)
                        
                    } header: {
                        Text("Image Recognition")
                    }
                    .listRowBackground(Color.secondary.opacity(0.1))
                    
                    Section {
                        Button {
                            
                        } label: {
                            Label("Add a Tricount", systemImage: "plus")
                        }
                    } header: {
                        Text("Tricount")
                    }
                    .listRowBackground(Color.secondary.opacity(0.1))
                    
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
                            showSharingOptions = true
                        } label: {
                            Label("Share this app", systemImage: "square.and.arrow.up")
                        }
                        .buttonStyle(.borderless)
                        .sheet(isPresented: $showSharingOptions, content: {
                            ActivityViewController(activityItems: ["Hey, I use Split! to easily share my receipts, you should check it out: "+githubLink])
                        })
                        
                        Button {
                            openURL(URL(string: "mailto:hugo.queinnec@gmail.com?subject=%5BSplit!%5D%20New%20Request&body=Please%20write%20here%20about%20an%20issue%2C%20or%20suggest%20me%20a%20new%20feature%20I%20should%20add%20to%20Split!.%0D%0AIf%20it%20is%20about%20an%20issue%2C%20first%20make%20sure%20you%20are%20using%20the%20latest%20version%20of%20Split!.%20Then%2C%20specify%20the%20device%20you%20are%20using%2C%20and%20what%20exact%20steps%20led%20to%20the%20bug.")!)
                        } label: {
                            Label("Send me an email!", systemImage: "envelope")
                        }
                        .buttonStyle(.borderless)
                        
                        Button {
                            openURL(URL(string: githubLink)!)
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


                    
                    HStack{
                        Spacer()
                        Text("© \(year) Hugo Queinnec ")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                    .listRowBackground(Color.secondary.opacity(0.0))

                }
            }
//            .sheet(isPresented: $showAdvancedParameters, content: {
//                AdvancedParametersView(parameters: $parameters)
//            })
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
            }
        }
        .interactiveDismissDisabled()
        .onAppear {
            ParametersStore.load { result in
                switch result {
                case .failure(let error):
                    fatalError(error.localizedDescription)
                    //print("No previous preferences found")
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
        //.preferredColorScheme(.dark)
    }
}
