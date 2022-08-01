//
//  TricountAddSheet.swift
//  Split
//
//  Created by Hugo Queinnec on 28/07/2022.
//

import SwiftUI

struct TricountAddSheet: View {
    @State var tricount = Tricount()
    
    var body: some View {
        
        VStack {
            Text(tricount.tricountName)
            Text(tricount.names.description)
            Text(tricount.status)
            
            Button {
                Task {
                    do {
                        let tricount = try await getInfoFromTricount(tricountID: "aqFUjtBCMGOyLQhZjq")
                        self.tricount = tricount
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
