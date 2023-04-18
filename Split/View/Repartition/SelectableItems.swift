//
//  SelectableItems.swift
//  Split
//
//  Created by Hugo Queinnec on 06/01/2022.
//

import SwiftUI

struct SelectableItems: View {
    var users: [User]
    @Binding var selections: [UUID]
    var showSelectAllButton = true
    private var boolAllSelected: Bool {
        get {
            return users.count == selections.count
        }
    }

    var body: some View {
        VStack {
            if showSelectAllButton {
                HStack {
                    Button() {
                        if boolAllSelected {
                            self.selections.removeAll()
                        }
                        else {
                            self.selections = users.map({ user in user.id })
                        }
                    } label: {
                        Text(boolAllSelected ? "Deselect all" : "Select all")
                            .animation(nil, value: boolAllSelected) // remove unecessary animation
                    }
                    .padding(.leading, 3)
                    
                    Spacer()
                }
            }
            
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
                    }
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
        
        Group {
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
                //.tint(.accentColor)
                .foregroundColor(.gray)
            }
        }
        
    }
}

struct SelectableItems_Previews: PreviewProvider {
    static var previews: some View {
        SelectableItems(users: [User(name: "Hugo"), User(name: "Lucas"), User(name: "Thomas")], selections: .constant([]))
    }
}
