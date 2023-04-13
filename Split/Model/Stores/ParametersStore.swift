//
//  ParametersStore.swift
//  Split
//
//  Created by Hugo Queinnec on 24/02/2022.
//

import Foundation
import SwiftUI

var JPEGQuality = 0.4 //compression factor, between 0 (maximum compression) and 1 (best quality)

struct Parameters: Codable {
    
    static let `default` = Parameters()
    
    var advancedRecognition = true
    var showScanTutorial = true
    var showLibraryTutorial = true
    var showEditTutorial = true
    var showAttributionTutorial = true
    var selectAllUsers = false
    var visionParameters = VisionParameters()
    var tricountList: [Tricount] = []
    var defaultCurrency = Currency.default
    var compressImages = true
    var appVersion = "0"
    
    var showTipAndTax = true
    var usualTips = [18.0, 20.0, 22.0]
    var defaultTipEvenly = true
    var defaultTaxRate = 10.0
    var defaultTaxEvenly = false
    
    static func createFromOld(oldP: OldParameters) -> Parameters {
        var newP = Parameters.default
        newP.advancedRecognition = oldP.advancedRecognition
        newP.showScanTutorial = oldP.showScanTutorial
        newP.showEditTutorial = oldP.showEditTutorial
        newP.showAttributionTutorial = oldP.showAttributionTutorial
        newP.selectAllUsers = oldP.selectAllUsers
        newP.visionParameters = oldP.visionParameters
        newP.tricountList = oldP.tricountList
        newP.defaultCurrency = oldP.defaultCurrency
        newP.defaultCurrency = oldP.defaultCurrency
        return newP
    }
}

struct OldParameters: Codable { // Legacy parameters format (does not contain `showLibraryTutorial`), necessary for devices with a previous version wanting to update
    
    static let `default` = Parameters()
    
    var advancedRecognition = true
    var showScanTutorial = true
    // var showLibraryTutorial = true
    var showEditTutorial = true
    var showAttributionTutorial = true
    var selectAllUsers = false
    var visionParameters = VisionParameters()
    var tricountList: [Tricount] = []
    var defaultCurrency = Currency.default
    var compressImages = true
}

class ParametersStore: ObservableObject {
    private static var fileData: Data? = nil
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                       in: .userDomainMask,
                                       appropriateFor: nil,
                                       create: true)
            .appendingPathComponent("parameters.json")
    }
    
    static func updateParameters() -> Parameters { // return Parameters in its new format, containing the previous parameters inside
        do {
            let preferencesOld = try JSONDecoder().decode(OldParameters.self, from: fileData!)
            let newP = Parameters.createFromOld(oldP: preferencesOld)
            save(parameters: newP) {_ in }
            print("Parameters successfully updated to new format")
            return newP
        } catch _ {
            return Parameters.default // The parameters file is niether the old nor the new format -> it is reinitialized
        }
        
    }
    
    static func load(completion: @escaping (Result<Parameters, Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let fileURL = try fileURL()
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                    DispatchQueue.main.async {
                        completion(.success(Parameters()))
                    }
                    return
                }
                fileData = file.availableData
                let preferences = try JSONDecoder().decode(Parameters.self, from: fileData!)
                DispatchQueue.main.async {
                    completion(.success(preferences))
                }
            } catch let error {
                if case DecodingError.keyNotFound(let key, _) = error {
                    // If a key is missing, then the format is outdated and needs to be updated
                    print("Missing parameter key: ", key.stringValue)
                    let newParameters = updateParameters()
                    
                    DispatchQueue.main.async {
                        completion(.success(newParameters))
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    
    static func save(parameters: Parameters, completion: @escaping (Result<Bool, Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try JSONEncoder().encode(parameters)
                let outfile = try fileURL()
                try data.write(to: outfile)
                DispatchQueue.main.async {
                    completion(.success(true))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}
