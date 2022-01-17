//
//  ResultView.swift
//  ReceiptSplitter
//
//  Created by Hugo Queinnec on 08/01/2022.
//

import SwiftUI
import UIKit

struct ResultView: View {
    @EnvironmentObject var model: ModelData
    @State private var showAllList = false
    @State private var showSharingOptions = false
    @Environment(\.dismiss) var dismiss
    
    func fontSizeProportionalToPrice(total: Double, price: Double) -> Double {
        let minSize = 12.0
        let maxSize = 35.0
        var size = 20.0
        if !(total==0.0){
            size = minSize + (price/total)*(maxSize-minSize)
        }
        return size
    }
    
    
    
    var body: some View {
            VStack {
                ZStack {
                    VStack{
                        Text("Total".uppercased())
                            .font(.title2)
                        Text(String(round(model.totalPrice * 100) / 100.0)+model.currency.value)
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                    }
                    .padding(.top,60)
                    
                    HStack {
                        Spacer()
                        
                        Button {
                            showSharingOptions = true
                        } label: {
                            Label("See all", systemImage: "square.and.arrow.up")
                                .labelStyle(.iconOnly)
                        }
                        .padding(.trailing, 30)
                        .padding(.bottom,60)
                    }
                }
                
                Divider()
                    .padding(.leading)
                    .padding(.trailing)
                
                HStack {
                    VStack{
                        Image(systemName: "person.2")
                            .resizable(resizingMode: .tile)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 45.0, height: 30.0)
                            .foregroundColor(.blue)
                    }
                    .padding(.leading)
                    .padding(.trailing, 8)
                    
                    Divider()
                    
                    ScrollView(.vertical){
                        VStack {
                            ForEach(model.users.sorted(by: {$0.balance>$1.balance})) { user in
                                HStack{
                                    Text(user.name)
                                        .font(.title3)
                                    Spacer()
                                    Text(String(round(user.balance * 100) / 100.0)+model.currency.value)
                                        //.font(.title2)
                                        .fontWeight(.semibold)
                                        .font(.system(size: fontSizeProportionalToPrice(total: model.totalPrice, price: user.balance)))
                                }
                                .padding(8)
                            }
                        }
                    }
                    .padding(6)
                }
                .padding(.leading)
                .padding(.trailing)
                //.frame(height: 195)
                
                Divider()
                    .padding(.leading)
                    .padding(.trailing)
                
                HStack {
                    VStack{
                        Image(systemName: "cart")
                            .resizable(resizingMode: .tile)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 45.0, height: 35.0)
                            .foregroundColor(.orange)
                        Button {
                            showAllList = true
                        } label: {
                            Label("See all", systemImage: "list.bullet")
                                .labelStyle(.iconOnly)
                        }
                        .buttonStyle(.bordered)
                        .foregroundColor(.orange)
                        .padding(.top)
                        
                    }
                    .padding(.leading)
                    .padding(.trailing, 8)
                    
                    Divider()
                    
                    ScrollView(.vertical){
                        StatView()
                    }
                    .padding(10)
                }
                .padding(.leading)
                .padding(.trailing)
                
                Button {
                    dismiss()
                    
                    model.startTheProcess = false
                    model.users = UsersModel().users
                    model.listOfProductsAndPrices = []
                } label: {
                    Label("Done", systemImage: "checkmark")
                }
                .buttonStyle(.borderedProminent)
                .padding(7)
            }
        
        .sheet(isPresented: $showAllList, content: {
            ListSheetView(itemCounter: -1, isFirstTimeShowingList: .constant(false))
        })
        .sheet(isPresented: $showSharingOptions, content: {
            ActivityViewController(activityItems: [model.sharedText])
                .edgesIgnoringSafeArea(.bottom)
        })
        
    }
}

struct ActivityViewController: UIViewControllerRepresentable {

    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil

    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityViewController>) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityViewController>) {}

}

struct ResultView_Previews: PreviewProvider {
    static let model = ModelData()
    static var previews: some View {
        Text("Test")
            .sheet(isPresented: .constant(true)) {
                ResultView()
                    .environmentObject(model)
                    .onAppear {
                        model.users = [User(name: "Hugo", balance: 13.8), User(name: "Lucas", balance: 17.21), User(name: "Thomas", balance: 3.22)]
                        model.listOfProductsAndPrices = [PairProductPrice(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBB", name: "Potato Wedges 1kg", price: 4.99), PairProductPrice(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBC", name: "Finger Fish", price: 1.27), PairProductPrice(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBD", name: "Ice Cream Strawberry", price: 3.20)]
                    }
            }
    }
}
