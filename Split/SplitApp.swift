//
//  SplitApp.swift
//  Split
//
//  Created by Hugo Queinnec on 04/01/2022.
//

import SwiftUI

@main
struct SplitApp: App {
    @StateObject private var model = ModelData()
    @StateObject private var purchaseManager = PurchaseManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(model)
                .environmentObject(purchaseManager)
                .task {
                    await purchaseManager.updatePurchasedProducts()
                }
        }
    }
}
