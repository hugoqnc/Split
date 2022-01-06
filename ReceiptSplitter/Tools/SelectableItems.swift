//
//  SelectableItems.swift
//  ReceiptSplitter
//
//  Created by Hugo Queinnec on 06/01/2022.
//

import SwiftUI

struct SelectableItems: View {
    var users: [User]
    @Binding var selections: [UUID]

    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(users) { item in
                    
                        MultipleSelectionRow(title: item.name, isSelected: self.selections.contains(item.id)) {
                            if self.selections.contains(item.id) {
                                self.selections.removeAll(where: { $0 == item.id })
                            }
                            else {
                                self.selections.append(item.id)
                            }
                        }
                        //.offset(x: 30)
                    
                }
            }
        }

        
    }
}

struct MultipleSelectionRow: View {
    var title: String
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        
        if isSelected {
            Button(action: self.action) {
                VStack {
                    Image(systemName: "checkmark.circle.fill")
                    Text(self.title)
                }
            }
            .buttonStyle(.borderedProminent)
        } else {
            Button(action: self.action) {
                VStack {
                    Image(systemName: "circle")
                    Text(self.title)
                }
            }
            .buttonStyle(.bordered)
            .foregroundColor(.gray)
        }
        
    }
}

extension View {

    func conditionalModifier<M1: ViewModifier, M2: ViewModifier>
        (on condition: Bool, trueCase: M1, falseCase: M2) -> some View {
        Group {
            if condition {
                self.modifier(trueCase)
            } else {
                self.modifier(falseCase)
            }
        }
    }
}

struct SelectableItems_Previews: PreviewProvider {
    static var previews: some View {
        SelectableItems(users: [User(name: "Hugo"), User(name: "Lucas"), User(name: "Thomas")], selections: .constant([]))
    }
}
