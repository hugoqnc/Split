//
//  ResultViewHistoryWrapper.swift
//  Split
//
//  Created by Hugo Queinnec on 26/02/2022.
//

import SwiftUI

struct ResultViewHistoryWrapper: View {
    @EnvironmentObject var globalModel: ModelData
    private var resultUnitId: UUID
    
    internal init(resultUnit: ResultUnitText, tricountList: [Tricount]) {
        resultUnitId = resultUnit.id
        
        model = ModelData()
        model.users = resultUnit.users
        model.currency = resultUnit.currency
        model.date = resultUnit.date
        model.receiptName = resultUnit.receiptName
        model.parameters.tricountList = tricountList
        model.tipRate = resultUnit.tipRate
        model.tipEvenly = resultUnit.tipEvenly
        model.taxRate = resultUnit.taxRate
        model.taxEvenly = resultUnit.taxEvenly
        
        var listOfProductsAndPrices: [PairProductPrice] = []
        for pairCod in resultUnit.listOfProductsAndPrices {
            var pair = PairProductPrice()
            pair.id = pairCod.id
            pair.name = pairCod.name
            pair.price = pairCod.price
            pair.chosenBy = pairCod.chosenBy
            listOfProductsAndPrices.append(pair)
        }
        model.listOfProductsAndPrices = listOfProductsAndPrices
    }
    
    var model: ModelData
    
    @State private var showReceiptImage = false
    
    var body: some View {
        ResultView(isShownInHistory: true)
            .environmentObject(model)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showReceiptImage.toggle()
                    } label: {
                        Image(systemName: "doc.plaintext")
                    }
                    .padding(.trailing, 10)

                }
            }
            .onAppear(perform: {
                ResultsStore.loadImage(id: resultUnitId) { result in
                    switch result {
                    case .failure(let error):
                        fatalError(error.localizedDescription)
                    case .success(let imagesData):
                        for d in imagesData {
                            model.images.append(IdentifiedImage(id: UUID().uuidString, image: UIImage(data: d)!))
                        }
                    }
                }
            })
            .sheet(isPresented: $showReceiptImage) {
                ScrollView {
                    ForEach(model.images){ idImage in
                        if let image = idImage.image {
                            Image(uiImage: visualization(image, observations: idImage.boxes(listOfProductsAndPrices: model.listOfProductsAndPrices)))
                                .resizable()
                                .scaledToFit()
                                .padding(5)
                                .frame(maxWidth: 500)
                        }
                    }
                }
            }
    }
}

struct ResultViewHistoryWrapper_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ResultViewHistoryWrapper(resultUnit: ResultUnitText(users: [], listOfProductsAndPrices: [], currency: Currency.default, date: Date(), receiptName: "ALDI"), tricountList: [])
                .environmentObject(ModelData())
        }
    }
}
