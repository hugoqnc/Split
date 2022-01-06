//
//  ModelData.swift
//  ReceiptSplitter
//
//  Created by Hugo Queinnec on 05/01/2022.
//

import Foundation

final class ModelData: ObservableObject {
    @Published var users: [User] = UsersModel().users
    @Published var listOfProductsAndPrices: [PairProductPrice] = []
}
