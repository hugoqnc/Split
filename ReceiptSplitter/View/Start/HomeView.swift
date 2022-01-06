//
//  ContentView.swift
//  ScanAndRecognizeText
//
//  Created by Gabriel Theodoropoulos.
//

import SwiftUI
import simd

struct HomeView: View {
    @ObservedObject var recognizedContent = TextData()
    @State var showScanner = true // TODO: add private when done, and remove Preview
    @State private var isRecognizing = false
    
    
    var body: some View {
        NavigationView {
            ZStack() {
                VStack{
//                    List(recognizedContent.items, id: \.id) { textItem in
//                        NavigationLink(destination: TextPreviewView(text: textItem.text)) {
//                            Text(String(textItem.text.prefix(50)).appending("..."))
//                        }
//                    }
                    //Text(String(recognizedContent.items[0].text))
                    ForEach(recognizedContent.items, id: \.id) { textItem in
                        List() {
                            ForEach(textItem.list) { pair in
                                HStack {
                                    Text(pair.name)
                                    Spacer()
                                    Text(String(pair.price)+"€")
                                }
                            }
                        }
                    }
                }
                
                
                if isRecognizing {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(2)
                }
                
            }
            .navigationTitle("ReceiptSplitter")
            

        }
        .sheet(isPresented: $showScanner, content: {
            ScannerView { result in
                switch result {
                    case .success(let scannedImages):
                        isRecognizing = true
                        
                        TextRecognition(scannedImages: scannedImages,
                                        recognizedContent: recognizedContent) {
                        }
                        .recognizeText()
                    
                        // Text recognition is finished, hide the progress indicator.
                        isRecognizing = false
                        
                    case .failure(let error):
                        print(error.localizedDescription)
                }
                
                showScanner = false
                
            } didCancelScanning: {
                // Dismiss the scanner controller and the sheet.
                showScanner = false
            }
        })
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(showScanner: false)
    }
}
