//
//  ResultView.swift
//  Split
//
//  Created by Hugo Queinnec on 08/01/2022.
//

import SwiftUI
import UIKit

struct ResultView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass //for iPad specificity
    var isShownInHistory = false
    @EnvironmentObject var model: ModelData
    @State private var showAllList = false
    @State private var showUserDetails = false
    @State private var selectedUser = User()
    @State private var showSharingOptions = false
    @State private var showIndividualSharingOptions = false
    @State private var chosenSharingOption = ""
    
    @State private var showExportToTricount = false
    
    func fontSizeProportionalToPrice(total: Double, price: Double) -> Double {
        let minSize = 12.0
        let maxSize = 35.0
        var size = 20.0
        if !(total==0.0){
            size = min(minSize + abs(max(price, 0)/total)*(maxSize-minSize), maxSize)
        }
        return size
    }
    
    var contentToShare: [Any] {
        get {
            var toShare: [Any] = []

            if chosenSharingOption=="overview" {
                toShare = [model.sharedText]
            } else if chosenSharingOption=="details" {
                toShare = [model.sharedTextDetailed]
            } else if chosenSharingOption=="scan" {
                let images = model.images.map { i in
                    return i.image ?? UIImage()
                }
                toShare = images
            }
            return toShare
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    HStack {
                        VStack{
                            Button{
                                showAllList = true
                            } label: {
                                VStack {
                                    HStack(spacing:4) {
                                        Image(systemName: "info.circle")
                                        Text("Total".uppercased())
                                            .font(.title2)
                                            .foregroundColor(.primary)
                                    }
                                    Text(model.showPrice(price: model.totalBalance))
                                        .font(.largeTitle)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.primary)
                                    Text(model.receiptName)
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .padding(.top,isShownInHistory ? 8 : 35)
                        .padding(.bottom,5)
                    }
                    
                    HStack {
                        Spacer()
                        
                        Menu {
                            if !compatibleTricounts(users: model.users, tricountList: model.parameters.tricountList).isEmpty && model.users.map {model.balance(ofUser: $0)}.min() ?? 0 >= 0 {
                                Button {
                                    showExportToTricount = true
                                } label: {
                                    HStack {
                                        Label("Export to Tricount", systemImage: "plus.forwardslash.minus")
                                    }
                                }
                            }
                            
                            Button {
                                chosenSharingOption = "overview"
                                showSharingOptions = true
                            } label: {
                                Label("Share totals", systemImage: "message")
                            }
                            
                            Button {
                                chosenSharingOption = "details"
                                showSharingOptions = true
                            } label: {
                                Label("Share detailed results", systemImage: "plus.message")
                            }
                            
                            Button {
                                chosenSharingOption = "scan"
                                showSharingOptions = true
                            } label: {
                                Label("Share scanned receipt", systemImage: "doc")
                            }
                        } label: {
                            Image(systemName: "square.and.arrow.up")
                        }
                        .padding(.trailing, 30)
                        .padding(.bottom, isShownInHistory ? 0 : 60)
                    }
                }
                
                
                ScrollView {
                    VStack {
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
                                        
                                        Spacer()
                                        
                                        Text(model.showPrice(price: model.balance(ofUser: user)))
                                            .fontWeight(.semibold)
                                            .font(.system(size: fontSizeProportionalToPrice(total: model.totalBalance, price: model.balance(ofUser: user))))
                                            .foregroundColor(.primary)
                                    }
                                    
                                    Button {
                                        selectedUser = user
                                        showIndividualSharingOptions = true
                                    } label: {
                                        Label("", systemImage: "square.and.arrow.up")
                                            .labelStyle(.iconOnly)
                                    }
                                    .padding(.leading,7)
                                    .padding(.bottom,4)
                                    
                                }
                                .padding()
                            }
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(15)
                            .padding(.horizontal)
                        }
                    }
                    .padding(.top, horizontalSizeClass == .compact ? 5 : 25)
                    
                    StatView()
                        .padding(10)
                        .padding(.top, horizontalSizeClass == .compact ? 0 : 10)
                    
                    Text("\(selectedUser.name) \(chosenSharingOption)") //due to https://developer.apple.com/forums/thread/652080
                         .hidden()
                         .frame(height:0)
                }
                
            }
            //.navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
            .padding(.horizontal, horizontalSizeClass == .compact ? 0 : 30)
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    if !isShownInHistory {
                        Button {
                            model.date = Date()
                            ResultsStore.append(receiptName: model.receiptName, users: model.users, listOfProductsAndPrices: model.listOfProductsAndPrices, currency: model.currency, date: model.date, images: model.images, compressImages: model.parameters.compressImages) { result in
                                switch result {
                                case .failure(let error):
                                    fatalError(error.localizedDescription)
                                case .success(_):
                                    withAnimation() {
                                        model.eraseModelData()
                                    }
                                }
                            }
                        } label: {
                            HStack {
                                Image(systemName: "checkmark")
                                Text("Done")
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .padding(7)
                    }
                }
            }
            .sheet(isPresented: $showAllList, content: {
                ListSheetView(itemCounter: .constant(-1), isShownInHistory: isShownInHistory)
            })
            .sheet(isPresented: $showUserDetails, content: {
                UserChoicesView(user: selectedUser)
            })
            .sheet(isPresented: $showSharingOptions, content: {
                ActivityViewController(activityItems: contentToShare)
            })
            .sheet(isPresented: $showIndividualSharingOptions, content: {
                ActivityViewController(activityItems: [model.individualSharedText(ofUser: selectedUser)])
            })
            .sheet(isPresented: $showExportToTricount, content: {
                TricountExportSheet()
            })
        }
        .transition(.move(edge: .bottom))
        .navigationViewStyle(StackNavigationViewStyle())
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
    static let model: ModelData = {
        var model = ModelData()
        model.images = [IdentifiedImage(id: "1111", image: UIImage(named: "scan1")), IdentifiedImage(id: "2222", image: UIImage(named: "scan2"))]
        model.users = [User(name: "Hugo"), User(name: "Corentin"), User(name: "Thomas")]
        model.listOfProductsAndPrices = [PairProductPrice(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBB", name: "Potato Wedges 1kg", price: 0.99), PairProductPrice(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBC", name: "Finger Fish 850g x12 from Aldi 2022", price: 1.27), PairProductPrice(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBD", name: "Ice Cream Strawberry", price: 3.20)]
        model.listOfProductsAndPrices[0].chosenBy = [model.users[0].id]
        model.listOfProductsAndPrices[1].chosenBy = [model.users[0].id, model.users[1].id]
        model.listOfProductsAndPrices[2].chosenBy = [model.users[0].id, model.users[1].id, model.users[2].id]
        model.receiptName = "ALDI SUISSE"
        return model
    }()
    
    static var previews: some View {
        ResultView()
            .environmentObject(model)
    }
}
