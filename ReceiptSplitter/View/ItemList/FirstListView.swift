//
//  FirstListView.swift
//  ReceiptSplitter
//
//  Created by Hugo Queinnec on 20/01/2022.
//

import SwiftUI
import Vision

struct FirstListView: View {
    @EnvironmentObject var model: ModelData
    
    @State var editMode: EditMode = .inactive
    
    @Binding var showScanningResults: Bool
    @Binding var nothingFound: Bool
    @State private var showTutorialScreen = false
    @State private var startAttribution = false
    
    @State private var newItemAlert = false
    @State private var editItemAlert = false
    @State private var editItemAlertPair = PairProductPrice()
    
    var views = ["Scan","List"]
    @State private var showView = "Scan"

    var body: some View {
        if startAttribution {
            HomeView()
        } else {
            Group {
                if model.listOfProductsAndPrices.isEmpty {
                    VStack {
                        LoadItemsView(showScanningResults: $showScanningResults, nothingFound: $nothingFound)
                    }
                } else {

                    //Text(String(editMode.isEditing))
                    
                    ZStack {
                        EmptyView()
                            .alert(isPresented: $newItemAlert,
                                TextAlert(title: "New item",
                                   message:"Please enter the name and the price of the new item",
                                   placeholder1: "Name",
                                   placeholder2: "Price",
                                   initialText: nil,
                                   initialDouble: nil,
                                   action: {
                                        var newPair = PairProductPrice()
                                        if $0 != nil && $1 != nil {
                                            if $0! != "" {
                                                newPair.name = $0!
                                                newPair.price = $1!
                                                //newPair.isNewItem = true
                                                withAnimation() {
                                                    model.listOfProductsAndPrices.insert(newPair, at: 0)
                                                }
                                            }
                                        }
                                    }
                                )
                            )
                        
                        EmptyView()
                            .alert(isPresented: $editItemAlert,
                                TextAlert(title: "Modify item",
                                   message:"You can change the name and the price of this item",
                                   placeholder1: "Name",
                                   placeholder2: "Price",
                                   initialText: editItemAlertPair.name,
                                   initialDouble: editItemAlertPair.price,
                                   action: {
                                        if $0 != nil && $1 != nil {
                                            if $0! != "" {
                                                let index = model.listOfProductsAndPrices.firstIndex(of: editItemAlertPair)!
                                                let name = $0!
                                                let price = $1!
                                                withAnimation() {                                                    model.listOfProductsAndPrices[index].name = name
                                                    model.listOfProductsAndPrices[index].price = price
                                                    return
                                                }
                                            }
                                        }
                                    }
                                )
                            )
                        
                        NavigationView {
                                                
                            VStack{
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("\(model.listOfProductsAndPrices.count) transactions")
                                            .font(.title2)
                                            .fontWeight(.semibold)
                                        Text("\(model.showPrice(price: model.totalPrice))")
                                            .font(.largeTitle)
                                            .fontWeight(.bold)
                                    }
                                    
                                    Spacer()
                                    
                                    Picker("view", selection: $showView) {
                                        ForEach(views, id: \.self) {
                                            Text($0)
                                        }
                                    }
                                    .pickerStyle(.segmented)
                                    .padding(.horizontal, 30)

                                }
                                .padding(.top, 10)
                                .padding(.bottom, 10)
                                .padding(.leading, 30)

                                
                                Group{
                                    if showView=="Scan" {
                                        ScrollView {
                                            ForEach(model.images){ idImage in
                                                if let image = idImage.image {
                                                    Image(uiImage: visualization(image, observations: idImage.boxes(listOfProductsAndPrices: model.listOfProductsAndPrices)))
                                                        .resizable()
                                                        .scaledToFit()
                                                        .padding(5)
                                                }
                                            }
                                        }
                                    } else {
                                        List() {
                                            ForEach(model.listOfProductsAndPrices) { pair in
                                                VStack(alignment: .leading) {
                                                    HStack {
                                                        Text(pair.name)
                                                        Spacer()
                                                        Text(model.showPrice(price: pair.price))
                                                            .padding(.trailing, 10)
                                                    }
                                                    if editMode == .active {
                                                        Text("Double-tap to edit")
                                                            .font(.caption)
                                                            .foregroundColor(Color.accentColor)
                                                            .padding(0)
                                                    }
                                                }
                                                .onTapGesture(count: 2) {
                                                    if editMode == .active {
                                                        editItemAlert = true
                                                        editItemAlertPair = pair
                                                    }
                                                }
                                            }
                                            .onDelete { indexSet in
                                                withAnimation() {
                                                    model.listOfProductsAndPrices.remove(atOffsets: indexSet)
                                                }
                                            }
                                        }
                                        .environment(\.editMode, $editMode)
                                    }
                                }
                                //.transition(.opacity)

                            }
                            .toolbar {
                                ToolbarItem(placement: .navigationBarLeading) {
                                    EditButton()
                                        .onChange(of: editMode) { mode in
                                            if mode==EditMode.active {
                                                showView="List"
                                            } else {
                                            }
                                        }
                                        .environment(\.editMode, $editMode)
                                }
                                ToolbarItem(placement: .navigationBarTrailing) {
                                    Button {
                                        newItemAlert = true
                                    } label: {
                                        Image(systemName: "plus")
                                    }
                                }
                                ToolbarItem(id: UUID().uuidString, placement: .bottomBar, showsByDefault: true) {
                                    Button {
                                        model.eraseScanData()
                                        
                                        withAnimation() {
                                            showScanningResults = false
                                        }
                                    } label: {
                                        Text("Cancel")
                                    }
                                    //.buttonStyle(.bordered)
                                    .padding()
                                    .tint(.red)
                                }
                                ToolbarItem(id: UUID().uuidString, placement: .bottomBar, showsByDefault: true) {
                                    Button {
                                        withAnimation(){
                                            startAttribution = true
                                        }
                                    } label: {
                                        Image(systemName: "arrow.right")
                                        Text("Next")
                                    }
                                    .buttonStyle(.borderedProminent)
                                    .padding()
                                }
                            }
                            .navigationViewStyle(StackNavigationViewStyle())
                            .navigationBarTitle(Text("ReceiptSplitter"), displayMode: .inline)
                            //.navigationBarItems(leading: customEditButton.environment(\.editMode, $editMode), trailing: plusButton)
                            //.navigationBarHidden(true)
                        }
                        .onAppear(perform: {
                            let secondsToDelay = 0.7
                            DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
                                showTutorialScreen = true
                            }
                    })
                    }
                }
            }
            .transition(.opacity)
            .slideOverCard(isPresented: $showTutorialScreen, content: {
                ListTutorialView()
            })
        }
    }

}



