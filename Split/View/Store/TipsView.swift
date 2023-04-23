//
//  TipsView.swift
//  Split
//
//  Created by Hugo Queinnec on 15/04/2023.
//

import SwiftUI
import StoreKit

struct TipsView: View {

    @EnvironmentObject private var purchaseManager: PurchaseManager
    @State private var donationSheet = false

    var body: some View {
        if purchaseManager.hasTippedAll {
            Label("You did the utmost to support Split! A huge thank you!", systemImage: "heart")
                .font(.headline)
        } else {
            VStack(spacing: 20) {
                VStack {
                    HStack {
                        if purchaseManager.hasTipped {
                            VStack(alignment: .leading, spacing: 5) {
                                Label("Thank you for supporting Split!", systemImage: "heart")
                                    .font(.headline)
                                Text("You have helped make Split! available to everyone for free!")
                                    .font(.subheadline)
                            }
                        } else {
                            VStack(alignment: .leading, spacing: 5) {
                                Label("Tips to support Split!", systemImage: "heart")
                                    .font(.headline)
                                Text("Split! is **free**, **ad-free**, does **not collect your data**, and is developed **independently** by a student in his spare time. You can contribute to its future evolution!")
                                    .font(.subheadline)
                            }
                        }
                        Spacer()
                    }
                    
                    HStack {
                        ForEach(purchaseManager.products.sorted(by: { p1, p2 in
                            p1.price < p2.price
                        })) { product in
                            Button {
                                _ = Task<Void, Never> {
                                    do {
                                        let res = try await purchaseManager.purchase(product)
                                        donationSheet = res
                                    } catch {
                                        print(error)
                                    }
                                }
                            } label: {
                                Group {
                                    if purchaseManager.purchasedProductIDs.contains(product.id) {
                                        VStack {
                                            Label("", systemImage: "checkmark")
                                                .labelStyle(.iconOnly)
                                            Text("\(product.displayName)")
                                                .fontWeight(.semibold)
                                                .font(.caption)
                                        }
                                    } else {
                                        ZStack {
                                            VStack {
                                                Text("\(product.displayPrice)")
                                                Text("\(product.displayName)")
                                                    .fontWeight(.semibold)
                                                    .font(.caption)
                                            }
                                            if purchaseManager.loadingStatus[product.id] == true {
                                                ProgressView()
                                            }
                                        }
                                    }
                                }
                                .frame(minWidth:64)
                            }
                            .buttonStyle(.borderedProminent)
                            .disabled(purchaseManager.purchasedProductIDs.contains(product.id) || purchaseManager.loadingStatus.values.contains(where: { value in value }))
                        }
                    }
                    
                    Button {
                        _ = Task<Void, Never> {
                            do {
                                try await AppStore.sync()
                            } catch {
                                print(error)
                            }
                        }
                    } label: {
                        Text("Restore Purchases")
                            .font(.caption)
                            .padding(.top, 6)
                    }
                    .buttonStyle(.borderless)
                }
                .sheet(isPresented: $donationSheet) {
                    DonationSheet()
                }
            }.task {
                _ = Task<Void, Never> {
                    do {
                        try await purchaseManager.loadProducts()
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }
}

struct TipsView_Previews: PreviewProvider {
    static var previews: some View {
        TipsView()
            .padding()
            .background(Color.accentColor.opacity(0.15))
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .environmentObject(PurchaseManager())
            .padding()
    }
}
