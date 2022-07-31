//
//  TricountAddSheet.swift
//  Split
//
//  Created by Hugo Queinnec on 28/07/2022.
//

import SwiftUI

struct TricountAddSheet: View {
    @State var tricountName = ""
    @State var names = [""]
    
    var body: some View {
        
        VStack {
            Text(tricountName)
            Text(names.description)
            
            Button {
                Task {
                    do {
                        let tricount = try await getInfoFromTricount(tricountID: "aqFUjtBCMGOyLQhZjq")
                        tricountName = tricount.tricountName
                        names = tricount.names
                        print(tricount)
                        
                    } catch {
                        // .. handle error
                    }
                }

            } label: {
                Text("Request")
            }
        }
    }
}

struct TricountAddSheet_Previews: PreviewProvider {
    static var previews: some View {
        TricountAddSheet()
    }
}
