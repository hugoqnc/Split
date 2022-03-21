//
//  ResultsStore.swift
//  Split
//
//  Created by Hugo Queinnec on 26/02/2022.
//

import Foundation
import SwiftUI

struct Results: Codable {
    
    static let `default` = Results()

    var results: [ResultUnit] = []
}

struct ResultUnit: Codable, Identifiable {
    
    //static let `default` = Results()
    
    var id = UUID()
    var users: [User]
    var listOfProductsAndPrices: [PairProductPriceCodable]
    var currency: Currency
    var date: Date
    var imagesData: [Data]
    var receiptName: String
}

class ResultsStore: ObservableObject {
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                       in: .userDomainMask,
                                       appropriateFor: nil,
                                       create: true)
            .appendingPathComponent("results.data")
    }
    
    static func load(completion: @escaping (Result<Results, Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let fileURL = try fileURL()
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                    DispatchQueue.main.async {
                        completion(.success(Results()))
                    }
                    return
                }
                let results = try PropertyListDecoder().decode(Results.self, from: file.availableData)
                DispatchQueue.main.async {
                    completion(.success(results))
                }
            } catch let error {
                if case DecodingError.keyNotFound(error: _) = error {
                    DispatchQueue.main.async {
                        completion(.success(Results()))
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    
    static func save(results: Results, completion: @escaping (Result<Bool, Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try PropertyListEncoder().encode(results)
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
    
    static func append(receiptName: String, users: [User], listOfProductsAndPrices: [PairProductPrice], currency: Currency, date: Date, images: [IdentifiedImage], completion: @escaping (Result<Bool, Error>)->Void) {
        var listOfProductsAndPricesCodable: [PairProductPriceCodable] = []
        for pair in listOfProductsAndPrices {
            var pairCod = PairProductPriceCodable()
            pairCod.id = pair.id
            pairCod.name = pair.name
            pairCod.price = pair.price
            pairCod.chosenBy = pair.chosenBy
            listOfProductsAndPricesCodable.append(pairCod)
        }
        
        var imagesData: [Data] = []
        for image in images {
            imagesData.append(image.image!.pngData()!)
        }
        
        let resultUnit = ResultUnit(users: users, listOfProductsAndPrices: listOfProductsAndPricesCodable, currency: currency, date: date, imagesData: imagesData, receiptName: receiptName)
        append(resultUnit: resultUnit, completion: completion)
    }
    
    static func append(resultUnit: ResultUnit, completion: @escaping (Result<Bool, Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            
            load { result in
                switch result {
                case .failure(_): //first tiem when the file is not yet created
                    //fatalError(error.localizedDescription)
                    
                    do {
                        let data = try PropertyListEncoder().encode(Results(results: [resultUnit]))
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
                    
                case .success(let results):
                    var newResults = results
                    newResults.results.append(resultUnit)
                    
                    do {
                        let data = try PropertyListEncoder().encode(newResults)
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
    }
    
    static func remove(resultUnit: ResultUnit, completion: @escaping (Result<Bool, Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            
            load { result in
                switch result {
                case .failure(let error):
                    fatalError(error.localizedDescription)
                    
                case .success(let results):
                    var newResults = results
                    newResults.results.removeAll { r in
                        r.id == resultUnit.id
                    }
                    
                    do {
                        let data = try PropertyListEncoder().encode(newResults)
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
    }
}
