//
//  CurrentExpenses.swift
//  ReceiptSplitter
//
//  Created by Hugo Queinnec on 05/01/2022.
//

import SwiftUI

struct CurrentExpensesRow: View {
    var users: [User]
    
    var body: some View {
        ScrollView(.horizontal){
            HStack {
                ForEach(users) { user in
                    VStack{
                        Text(user.name)
                            .font(.caption)
                        Text(String(user.balance)+"€")
                            .font(.headline)
                    }
                    .padding()
                }
            }
            .padding()
        }
    }
}

struct CurrentExpensesRow_Previews: PreviewProvider {
    static var previews: some View {
        CurrentExpensesRow(users: [User(name: "Hugo"), User(name: "Olivier")])
    }
}
