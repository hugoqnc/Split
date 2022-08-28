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
    
    @State var addTricountSheet = false
    
    var year: String {
        get {
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy"
            let yearString = dateFormatter.string(from: date)
            return yearString
        }
    }
    
    func descriptiveStringTricount(tricount: Tricount) -> String {
        var text = ""//\(tricount.names.count) | "
            for i in 0..<tricount.names.count {
                text.append(tricount.names[i])
            if i<tricount.names.count-1 {
                text.append(", ")
            }
        }
        return text
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
                                
                                Text("Depending on the type of your receipts, Advanced Recognition can sometimes fail to identify them. If this happens to you often, you can disable it.")
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
                        Menu {
                            Picker("Currency", selection: $parameters.defaultCurrency.symbol.animation()) {
                                ForEach(Currency.SymbolType.allCases, id: \.self, content: { currencyType in
                                    Text(Currency(symbol: currencyType).value)
                                })
                            }
                        } label: {
                            HStack {
                                Text("Default currency symbol")
                                    .foregroundColor(.primary)
                                Spacer()
                                Text("\(Currency(symbol: parameters.defaultCurrency.symbol).value)")
                                    .fontWeight(.semibold)
                                    .padding(.trailing, 5)
                            }
                        }
                        
                        Toggle("Compress saved receipts", isOn: $parameters.compressImages)
                        
                        Toggle("Assign to everyone per default", isOn: $parameters.selectAllUsers)
                    } header: {
                        Text("General")
                    } footer: {
                        parameters.selectAllUsers ? Text("Currently, when assigning items to users, they will **all** be selected by default.") : Text("Currently, when assigning items to users, **no one** will be selected by default.")
                    }
                    .listRowBackground(Color.secondary.opacity(0.1))
                    
                    Section {
                        List {
                            ForEach(parameters.tricountList, id:\.tricountID) { tricount in
                                VStack(alignment: .leading, spacing: 3) {
                                    Text("**\(tricount.tricountName)** – \(tricount.names.count) people")
                                        .lineLimit(1)
                                    Text(descriptiveStringTricount(tricount: tricount))
                                        .font(.subheadline)
                                }
                            }
                            .onDelete { indexSet in
                                withAnimation() {
                                    parameters.tricountList.remove(atOffsets: indexSet)
                                }
                            }
                        }
                        Button {
                            addTricountSheet = true
                            
                            // FOR TESTING PURPOSES
//                            var tricountTest = Tricount()
//                            tricountTest.tricountID = "YYY"
//                            tricountTest.tricountName = "This Is A Very Long Title For Testing"
//                            tricountTest.names = ["Hugo", "Thomas", "Lucas", "Julie", "Mahaut", "Aurélien", "Corentin", "Octave"]
//                            parameters.tricountList.append(tricountTest)
                        } label: {
                            Label("Add a Tricount", systemImage: "plus")
                        }
                    } header: {
                        Text("Tricount")
                    } footer: {
                        Text("Tricount is a free application that you can use with Split! to synchronize and share your expenses with your friends.")
                    }
                    .listRowBackground(Color.secondary.opacity(0.1))
                    .sheet(isPresented: $addTricountSheet) {
                        TricountAddSheet(tricountList: $parameters.tricountList)
                    }
                    
                    Section {
                        Toggle("Always show \"Scan\" tutorial", isOn: $parameters.showScanTutorial)
                        Toggle("Always show \"Edit\" tutorial", isOn: $parameters.showEditTutorial)
                        Toggle("Always show \"Card\" tutorial", isOn: $parameters.showAttributionTutorial)
                    } header: {
                        Text("Tutorials")
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
                        Text("Save")
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
