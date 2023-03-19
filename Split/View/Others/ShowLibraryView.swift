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
    
    @State private var nothingFound = false
    @State private var showResults = false
    @State private var showingImagePicker = false
    
    var body: some View {
        if showResults {
            FirstListView(showScanningResults: $showResults, nothingFound: $nothingFound)
        } else {
            Group {
                Text("")
                    .sheet(isPresented: $showingImagePicker) {
                        ImagePicker(images: $selectedImages) {
                            withAnimation() {
                                model.eraseModelData(eraseScanFails: false)
                            }
                        } onDone: {
                            let textRecognitionFunctions = TextRecognitionFunctions(model: model, recognizedContent: recognizedContent)
                            textRecognitionFunctions.fillInModel(images: selectedImages) { nothing in
                                nothingFound = nothing
                            }
                            showResults = true
                        }
                    }
            }
            .onAppear {
                let secondsToDelay = 0.3
                DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
                    showingImagePicker = true // if the user comes back because it didin't work, the picker should be open
                }
            }
        }
    }
}

struct ShowLibraryView_Previews: PreviewProvider {
    static var previews: some View {
        ShowLibraryView()
    }
}
