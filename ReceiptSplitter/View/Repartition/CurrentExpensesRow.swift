//
//  CurrentExpenses.swift
//  ReceiptSplitter
//
//  Created by Hugo Queinnec on 05/01/2022.
//

import SwiftUI

struct CurrentExpensesRow: View {
    var names: [String]
    var balance: [String: Float]
    
    var body: some View {
        ScrollView(.horizontal){
            HStack {
                ForEach(names, id: \.self) { name in
                    VStack{
                        Text(name)
                            .font(.caption)
                        Text(String(balance[name]!)+"€")
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
        CurrentExpensesRow(names: ["Hugo", "Lucas", "Thomas"], balance: ["Hugo": 17.3, "Lucas": 12.65, "Thomas": 18.90])
    }
}
