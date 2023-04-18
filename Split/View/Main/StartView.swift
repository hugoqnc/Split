//
//  StartView.swift
//  Split
//
//  Created by Hugo Queinnec on 04/01/2022.
//

import SwiftUI

struct StartView: View {

    @EnvironmentObject var model: ModelData
    @ObservedObject var recognizedContent = TextData()
    @Environment(\.horizontalSizeClass) var horizontalSizeClass //for iPad specificity
    
    @State private var names: [String] = []
    @State private var currencyType = Currency.default.symbol
    @State private var showAlert1 = false
    @State private var showAlert2 = false
    @State private var showAlert3 = false
    @State private var showSettings = false
    @State private var showHistoryView = false
    @State private var showFavoriteView = false
    @State var photoLibrarySheet = false
    @State var filesSheet = false
    
    // Results of image recognition from library or files
    @State private var showResults = false
    @State private var nothingFound = false
        
    @State private var newUserName: String = ""
        
    var body: some View {
        
        if model.startTheProcess && !model.photoIsImported {
            ShowScannerView()
        } else if model.startTheProcess && model.photoIsImported && showResults {
            FirstListView(showScanningResults: $showResults, nothingFound: $nothingFound)
        } else {
            
            let formDetails = FormDetailsView(names: $names, newUserName: $newUserName, currencyType: $currencyType, showAlert1: $showAlert1, showAlert2: $showAlert2)
            
            NavigationView {
                VStack{
                    NavigationLink(destination: HistoryView(showHistoryView: $showHistoryView), isActive: $showHistoryView) { EmptyView() }
                        .isDetailLink(false)
                        .navigationViewStyle(.stack)
                    
                    Form {
                        Section {
                            EmptyView()
                            //to fix this bug: https://www.hackingwithswift.com/forums/swiftui/issues-with-list-section-headers-in-ios-15/9891
                        }
                        
                        Section {
                            FillFavoriteButton(names: $names, newUserName: $newUserName, currencyType: $currencyType, update: $showFavoriteView)
                            EditFavoriteButton(showFavoriteView: $showFavoriteView)
                        } header: {
                            //Text("Favorites")
                        }
                        
                        
                        formDetails
                        
                    }
                }
                .toolbar {
                    ToolbarItemGroup(placement: .bottomBar) {
                        Spacer()
                        
                        Group {
                            Button {
                                let ok = formDetails.isFinalUsersCorrect()
                                if ok {
                                    showResults = false
                                    ParametersStore.load { result in
                                        switch result {
                                        case .failure(let error):
                                            fatalError(error.localizedDescription)
                                        case .success(let parameters):
                                            model.parameters = parameters
                                        }
                                    }
                                    for name in names{
                                        model.users.append(User(name: name))
                                    }
                                    model.currency = Currency(symbol: currencyType)
                                    withAnimation() {
                                        model.photoIsImported = true
                                        model.startTheProcess = true
                                        filesSheet = true
                                    }
                                }
                            } label: {
                                StartCustomButtons(role: "files")
                            }
                            .fileImporter(
                                isPresented: $filesSheet,
                                allowedContentTypes: [.image],
                                allowsMultipleSelection: true
                            ) { result in
                                do {
                                    var selectedImages: [UIImage] = []
                                    let selectedFiles: [URL] = try result.get()
                                    for selectedFile in selectedFiles {
                                        guard selectedFile.startAccessingSecurityScopedResource() else { return }
                                        
                                        if let imageData = try? Data(contentsOf: selectedFile),
                                           let image = UIImage(data: imageData) {
                                            selectedImages.append(image)
                                        }
                                        
                                        selectedFile.stopAccessingSecurityScopedResource()
                                    }
//                                    self.selectedImages = selectedImages
                                    
                                    let textRecognitionFunctions = TextRecognitionFunctions(model: model, recognizedContent: recognizedContent)
                                    textRecognitionFunctions.fillInModel(images: selectedImages) { nothing in
                                        nothingFound = nothing
                                    }
                                    withAnimation {
                                        showResults = true
                                        filesSheet = false
                                    }
                                } catch {
                                    Swift.print(error.localizedDescription)
                                }
                            }
                            .onChange(of: filesSheet, perform: { newValue in
                                if !newValue && !showResults { // sheet dismissed because the user has cancelled
                                    withAnimation() {
                                        model.eraseModelData(eraseScanFails: false, fast: true)
                                    }
                                }
                            })
                            
                            Button {
                                let ok = formDetails.isFinalUsersCorrect()
                                if ok {
                                    showResults = false
                                    ParametersStore.load { result in
                                        switch result {
                                        case .failure(let error):
                                            fatalError(error.localizedDescription)
                                        case .success(let parameters):
                                            model.parameters = parameters
                                        }
                                    }
                                    for name in names{
                                        model.users.append(User(name: name))
                                    }
                                    model.currency = Currency(symbol: currencyType)
                                    withAnimation() {
                                        model.photoIsImported = true
                                        model.startTheProcess = true
                                        photoLibrarySheet = true
                                    }
                                }
                            } label: {
                                StartCustomButtons(role: "library")
                            }
                            .sheet(isPresented: $photoLibrarySheet, onDismiss: {
                                if !showResults { // sheet dismissed because the user has cancelled
                                    withAnimation() {
                                        model.eraseModelData(eraseScanFails: false, fast: true)
                                    }
                                }
                            }){
                                ShowLibraryView(nothingFound: $nothingFound, showResults: $showResults, showSheet: $photoLibrarySheet)
                            }

                            if horizontalSizeClass == .compact { // Only appears on iPhone
                                Spacer()
                            }
                            
                            Button {
                                let ok = formDetails.isFinalUsersCorrect()
                                if ok {
                                    ParametersStore.load { result in
                                        switch result {
                                        case .failure(let error):
                                            fatalError(error.localizedDescription)
                                        case .success(let parameters):
                                            model.parameters = parameters
                                        }
                                    }
                                    for name in names{
                                        model.users.append(User(name: name))
                                    }
                                    model.currency = Currency(symbol: currencyType)
                                    withAnimation() {
                                        model.startTheProcess = true
                                    }
                                }
                            } label: {
                                StartCustomButtons(role: "scan")
                            }
                        }
                        .padding(.horizontal, 6)
                        .disabled(names.isEmpty || (!model.startTheProcess && !model.users.isEmpty)) // 2nd case: disabled if the model has not been fully cleaned yet
                        .onTapGesture {
                            if names.isEmpty {
                                showAlert3 = true
                            }
                        }
                        .alert(isPresented: $showAlert3) {
                            Alert(title: Text("No users"), message: Text("Please add the name of at least one user to start"), dismissButton: .default(Text("OK")))
                        }
                        .buttonStyle(.plain)
                        
                        Spacer()
                    }
                    
                    ToolbarItemGroup(placement: .navigationBarTrailing){
                        Button {
                            ParametersStore.load { result in
                                switch result {
                                case .failure(let error):
                                    fatalError(error.localizedDescription)
                                case .success(let parameters):
                                    model.parameters = parameters
                                }
                            }
                            withAnimation() {
                                showHistoryView = true
                            }
                        } label: {
                            Image(systemName: "clock.arrow.circlepath")
                                .frame(height: 96, alignment: .trailing) // because of https://stackoverflow.com/questions/58512344/swiftui-navigation-bar-button-not-clickable-after-sheet-has-been-presented
                        }
                        
                        Button {
                            showSettings = true
                        } label: {
                            Image(systemName: "gear")
                                .frame(height: 96, alignment: .trailing)
                        }
                        .padding(.trailing,10)
                        .sheet(isPresented: $showSettings) {
                            SettingsView()
                        }
                    }
                }
                .navigationTitle("Split!")
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
            .environmentObject(ModelData())
    }
}
