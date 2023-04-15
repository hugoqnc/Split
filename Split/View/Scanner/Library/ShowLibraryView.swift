//
//  ShowLibraryView.swift
//  Split
//
//  Created by Hugo Queinnec on 19/03/2023.
//

import SwiftUI
import PhotosUI

struct ShowLibraryView: View {
    @EnvironmentObject var model: ModelData
    @ObservedObject var recognizedContent = TextData()
    
    @State private var selectedImages: [UIImage] = []
    
    @Binding var nothingFound: Bool
    @Binding var showResults: Bool
    @Binding var showSheet: Bool
    
    @State private var showTutorialScreen = false
    
    var body: some View {
            ImagePicker(images: $selectedImages) {
                withAnimation() {
                    model.eraseModelData(eraseScanFails: false, fast: true)
                }
            } onDone: {
                let textRecognitionFunctions = TextRecognitionFunctions(model: model, recognizedContent: recognizedContent)
                textRecognitionFunctions.fillInModel(images: selectedImages) { nothing in
                    nothingFound = nothing
                }
                withAnimation() {
                    showResults = true
                    showSheet = false
                }
            }
            .onAppear {
                selectedImages = [] // re-initialize when the user goes back to this interface after having cancelled the next step
            }
            .onAppear(perform: {
                let secondsToDelay = 0.6
                DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
                    showTutorialScreen = model.parameters.showLibraryTutorial
                }
            })
            .slideOverCard(isPresented: $showTutorialScreen, content: {
                VStack {
                    LibraryTutorialView(advancedRecognition: $model.parameters.advancedRecognition)
                    Button {
                        showTutorialScreen = false
                        model.parameters.showLibraryTutorial = false
                        ParametersStore.save(parameters: model.parameters) { result in
                            switch result {
                            case .failure(let error):
                                fatalError(error.localizedDescription)
                            case .success(_):
                                print("Settings Saved")
                            }
                        }
                    } label: {
                        Text("OK, do not show again")
                            .font(Font.footnote)
                    }
                    .padding(.top,10)
                }
            })
            .ignoresSafeArea(.all)
    }
}

struct ShowLibraryView_Previews: PreviewProvider {
    static var previews: some View {
        ShowLibraryView(nothingFound: .constant(false), showResults: .constant(false), showSheet: .constant(false))
            .environmentObject(ModelData())
    }
}
