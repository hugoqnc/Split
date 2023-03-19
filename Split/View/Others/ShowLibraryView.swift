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
    //@State private var showingImagePicker = false
    
    var body: some View {
        if showResults {
            FirstListView(showScanningResults: $showResults, nothingFound: $nothingFound)
        } else {
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
            .onAppear {
                selectedImages = [] // re-initialize when the user goes back to this interface after having cancelled the next step
            }
            .ignoresSafeArea()
        }
    }
}

struct ShowLibraryView_Previews: PreviewProvider {
    static var previews: some View {
        ShowLibraryView()
    }
}
