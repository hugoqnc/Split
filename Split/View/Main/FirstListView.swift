//
//  FirstListView.swift
//  Split
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
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass //for iPad specificity
    
    var textTipTax: String {
        get {
            var text = ""
            if (model.tipRate != nil || model.taxRate != nil) {
                text = "excl. \(model.tipRate != nil ? "tip" : "")\(model.tipRate != nil && model.taxRate != nil ? " and " : "")\(model.taxRate != nil ? "taxes" : "")"
            }
            return text
        }
    }

    var body: some View {
        if startAttribution {
            AttributionView()
        } else {
            Group {
                if model.listOfProductsAndPrices.isEmpty {
                    VStack {
                        LoadItemsView(showScanningResults: $showScanningResults, nothingFound: $nothingFound)
                    }
                } else {
                    ZStack {
                        NavigationView {
                            VStack{
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("\(model.listOfProductsAndPrices.count) items")
                                            .font(.title2)
                                            .fontWeight(.semibold)
                                        Text("\(model.showPrice(price: model.totalPriceBeforeTaxTip))")
                                            .font(.largeTitle)
                                            .fontWeight(.bold)
                                        Text(textTipTax)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    Spacer()
                                    
                                    Text("\(editItemAlertPair.name)") //due to https://developer.apple.com/forums/thread/652080
                                        .hidden()
                                        .frame(width: 0, height:0)
                                    
                                    VStack {
                                        if horizontalSizeClass == .compact { //don't show on iPad's large screen
                                            Picker("view", selection: $showView) {
                                                ForEach(views, id: \.self) {
                                                    Text($0)
                                                }
                                            }
                                            .pickerStyle(.segmented)
                                            .padding(.horizontal, 30)
                                        }
                                    }
                                }
                                .padding(.top, 10)
                                .padding(.bottom, 10)
                                .padding(.leading, 30)
                                
                                Group {
                                    if horizontalSizeClass == .compact {
                                        Group{
                                            if showView=="Scan" {
                                                ScrollView {
                                                    AutomatedRecognitionLabel(isEnabled: model.parameters.advancedRecognition && !model.continueWithStandardRecognition)
                                                        .padding(.top, 10)
                                                    
                                                    if model.listOfProductsAndPrices.reduce(false, { previous, pair in
                                                        return pair.name.isEmpty || previous
                                                    }) {
                                                        ZStack {
                                                            Label("Some items are missing a name", systemImage: "exclamationmark.triangle")
                                                                .font(.caption2)
                                                        }
                                                        .padding(3)
                                                        .padding(.horizontal, 4)
                                                        .foregroundColor(.red)
                                                        .background(Color.red.opacity(0.2))
                                                        .cornerRadius(15)
                                                        .onTapGesture {
                                                            showView = "List"
                                                        }
                                                    }
                                                    
                                                    ForEach(model.images){ idImage in
                                                        if let image = idImage.image {
                                                            Image(uiImage: visualization(image, observations: idImage.boxes(listOfProductsAndPrices: model.listOfProductsAndPrices)))
                                                                .resizable()
                                                                .scaledToFit()
                                                                .padding(5)
                                                        }
                                                    }
                                                    .padding(.top, 10)
                                                }
                                            } else {
                                                HStack {
                                                    AddPercentButton(isTip: true, color: Color.pink)
                                                    AddPercentButton(isTip: false, color: CustomColor.bankGreen)
                                                }
                                                .padding(.horizontal, 20)
                                                .padding(.vertical, 5)
                                                
                                                List() {
                                                    Section(header: Text("Receipt Name")) {
                                                        VStack {
                                                            TextField("Receipt Name", text: $model.receiptName.animation())
                                                                .disabled(editMode != .active)
                                                                .foregroundColor(editMode == .active ? .blue : .primary)
                                                        }
                                                    }
                                                    
                                                    Section(header: Text("Detected Items")) {
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
                                                                    editItemAlertPair = pair
                                                                    editItemAlert = true
                                                                }
                                                            }
                                                        }
                                                        .onDelete { indexSet in
                                                            withAnimation() {
                                                                model.listOfProductsAndPrices.remove(atOffsets: indexSet)
                                                            }
                                                            if model.listOfProductsAndPrices.count == 0 {
                                                                nothingFound = true //so that if a user deletes all items, he is redirected to the nothing found screen
                                                            }
                                                        }
                                                    }
                                                }
                                                .listStyle(.inset)
                                                .environment(\.editMode, $editMode)
                                            }
                                        }
                                    } else { //iPad (large screen) version
                                        HStack{
                                            ScrollView {
                                                AutomatedRecognitionLabel(isEnabled: model.parameters.advancedRecognition && !model.continueWithStandardRecognition)
                                                    .padding(.top,10)
                                                
                                                if model.listOfProductsAndPrices.reduce(false, { previous, pair in
                                                    return pair.name.isEmpty || previous
                                                }) {
                                                    ZStack {
                                                        Label("Some items are missing a name", systemImage: "exclamationmark.triangle")
                                                            .font(.caption2)
                                                    }
                                                    .padding(3)
                                                    .padding(.horizontal, 4)
                                                    .foregroundColor(.red)
                                                    .background(Color.red.opacity(0.2))
                                                    .cornerRadius(15)
                                                }
                                                
                                                ForEach(model.images){ idImage in
                                                    if let image = idImage.image {
                                                        Image(uiImage: visualization(image, observations: idImage.boxes(listOfProductsAndPrices: model.listOfProductsAndPrices)))
                                                            .resizable()
                                                            .scaledToFit()
                                                            .padding(5)
                                                    }
                                                }
                                                .padding(.top,10)
                                            }
                                            
                                            Divider()
                                            
                                            VStack {
                                                
                                                HStack {
                                                    AddPercentButton(isTip: true, color: Color.pink)
                                                    AddPercentButton(isTip: false, color: CustomColor.bankGreen)
                                                }
                                                .padding(.horizontal, 20)
                                                .padding(.vertical, 5)
                                                
                                                List() {
                                                    Section(header: Text("Receipt Name")) {
                                                        VStack {
                                                            TextField("Receipt Name", text: $model.receiptName.animation())
                                                                .disabled(editMode != .active)
                                                                .foregroundColor(editMode == .active ? .blue : .primary)
                                                        }
                                                    }
                                                    
                                                    Section(header: Text("Detected Items")) {
                                                        ForEach(model.listOfProductsAndPrices) { pair in
                                                            VStack(alignment: .leading) {
                                                                HStack {
                                                                    Text(pair.name)
                                                                    Spacer()
                                                                    Text(model.showPrice(price: pair.price))
                                                                        //.padding(.trailing, 10)
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
                                                                    editItemAlertPair = pair
                                                                    editItemAlert = true
                                                                }
                                                            }
                                                        }
                                                        .onDelete { indexSet in
                                                            withAnimation() {
                                                                model.listOfProductsAndPrices.remove(atOffsets: indexSet)
                                                            }
                                                            if model.listOfProductsAndPrices.count == 0 {
                                                                nothingFound = true //so that if a user deletes all items, he is redirected to the nothing found screen
                                                            }
                                                        }
                                                    }
                                                }
                                                .listStyle(.inset)
                                                .padding(.horizontal, 5)
                                                .padding(.trailing, 10)
                                                .environment(\.editMode, $editMode)
                                                
                                                Text("") //necessary to keep the bottom bar blurred
                                                    
                                            }
                                        }
                                    }
                                }
                                .sheet(isPresented: $editItemAlert) {
                                    let name = editItemAlertPair.name
                                    let price = editItemAlertPair.price
                                    
                                    InputItemDetails(title: "Modify item",
                                                     message:"You can change the name and the price of \"\(name)\"",
                                                     placeholder1: "Name",
                                                     placeholder2: "Price",
                                                     initialText: name,
                                                     initialDouble: price,
                                                     action: {
                                                          let _ = $2
                                                          if $0 != nil && $1 != nil {
                                                              if $0! != "" {
                                                                  let index = model.listOfProductsAndPrices.firstIndex(of: editItemAlertPair)!
                                                                  let name = $0!
                                                                  let price = $1!
                                                                  withAnimation() {
                                                                      model.listOfProductsAndPrices[index].name = name
                                                                      model.listOfProductsAndPrices[index].price = price
                                                                      return
                                                                  }
                                                              }
                                                          }
                                                      })
                                }
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
                                    .sheet(isPresented: $newItemAlert) {
                                        InputItemDetails(title: "New item",
                                                         message:"Please enter the name and the price of the new item",
                                                         placeholder1: "Name",
                                                         placeholder2: "Price",
                                                         initialText: AttributionCard.textOfNewItem,
                                                         initialDouble: nil,
                                                         action: {
                                                              _ = $2
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
                                                          })
                                    }
                                }
                                ToolbarItem(id: UUID().uuidString, placement: .bottomBar, showsByDefault: true) {
                                    Button {
                                        withAnimation() {
                                            if model.photoIsImported {
                                                model.eraseModelData(eraseScanFails: false, fast: true)
                                            } else {
                                                model.eraseScanData()
                                            }
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
                            .navigationBarTitle(Text(model.receiptName), displayMode: .inline)

                        }
                        .navigationViewStyle(StackNavigationViewStyle())
                        .onAppear(perform: {
                            let secondsToDelay = 0.7
                            DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
                                showTutorialScreen = model.parameters.showEditTutorial
                            }
                    })
                    }
                }
            }
            .transition(.opacity)
            .slideOverCard(isPresented: $showTutorialScreen, content: {
                VStack {
                    ListTutorialView(advancedRecognition: $model.parameters.advancedRecognition)
                    Button {
                        showTutorialScreen = false
                        model.parameters.showEditTutorial = false
                        ParametersStore.save(parameters: model.parameters) { result in
                            switch result {
                            case .failure(let error):
                                fatalError(error.localizedDescription)
                            case .success(_):
                                print("Settings Saved")
                            }
                        }
                    } label: {
                        Text("OK, do not show again")
                            .font(Font.footnote)
                    }
                    .padding(.top,10)
                }
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
                model.currency = Currency(symbol: Currency.SymbolType.euro)
                model.listOfProductsAndPrices = [
                    PairProductPrice(id: "B5B3B40E-F71E-418F-8D8A-8C9ED951F728", name: "*1L NECTAR GOYAVE", price: 3.0, isNewItem: false, imageId: Optional("1111"), box: VNDetectedObjectObservation(boundingBox: CGRect(x: 0.146138, y: 0.733703, width: 0.725036, height: 0.0208154))),
                    PairProductPrice(id: "87EB6473-461F-44FB-894B-F457029403E5", name: "6 *250G CAMEMBERT CDL", price: 1.75, isNewItem: false, imageId: Optional("1111"), box: VNDetectedObjectObservation(boundingBox: CGRect(x: 0.106122, y: 0.717897, width: 0.766941, height: 0.0196032))),
                    PairProductPrice(id: "365D904B-EE0A-4ECD-B1C4-6CB58F2EB83F", name: "6 *2X125G PALETS BRET", price: 1.3, isNewItem: false, imageId: Optional("1111"), box: VNDetectedObjectObservation(boundingBox: CGRect(x: 0.108054, y: 0.701252, width: 0.766469, height: 0.0195545))),
                    PairProductPrice(id: "F4A440FC-472C-4289-81F6-EA766E3C264C", name: "6 400G SCE BOLOGNAI.", price: 2.15, isNewItem: false, imageId: Optional("1111"), box: VNDetectedObjectObservation(boundingBox: CGRect(x: 0.108002, y: 0.685683, width: 0.766056, height: 0.0185758))),
                    PairProductPrice(id: "8B3629F3-B736-4005-BD8E-B9BEFCFEEA60", name: "6 500G COLLEZIONE", price: 1.19, isNewItem: false, imageId: Optional("1111"), box: VNDetectedObjectObservation(boundingBox: CGRect(x: 0.108132, y: 0.668968, width: 0.765657, height: 0.0180166))),
                    PairProductPrice(id: "46C88D76-4790-46F6-9423-9E9DB03B2385", name: "50ML DEO NIVEA", price: 8.25, isNewItem: false, imageId: Optional("1111"), box: VNDetectedObjectObservation(boundingBox: CGRect(x: 0.162281, y: 0.652253, width: 0.709883, height: 0.0175031))),
                    PairProductPrice(id: "80B428D9-4179-4911-A4C6-15FF967D19DF", name: "75ML DENT PROT PAR", price: 5.55, isNewItem: false, imageId: Optional("1111"), box: VNDetectedObjectObservation(boundingBox: CGRect(x: 0.163669, y: 0.618901, width: 0.709025, height: 0.0174288))),
                    PairProductPrice(id: "BB51DAE2-4BAD-4D95-91C9-CC0EA6C15859", name: "7 BAD I8 COMPL DURE", price: 2.38, isNewItem: false, imageId: Optional("1111"), box: VNDetectedObjectObservation(boundingBox: CGRect(x: 0.113621, y: 0.603561, width: 0.761421, height: 0.016094))),
                    PairProductPrice(id: "DF63F5FD-FCC0-4CF0-915B-B84443FC5939", name: "6 *COURGETTE", price: 2.19, isNewItem: false, imageId: Optional("1111"), box: VNDetectedObjectObservation(boundingBox: CGRect(x: 0.113158, y: 0.587573, width: 0.760522, height: 0.0163151))),
                    PairProductPrice(id: "2069589A-556E-48A1-A58B-27C37EE597B8", name: "J DCH LPM VERV CITRO", price: 3.84, isNewItem: false, imageId: Optional("1111"), box: VNDetectedObjectObservation(boundingBox: CGRect(x: 0.113012, y: 0.570444, width: 0.76138,  height:0.0168982))),
                    PairProductPrice(id: "573CEBBE-87C2-4F3D-BD67-CEEEFE0B9911", name: "C *FILET POULET CRF", price: 5.32, isNewItem: false, imageId: Optional("1111"), box: VNDetectedObjectObservation(boundingBox: CGRect(x: 0.114499, y: 0.538881, width: 0.75927,  height:0.0151428))),
                    PairProductPrice(id: "D900EB73-F2B2-4396-B70F-25A679B8079B", name: "6 *GACHE TRANCHE FOUR", price: 2.44, isNewItem: false, imageId: Optional("1111"), box: VNDetectedObjectObservation(boundingBox: CGRect(x: 0.113158, y: 0.522892, width: 0.762409, height: 0.0146631))),
                    PairProductPrice(id: "D6F5F6D2-FB7A-4562-8310-F5F6322EC351", name: "7 LABELLO ORIGINAL", price: 3.28, isNewItem: false, imageId: Optional("1111"), box: VNDetectedObjectObservation(boundingBox: CGRect(x: 0.111475, y: 0.505631, width: 0.764571, height: 0.0153066))),
                    PairProductPrice(id: "D041D2CF-7FC6-4D49-AF7E-7F6EF68E6217", name: "7 PAIC XLS ACTIF FRD", price: 2.05, isNewItem: false, imageId: Optional("1111"), box: VNDetectedObjectObservation(boundingBox: CGRect(x: 0.113443, y: 0.473182, width: 0.762698, height: 0.0149828))),
                    PairProductPrice(id: "F6C0BB99-A549-48D9-830A-778B9602FB8D", name: "ORAL B BROSSETTES", price: 10.9, isNewItem: false, imageId: Optional("1111"), box: VNDetectedObjectObservation(boundingBox: CGRect(x: 0.167544, y: 0.490189, width: 0.707182, height: 0.0145087)))]
                model.images = [IdentifiedImage(id: "1111", image: UIImage(named: "sample_receipt_scan"))]
                model.receiptName = "Market"
            }
    }
}

