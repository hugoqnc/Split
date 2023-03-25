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

    var results: [ResultUnitText] = []
}

struct ResultUnitText: Codable, Identifiable {
    var id = UUID()
    var users: [User]
    var listOfProductsAndPrices: [PairProductPriceCodable]
    var currency: Currency
    var date: Date
    var receiptName: String
    
    var tipRate: Double?
    var tipEvenly: Bool? // if false, tip proportionally
    var taxRate: Double?
    var taxEvenly: Bool? // if false, tax proportionally
}

class ResultsStore: ObservableObject {
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                       in: .userDomainMask,
                                       appropriateFor: nil,
                                       create: true)
            .appendingPathComponent("results.json")
    }
    
    private static func imageURL(id: UUID) throws -> URL {
        let folderPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("images")
        
        if !FileManager.default.fileExists(atPath: folderPath.path) {
            do {
                try FileManager.default.createDirectory(atPath: folderPath.path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error.localizedDescription)
            }
        }
        
        return folderPath.appendingPathComponent("\(id.uuidString).data")
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
                let results = try JSONDecoder().decode(Results.self, from: file.availableData)
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

    static func loadImage(id: UUID, completion: @escaping (Result<[Data], Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let fileURL = try imageURL(id: id)
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                    DispatchQueue.main.async {
                        completion(.success([]))
                    }
                    return
                }
                let results = try PropertyListDecoder().decode([Data].self, from: file.availableData)
                DispatchQueue.main.async {
                    completion(.success(results))
                }
            } catch let error {
                if case DecodingError.keyNotFound(error: _) = error {
                    DispatchQueue.main.async {
                        completion(.success([]))
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    
    static func append(receiptName: String, users: [User], listOfProductsAndPrices: [PairProductPrice], currency: Currency, date: Date, images: [IdentifiedImage], compressImages: Bool, tipRate: Double? = nil, tipEvenly: Bool? = nil, taxRate: Double? = nil, taxEvenly: Bool? = nil, completion: @escaping (Result<Bool, Error>)->Void) {
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
            imagesData.append(image.image!.jpegData(compressionQuality: compressImages ? JPEGQuality : 1.0)!)
        }
        
        let resultUnit = ResultUnitText(users: users, listOfProductsAndPrices: listOfProductsAndPricesCodable, currency: currency, date: date, receiptName: receiptName, tipRate: tipRate, tipEvenly: tipEvenly, taxRate: taxRate, taxEvenly: taxEvenly)
        append(resultUnit: resultUnit, imagesData: imagesData, completion: completion)
    }
    
    static func append(resultUnit: ResultUnitText, imagesData: [Data], completion: @escaping (Result<Bool, Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            
            load { result in
                switch result {
                case .failure(_): //first time when the file is not yet created
                    //fatalError(error.localizedDescription)
                    
                    do {
                        let data = try JSONEncoder().encode(Results(results: [resultUnit]))
                        let outfile = try fileURL()
                        try data.write(to: outfile)
                        
                        let data2 = try PropertyListEncoder().encode(imagesData)
                        let outfile2 = try imageURL(id: resultUnit.id)
                        //print(outfile2)
                        try data2.write(to: outfile2)
                        
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
                        let data = try JSONEncoder().encode(newResults)
                        let outfile = try fileURL()
                        try data.write(to: outfile)
                        
                        let data2 = try PropertyListEncoder().encode(imagesData)
                        let outfile2 = try imageURL(id: resultUnit.id)
                        //print(outfile2)
                        try data2.write(to: outfile2)
                        
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
    
    static func remove(resultUnit: ResultUnitText, completion: @escaping (Result<Bool, Error>)->Void) {
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
                        let data = try JSONEncoder().encode(newResults)
                        let outfile = try fileURL()
                        try data.write(to: outfile)
                        
                        let outfile2 = try imageURL(id: resultUnit.id)
                        //print(outfile2)
                        try FileManager.default.removeItem(at: outfile2)

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