struct FirstListView_Previews: PreviewProvider {
    static let model = ModelData()
    static var previews: some View {
        FirstListView(showScanningResults: .constant(true), nothingFound: .constant(true))
            .environmentObject(model)
            .onAppear {
                model.users = [User(name: "Hugo"), User(name: "Lucas"), User(name: "Thomas")]
                model.listOfProductsAndPrices = [
                    PairProductPrice(id: "EC7017DC-8A53-4E98-B738-036A6581A6AA", name: "1L Nectar Goyave", price: 3.0, isNewItem: false, imageId: Optional("1111"), box: VNDetectedObjectObservation(boundingBox: CGRect(x: 0.0960523, y: 0.875845, width: 0.78441, height: 0.080671))),
                    PairProductPrice(id: "EC7017DC-8A53-4E98-B738-036A6581A6AB", name: "250G Camembert CDL", price: 1.75, isNewItem: false, imageId: Optional("1111"), box: VNDetectedObjectObservation(boundingBox: CGRect(x: 0.0958873, y: 0.767238, width: 0.783298, height: 0.0783178))),
                    PairProductPrice(id: "EC7017DC-8A53-4E98-B738-036A6581A6AC", name: "2x125g Palets Bret", price: 1.3, isNewItem: false, imageId: Optional("1111"), box: VNDetectedObjectObservation(boundingBox: CGRect(x: 0.1399, y: 0.64551, width: 0.739269, height: 0.0893237))),
                    PairProductPrice(id: "EC7017DC-8A53-4E98-B738-036A6581A6AD", name: "Courgette", price: 2.19, isNewItem: false, imageId: Optional("2222"), box: VNDetectedObjectObservation(boundingBox: CGRect(x: 0.0960523, y: 0.875845, width: 0.78441, height: 0.080671))),
                    PairProductPrice(id: "EC7017DC-8A53-4E98-B738-036A6581A6AE", name: "DCH LPM Verv Citro", price: 3.85, isNewItem: false, imageId: Optional("2222"), box: VNDetectedObjectObservation(boundingBox: CGRect(x: 0.0973473, y: 0.765197, width: 0.782281, height: 0.0958386)))]
                model.images = [IdentifiedImage(id: "1111", image: UIImage(named: "scan1")), IdentifiedImage(id: "2222", image: UIImage(named: "scan2"))]
            }
    }
}

