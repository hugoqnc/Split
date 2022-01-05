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
    
    var testPairs: [pairProductPrice] = [pairProductPrice(id: "408C6FAC-85E1-4E59-A6ED-ADEC900100C7", name: "Lachsfilet 2x125g oCHFLachsfilet 2x125gPotatoWedges 1kgO", price: Optional(4.79)), pairProductPrice(id: "0E988C08-0D81-42DA-8A40-7A5B7677F0F9", name: "", price: Optional(4.79)), pairProductPrice(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBB", name: "Potato Wedges 1kg (", price: Optional(4.99)), pairProductPrice(id: "D26461AA-F0D0-49D9-B1B8-5A41D0284E0C", name: "Fish", price: Optional(4.99))]
    
    
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
                            ForEach(textItem.list) { pairProductPrice in
                                HStack {
                                    Text(pairProductPrice.name)
                                    Spacer()
                                    if let price = pairProductPrice.price{
                                        Text(String(price)+"€")
                                    }
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
