//
//  TricountAddSheet.swift
//  Split
//
//  Created by Hugo Queinnec on 28/07/2022.
//

import SwiftUI

struct TricountAddSheet: View {
    @Binding var tricountList: [Tricount]
    
    @Environment(\.dismiss) var dismiss
    @State private var tricount = Tricount()
    @State private var tricountLinkInput = ""
    @State private var inProgress = false
    
    var tricountIdInput: String {
        get {
            let id = (tricountLinkInput.components(separatedBy: "/").last ?? "").trimmingCharacters(in: .whitespaces)
            return id
        }
    }
    
    // test tricount: aqFUjtBCMGOyLQhZjq
    
    var body: some View {
        NavigationView {
            VStack {
                
                Form {
                    Section {
                        VStack {
                            HStack(alignment: .center) {
                                Image(systemName: "plus.forwardslash.minus")
                                    .frame(width: 30, height: 30)
                                    .font(.largeTitle)
                                    .foregroundColor(.primary)
                                    .padding()
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Add a Tricount")
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                    
                                    Text("Paste below the share link (or ID) of a Tricount.")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                                
                            }
                            .padding(.horizontal)
                            
                            // Error message
                            Group {
                                Group {
                                    if tricount.status == "UNKNOWN_FAILURE" {
                                        InfoBlock(color: .red, icon: "xmark.octagon", title: "Nothing found", subtitle: "Please verify your Tricount link or your internet connection")
                                    } else if tricount.status == "NETWORK_FAILURE" {
                                        InfoBlock(color: .red, icon: "wifi.slash", title: "Connection failure", subtitle: "Please verify your internet connection and start again")
                                    }
                                }
                                .transition(.scale)
                            }
                            .padding(.horizontal)
                            .padding(.top)
                        }
                    }
                    .listRowBackground(Color.clear)
                    
                    Section {
                        TextField("Tricount Link or ID", text: $tricountLinkInput)
                    }
                }
                .disabled(inProgress)
                

            }
            .animation(.easeInOut, value: tricount.status)
            .navigationBarTitle("", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                    }
                    //.tint(.red)
                    .disabled(inProgress)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    if inProgress {
                        ProgressView()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        Task {
                            inProgress = true
                            do {
                                tricount = Tricount() //reset in case of previous errors
                                tricount = try await getInfoFromTricount(tricountID: tricountIdInput)
                                self.tricount = tricount
                                print(tricount)
                            } catch {
                                tricount.status = "UNKNOWN_FAILURE"
                            }
                            inProgress = false
                            
                            if tricount.status == "" { //success
                                tricountList.removeAll { tricount2 in // in case this Tricount is already present, update it (remove then add)
                                    return tricount2.tricountID == tricount.tricountID
                                }
                                tricountList.append(tricount)
                                dismiss()
                            }
                        }
                    } label: {
                        Text("Add")
                            .bold()
                    }
                    .disabled(tricountLinkInput == "" || inProgress)
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .interactiveDismissDisabled(inProgress)
    }
}

struct TricountAddSheet_Previews: PreviewProvider {
    static var previews: some View {
        TricountAddSheet(tricountList: .constant([]))
    }
}
