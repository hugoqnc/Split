//
//  TricountWebView.swift
//  Split
//
//  Created by Hugo Queinnec on 27/04/2022.
//

import SwiftUI
import WebView

struct TricountWebView: View {
    
    var payerName: String
    
    @StateObject var webViewStore = WebViewStore()
    @EnvironmentObject var model: ModelData
    
    @State var errorOccured = false
    @State var success = false
    @State var counter = 0
    @State var loadingText = ""
    @State var maxCounter = 0
    
    var seconds1 = 2.0
    var seconds2 = 0.1
    
    var body: some View {
        ZStack {
            VStack {
                
//                Text("Success: \(String(success))")
//                Text("Error: \(String(errorOccured))")
                
                Group {
                    if errorOccured {
                        HStack(alignment: .center) {
                            Image(systemName: "exclamationmark.triangle")
                                .frame(width: 30, height: 30)
                                .font(.largeTitle)
                                .foregroundColor(.red)
                                .padding()

                            VStack(alignment: .leading, spacing: 2) {
                                Text("An error occured")
                                    .font(.headline)
                                    .foregroundColor(.primary)

                                Text("Your transaction was not exported to Tricount. This may be due to an unstable internet connection, or to the fact that the usernames here are not the same as on your Tricount.")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            
                        }
                    }
                    
                    if success {
                        HStack(alignment: .center) {
                            Image(systemName: "checkmark.seal")
                                .frame(width: 30, height: 30)
                                .font(.largeTitle)
                                .foregroundColor(.green)
                                .padding()

                            VStack(alignment: .leading, spacing: 2) {
                                Text("Transaction exported!")
                                    .font(.headline)
                                    .foregroundColor(.primary)

                                Text("Your transaction has been successfully exported to Tricount.")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            
                        }
                    }
                }
                .padding(.bottom, 30)
                
                if counter > 0 && counter != maxCounter {
                    
                    ProgressView(value: Double(counter)/Double(maxCounter))
                        .animation(.easeInOut(duration: 0.1), value: counter)
                        .padding(.horizontal)
                        .font(.largeTitle)
                    
                    Text(loadingText)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Button {
                    counter = 0
                    loadingText = ""
                    if success {
                        success = false
                    }
                    if errorOccured {
                        errorOccured = false
                    }

                    queryTricount(tricountLink: URL(string: "https://api.tricount.com/displayTricount.jsp?tricountID=\(model.tricountID)&acceptGACookies=true")!, shopName: model.receiptName, payer: payerName, listOfNames: model.users.map({ user in user.name }), listOfAmounts: model.listOfProductsAndPrices.map({ pair in pair.price }), seconds1: seconds1, seconds2: seconds2)
                } label: {
                    success ? Label("Export **again** to Tricount", systemImage: "square.and.arrow.up") : errorOccured ? Label("**Retry** export to Tricount", systemImage: "square.and.arrow.up") : Label("Export to Tricount", systemImage: "square.and.arrow.up")
                }
                .buttonStyle(.borderedProminent)
                .tint(errorOccured ? Color.red : Color.accentColor)
                .opacity(success ? 0.8 : 1.0)
                .font(success ? .caption : .body)
                .padding(.top, 5)
            }
            
            WebView(webView: webViewStore.webView)
                .hidden()
        }
        .animation(.easeInOut, value: success)
        .animation(.easeInOut, value: errorOccured)
        .animation(.easeInOut, value: counter)
        
    }
    
    func queryTricount(tricountLink: URL, shopName: String, payer: String, listOfNames: [String], listOfAmounts: [Double], seconds1: Double, seconds2: Double){
        
        maxCounter = 15 + 6*Int(2*seconds1) + 2*listOfNames.count
        counter += 2
        
        self.webViewStore.webView.load(URLRequest(url: tricountLink))
        
        loadingText = "Loading Tricount API"

        DispatchQueue.main.asyncAfter(deadline: .now() + seconds1/6) {
            counter += Int(2*seconds1)
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds1/6) {
                counter += Int(2*seconds1)
                DispatchQueue.main.asyncAfter(deadline: .now() + seconds1/6) {
                    counter += Int(2*seconds1)
                    DispatchQueue.main.asyncAfter(deadline: .now() + seconds1/6) {
                        counter += Int(2*seconds1)
                        DispatchQueue.main.asyncAfter(deadline: .now() + seconds1/6) {
                            counter += Int(2*seconds1)
                        }
                    }
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds1) {
            
            if !self.webViewStore.webView.isLoading {
                loadingText = "Exporting Transaction"
                
                counter += Int(2*seconds1)
                
                let fillForm = "[...document.querySelectorAll('div[class=\"identifiezVousFocusPanel\"]')].find(name => name.textContent==\"Hugo\").click()"
                self.webViewStore.webView.evaluateJavaScript(fillForm, completionHandler: completionFunction)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + seconds2) {
                    counter += 1
                    
                    // Add expense
                    self.webViewStore.webView.evaluateJavaScript("document.querySelector('a[class=\"footerPanelText\"]').click()", completionHandler: completionFunction)
                                    
                    // Fill details
                    self.webViewStore.webView.evaluateJavaScript(#"document.querySelectorAll('input[class="inputTextField"]')[0].value = "\#(shopName)""#, completionHandler: completionFunction)
                    self.webViewStore.webView.evaluateJavaScript(#"document.querySelector('select[class="inputDropDown"]').value = "\#(payer)""#, completionHandler: completionFunction)
                    self.webViewStore.webView.evaluateJavaScript(#"document.querySelectorAll('input[class="inputTextField"]')[2].value = "\#(listOfAmounts.reduce(0, +))""#, completionHandler: completionFunction)
                    self.webViewStore.webView.evaluateJavaScript("document.querySelector('a[class=\"detailsLink\"]').click()", completionHandler: completionFunction)
                    
                    // Fill individual prices
                    self.webViewStore.webView.evaluateJavaScript("ev = new CustomEvent('change', { isTrusted: false })", completionHandler: completionFunction)
                    self.webViewStore.webView.evaluateJavaScript("users = [...users = document.querySelectorAll('div[style=\"width: 300px;\"]')]", completionHandler: completionFunction)
                    
                    for (index, name) in listOfNames.enumerated() {
                        self.webViewStore.webView.evaluateJavaScript(#"users.find(name => name.innerText.includes("\#(name)")).querySelector('input[class="repartitionAmountField"]').value = "\#(listOfAmounts[index])""#, completionHandler: completionFunction)
                        self.webViewStore.webView.evaluateJavaScript(#"users.find(name => name.innerText.includes("\#(name)")).querySelector('input[class="repartitionAmountField"]').dispatchEvent(ev)"#, completionHandler: completionFunction)
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + seconds1/3) {
                        counter += 3
                        // Save
                        if !errorOccured {
                            self.webViewStore.webView.evaluateJavaScript("document.querySelector('a[class=\"footerPanelText\"]').click()", completionHandler: { (object, error) in //.click()
                                    if error == nil && counter == maxCounter-1 {
                                        counter += 1
                                        success = true
                                    } else {
                                        errorOccured = true
                                    }
                            })
                        }
                    }
                                                                                 
                }
            } else {
                errorOccured = true
                print("Internet issue...")
            }
        }
    }
    
    func completionFunction(_ object: Any?, _ error: Error?) -> Void {
        if error == nil {
            counter += 1
            //print(object)
            //print(counter)
        } else {
            print((error! as NSError).code)
            if (error! as NSError).code == 5 {
                counter += 1
            } else {
                errorOccured = true
            }
            print(error as Any)
        }
    }
    
    func goBack() {
        webViewStore.webView.goBack()
    }
    
    func goForward() {
        webViewStore.webView.goForward()
    }
}


struct TricountWebView_Previews: PreviewProvider {
    static var previews: some View {
        TricountWebView(payerName: "Hugo")
            .environmentObject(ModelData())
    }
}
