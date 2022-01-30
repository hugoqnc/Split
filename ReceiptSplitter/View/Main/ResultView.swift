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
    @State private var showUserDetails = false
    @State private var selectedUser = User()
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
                        Text(model.showPrice(price: model.totalBalance))
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                    }
                    .padding(.top,60)
                    .padding(.bottom,20)
                    
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
                
                
                ScrollView {
                ForEach(model.users.sorted(by: {model.balance(ofUser: $0)>model.balance(ofUser: $1)})) { user in
                    HStack {
                        HStack {
                            Button {
                                selectedUser = user
                                showUserDetails = true
                            } label: {
                                Image(systemName: "person")
                                    .font(.title2)
                                
                                VStack(alignment: .leading) {
                                    Text(user.name)
                                        .font(.title3)
                                    Text("\(model.chosenItems(ofUser: user).count) items")
                                        .font(.caption)
                                }
                                .foregroundColor(.primary)
                            }
                            
                            Spacer()
                            
                            Text(model.showPrice(price: model.balance(ofUser: user)))
                                .fontWeight(.semibold)
                                .font(.system(size: fontSizeProportionalToPrice(total: model.totalBalance, price: model.balance(ofUser: user))))
                            
                            Button {
                                //showSharingOptions = true
                            } label: {
                                Label("See all", systemImage: "square.and.arrow.up")
                                    .labelStyle(.iconOnly)
                            }
                            .padding(.leading,5)
                            
                            
                        }
                        .padding()
                    }
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(15)
                    .padding(.horizontal)
                }
                
                VStack {
                    HStack {
                        Spacer()
                        
                        StatisticRectangle(iconString: "number", description: "Number of\npurchases", value: String(model.listOfProductsAndPrices.count), color: Color.blue)
                        
                        StatisticRectangle(iconString: "cart", description: "Average price\nof an item", value: String(round((model.totalPrice/Double(model.listOfProductsAndPrices.count))*100) / 100.0)+model.currency.value, color: Color.orange)
                        
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        
                        StatisticRectangle(iconString: "arrow.up.right.circle", description: "Maximum price\nof an item", value: String(round((model.listOfProductsAndPrices.map({ pair in
                            pair.price
                        }).max() ?? 0.0)*100) / 100.0)+model.currency.value, color: Color.green)
                        
                        StatisticRectangle(iconString: "arrow.down.right.circle", description: "Minimum price\nof an item", value: String(round((model.listOfProductsAndPrices.map({ pair in
                            pair.price
                        }).min() ?? 0.0)*100) / 100.0)+model.currency.value, color: Color.red)
                        
                        Spacer()
                    }
                }
                .padding(10)
                }
                
                Button {
                    dismiss()
                    
                    model.eraseModelData()
                } label: {
                    Label("Done", systemImage: "checkmark")
                }
                .buttonStyle(.borderedProminent)
                .padding(7)
            }
        
        .sheet(isPresented: $showAllList, content: {
            ListSheetView(itemCounter: -1)
        })
        .sheet(isPresented: $showSharingOptions, content: {
            ActivityViewController(activityItems: [model.sharedText])
                .edgesIgnoringSafeArea(.bottom)
        })
        .sheet(isPresented: $showUserDetails, content: {
            UserChoicesView(user: selectedUser)
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
                        model.users = [User(name: "Hugo"), User(name: "Lucas"), User(name: "Thomas")]
                        model.listOfProductsAndPrices = [PairProductPrice(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBB", name: "Potato Wedges 1kg", price: 4.99), PairProductPrice(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBC", name: "Finger Fish", price: 1.27), PairProductPrice(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBD", name: "Ice Cream Strawberry", price: 3.20)]
                    }
            }
    }
}
