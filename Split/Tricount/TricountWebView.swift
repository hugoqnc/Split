//
//  TricountWebView.swift
//  Split
//
//  Created by Hugo Queinnec on 27/04/2022.
//

import SwiftUI
import WebView

struct TricountWebView: View {
    @StateObject var webViewStore = WebViewStore()
    @State var errorOccured = false
    @State var success = false
    @State var counter = 0
    @State var loadingText = ""
    var maxCounter = 29
    
    var body: some View {
        ZStack {
            VStack {
                
                if counter >= 0 && counter != maxCounter {
                    Text("Success: \(String(success))")
                    Text("Error: \(String(errorOccured))")
                    
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

                    queryTricount(tricountLink: URL(string: "https://api.tricount.com/displayTricount.jsp?tricountID=mzJsYvsiSrsEDgivW&acceptGACookies=true")!, shopName: "Migros", payer: "Nicolas", listOfNames: ["Hugo", "Corentin", "Nicolas"], listOfAmounts: [3.1, 7.89, 2.24], seconds1: 2.0, seconds2: 0.1)
                } label: {
                    Text("Export to Tricount")
                }
            .buttonStyle(.borderedProminent)
            }
            
            WebView(webView: webViewStore.webView)
                .hidden()
        }
        
    }
    
    func queryTricount(tricountLink: URL, shopName: String, payer: String, listOfNames: [String], listOfAmounts: [Double], seconds1: Double, seconds2: Double){
        
        counter += 2
        
        self.webViewStore.webView.load(URLRequest(url: tricountLink))
        
        loadingText = "Loading Tricount API"

        DispatchQueue.main.asyncAfter(deadline: .now() + seconds1/6) {
            counter += Int(seconds1)
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds1/6) {
                counter += Int(seconds1)
                DispatchQueue.main.asyncAfter(deadline: .now() + seconds1/6) {
                    counter += Int(seconds1)
                    DispatchQueue.main.asyncAfter(deadline: .now() + seconds1/6) {
                        counter += Int(seconds1)
                        DispatchQueue.main.asyncAfter(deadline: .now() + seconds1/6) {
                            counter += Int(seconds1)
                        }
                    }
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds1) {
            
            if !self.webViewStore.webView.isLoading {
                loadingText = "Exporting Transaction"
                
                counter += Int(seconds1)
                
                let fillForm = "[...document.querySelectorAll('div[class=\"identifiezVousFocusPanel\"]')].find(name => name.textContent==\"Hugo\").click()"
                self.webViewStore.webView.evaluateJavaScript(fillForm, completionHandler: completionFunction)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + seconds2) {
                    counter += 2
                    
                    // Add expense
                    self.webViewStore.webView.evaluateJavaScript("document.querySelector('a[class=\"footerPanelText\"]').click()", completionHandler: completionFunction)
                                    
                    // Fill details
                    self.webViewStore.webView.evaluateJavaScript(#"document.querySelectorAll('input[class="inputTextField"]')[0].value = "\#(shopName)""#, completionHandler: completionFunction)
                    self.webViewStore.webView.evaluateJavaScript(#"document.querySelector('select[class="inputDropDown"]').value = "\#(payer)""#, completionHandler: completionFunction)
                    self.webViewStore.webView.evaluateJavaScript(#"document.querySelectorAll('input[class="inputTextField"]')[2].value = "\#(listOfAmounts.reduce(0, +))""#, completionHandler: completionFunction)
                    self.webViewStore.webView.evaluateJavaScript("document.querySelector('a[class=\"detailsLink\"]').click()", completionHandler: completionFunction)
                    
                    // Fill individual prices
                    self.webViewStore.webView.evaluateJavaScript("ev = new CustomEvent('change', { isTrusted: false })", completionHandler: nil)
                    self.webViewStore.webView.evaluateJavaScript("users = [...users = document.querySelectorAll('div[style=\"width: 300px;\"]')]", completionHandler: completionFunction)
                    
                    for (index, name) in listOfNames.enumerated() {
                        self.webViewStore.webView.evaluateJavaScript(#"users.find(name => name.innerText.includes("\#(name)")).querySelector('input[class="repartitionAmountField"]').value = "\#(listOfAmounts[index])""#, completionHandler: completionFunction)
                        self.webViewStore.webView.evaluateJavaScript(#"users.find(name => name.innerText.includes("\#(name)")).querySelector('input[class="repartitionAmountField"]').dispatchEvent(ev)"#, completionHandler: completionFunction)
                    }
                    
                    // Save
                    self.webViewStore.webView.evaluateJavaScript("document.querySelector('a[class=\"footerPanelText\"]')", completionHandler: { (object, error) in //.click()
                            if error == nil {
                                counter += 1
                                success = true
                            } else {
                                errorOccured = true
                            }
                    })
                                                                                 
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
            //print(counter)
        } else {
            errorOccured = true
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
        TricountWebView()
    }
}
