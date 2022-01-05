//
//  Model.swift
//  ScanAndRecognizeText
//
//  Created by Gabriel Theodoropoulos.
//

import Foundation

class TextModel: Identifiable {
    var id: String
    var text: String = ""
    
    init() {
        id = UUID().uuidString
    }
}


class TextData: ObservableObject {
    @Published var items = [TextModel]()
}
