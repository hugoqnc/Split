//
//  CurrentExpenses.swift
//  ReceiptSplitter
//
//  Created by Hugo Queinnec on 05/01/2022.
//

import SwiftUI

struct CurrentExpensesRow: View {
    @EnvironmentObject var model: ModelData
    
    var body: some View {
        ScrollView(.horizontal){
            HStack {
                ForEach(model.users) { user in
                    VStack{
                        Text(user.name)
                            .font(.caption)
                        Text(String(round(user.balance * 100) / 100.0)+"€")
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
        CurrentExpensesRow()
            .environmentObject(ModelData())
    }
}
