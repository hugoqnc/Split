//
//  ImagePicker.swift
//  Split
//
//  Created by Hugo Queinnec on 19/03/2023.
//

import PhotosUI
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var images: [UIImage]
    var onCancel: (() -> Void)?
    var onDone: (() -> Void)?

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 0
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {

    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            
            if results.isEmpty { // the user pressed the cancel button
                parent.onCancel?()
                return
            }
            
            var resCounter = 0
            for result in results {
                guard result.itemProvider.canLoadObject(ofClass: UIImage.self) else { continue }
                result.itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                    if let error = error {
                        print("Error loading image: \(error.localizedDescription)")
                        self.parent.onCancel?()
                    } else if let image = image as? UIImage {
                        DispatchQueue.main.async {
                            self.parent.images.append(image)
                            resCounter += 1
                            if resCounter == results.count {
                                self.parent.onDone?() // callback only when images contains everything
                            }
                        }
                    }
                }
            }
        }
    }
}
