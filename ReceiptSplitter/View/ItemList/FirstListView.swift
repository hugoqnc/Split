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
    @Binding var showScanningResults: Bool
    @Binding var nothingFound: Bool
    @State private var showTutorialScreen = false
    @State private var startAttribution = false
    
    var views = ["Scan","List"]
    @State private var showList = "List" //TOCHANGE

    var body: some View {
        if startAttribution {
            HomeView()
        } else {
            VStack {
                
                if model.listOfProductsAndPrices.isEmpty {
                    VStack {
                        LoadItemsView(showScanningResults: $showScanningResults, nothingFound: $nothingFound)
                    }
                } else {
                    
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
                                
                                Picker("view", selection: $showList) {
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

                            
                            
                            ZStack {
                                if showList=="Scan" {
                                    ScrollView {
                                        ForEach(model.images){ idImage in
                                            if let image = idImage.image {
                                                let boxes = model.listOfProductsAndPrices.compactMap({ pair -> VNDetectedObjectObservation? in
                                                    if pair.imageId==idImage.id && !(pair.box == nil){
                                                        return pair.box!
                                                    }
                                                    return nil
                                                })
                                                Image(uiImage: visualization(image, observations: boxes))
                                                    .resizable()
                                                    .scaledToFit()
                                                    .padding(5)
                                            }
                                        }
                                    }
                                } else {
                                    List() {
                                        ForEach(model.listOfProductsAndPrices) { pair in
                                            HStack {
                                                Text(pair.name)
                                                Spacer()
                                                Text(String(pair.price)+model.currency.value)
                                            }
                                        }
                                        .onDelete { indexSet in
                                            model.listOfProductsAndPrices.remove(atOffsets: indexSet)
                                        }
                                    }
                                }
                            }
                            .transition(.opacity)
                        }
                        .toolbar {
                            ToolbarItem(placement: .bottomBar) {
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
                            ToolbarItem(placement: .bottomBar) {
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
                        .navigationBarItems(leading: showList=="List" ? EditButton() : nil, trailing: plusButton)
                        //.navigationBarHidden(true)
                    }
                    .onAppear(perform: {
                        let secondsToDelay = 0.7
                        DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
                            //showTutorialScreen = true //TOCHANGE
                        }
                    })
                }
            }
            .transition(.opacity)
            .slideOverCard(isPresented: $showTutorialScreen, content: {
                ListTutorialView()
        })
        }
    }
    
    private var plusButton: some View {
        Button {
            promptItem(pair: nil)
        } label: {
            Image(systemName: "plus")
        }
    }
}

private func promptItem(pair: PairProductPrice?) {
    var name = ""
    var price = "abc"
    
    let alert = UIAlertController(title: "Enter item details", message: "", preferredStyle: .alert)
    alert.addTextField() { textField in
        textField.placeholder = "..."
        textField.text = name
    }
    alert.addTextField() { textField in
        textField.placeholder = "..."
        textField.text = price
    }
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in })
    alert.addAction(UIAlertAction(title: "Done", style: .default) { _ in
//            if let textField = alert.textFields?[0], textField.text != ""{
//               self.users.append(UserList(Name: textField.text ?? ""))
//            }
    })
    //showAlert(alert: alert)
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

