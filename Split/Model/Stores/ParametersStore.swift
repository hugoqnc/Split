//
//  ParametersStore.swift
//  Split
//
//  Created by Hugo Queinnec on 24/02/2022.
//

import Foundation
import SwiftUI

struct Parameters: Codable {
    
    static let `default` = Parameters()
    
    var bigRecognition = true
    var showScanTutorial = true
    var showEditTutorial = true
    var selectAllUsers = false
    var visionParameters = VisionParameters()
}

class ParametersStore: ObservableObject {
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                       in: .userDomainMask,
                                       appropriateFor: nil,
                                       create: true)
            .appendingPathComponent("parameters.data")
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
                let preferences = try JSONDecoder().decode(Parameters.self, from: file.availableData)
                DispatchQueue.main.async {
                    completion(.success(preferences))
                }
            } catch let error {
                if case DecodingError.keyNotFound(error: _) = error {
                    DispatchQueue.main.async {
                        completion(.success(Parameters.default))
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
