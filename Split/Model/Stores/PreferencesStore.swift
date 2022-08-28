//
//  FavoritePreferencesStore.swift
//  Split
//
//  Created by Hugo Queinnec on 26/01/2022.
//

import Foundation
import SwiftUI

struct Preferences: Codable {
    var names: [String] = []
    var currency: Currency = Currency.default
}

class PreferencesStore: ObservableObject {
    //@Published var preferences: Preferences = Preferences()
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                       in: .userDomainMask,
                                       appropriateFor: nil,
                                       create: true)
            .appendingPathComponent("preferences.json")
    }
    
    static func load(completion: @escaping (Result<Preferences, Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let fileURL = try fileURL()
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                    DispatchQueue.main.async {
                        completion(.success(Preferences()))
                    }
                    return
                }
                let preferences = try JSONDecoder().decode(Preferences.self, from: file.availableData)
                DispatchQueue.main.async {
                    completion(.success(preferences))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    static func save(preferences: Preferences, completion: @escaping (Result<Bool, Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try JSONEncoder().encode(preferences)
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
