//
//  InputItemDetails.swift
//  Split
//
//  Created by Hugo Queinnec on 28/01/2022.
//

import SwiftUI

struct InputItemDetails: View {
    internal init(title: String, message: String, placeholder1: String = "", placeholder2: String = "", initialText: String? = nil, initialDouble: Double? = nil, initialSelections: [UUID]? = nil, accept: String = "Done", cancel: String = "Cancel", action: @escaping (String?, Double?, [UUID]?) -> ()) {
        self.title = title
        self.message = message
        self.placeholder1 = placeholder1
        self.placeholder2 = placeholder2
        self.initialText = initialText
        self.initialDouble = initialDouble
        self.initialSelections = initialSelections
        self.accept = accept
        self.cancel = cancel
        self.action = action
        
        if initialText != nil {
            _textState = State(initialValue: initialText!)
        } else {
            _textState = State(initialValue: "")
        }
        if initialDouble != nil {
            _doubleState = State(initialValue: initialDouble!)
        } else {
            _doubleState = State(initialValue: 0.0)
        }
        if initialSelections != nil {
            _selectionsState = State(initialValue: initialSelections!)
        } else {
            _selectionsState = State(initialValue: [])
        }
    }
    
    @EnvironmentObject var model: ModelData
    @Environment(\.dismiss) var dismiss
    
    var title: String
    var message: String
    var placeholder1: String = ""
    var placeholder2: String = ""
    var initialText: String?
    var initialDouble: Double?
    var initialSelections: [UUID]?
    var accept: String = "Done"
    var cancel: String = "Cancel"
    var action: (String?, Double?, [UUID]?) -> ()
    
    @State private var textState: String
    @State private var doubleState: Double
    @State private var selectionsState: [UUID]
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    
                    HStack(alignment: .center) {
                        Image(systemName: "square.and.pencil")
                            .frame(width: 30, height: 30)
                            .font(.largeTitle)
                            .foregroundColor(.primary)
                            .padding()

                        VStack(alignment: .leading, spacing: 2) {
                            Text(title)
                                .font(.headline)
                                .foregroundColor(.primary)

                            Text(message)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        
                    }
                    .padding(.horizontal)
                    .listRowBackground(Color.clear)
                    
                    Section {
                        TextField(placeholder1, text: $textState)
                            
                        TextField(placeholder2, value: $doubleState, format: .number)
                            
                            .keyboardType(.decimalPad)

                    } header: {
                        Text("Name and Price")
                    }
                    
                    if initialSelections != nil{
                        SelectableItems(users: model.users, selections: $selectionsState)
                            .padding(.vertical, 10)
                            
                    }
                }

            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        action(nil,nil,nil)
                        dismiss()
                    } label: {
                        Text(cancel)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        action(textState, doubleState, selectionsState)
                        dismiss()
                    } label: {
                        Text(accept)
                            .bold()
                    }
                    .disabled(textState.isEmpty || (initialSelections != nil) ? ((textState==initialText && doubleState==initialDouble && selectionsState==initialSelections) || selectionsState.isEmpty) : (textState==initialText && doubleState==initialDouble))
                }
            }
            .navigationBarTitle(Text(""), displayMode: .inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .interactiveDismissDisabled()
    }
}

struct InputItemDetails_Previews: PreviewProvider {
    static let model: ModelData = {
        var model = ModelData()
        model.users = [User(name: "Hugo"), User(name: "Lucas"), User(name: "Thomas")]
        model.listOfProductsAndPrices = [PairProductPrice(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBB", name: "Potato Wedges 1kg", price: 4.99), PairProductPrice(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBC", name: "Finger Fish", price: 1.27), PairProductPrice(id: "D401ECD5-109F-408D-A65E-E13C9B3EBDBD", name: "Ice Cream Strawberry", price: 3.20)]
        model.listOfProductsAndPrices[0].chosenBy = [model.users[0].id]
        //model.listOfProductsAndPrices[1].chosenBy = [model.users[0].id, model.users[1].id]
        //model.listOfProductsAndPrices[2].chosenBy = [model.users[0].id, model.users[1].id, model.users[2].id]
        return model
    }()
    
    static var previews: some View {
        //Text("")
            //.sheet(isPresented: .constant(true)) {
                InputItemDetails(title: "Modify item",
                                 message:"You can change the name and the price of this item",
                                 placeholder1: "Name",
                                 placeholder2: "Price",
                                 initialText: "Potato Wedges",
                                 initialDouble: 3.85,
                                 initialSelections: [UUID()],
                                 action: {_,_,_ in
                                  })
                    .environmentObject(model)
            //}
    }
}
