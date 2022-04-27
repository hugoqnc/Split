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
    
    var body: some View {
        NavigationView {
            WebView(webView: webViewStore.webView)
                .navigationBarTitle(Text(verbatim: webViewStore.title ?? ""), displayMode: .inline)
                .navigationBarItems(trailing: HStack {
                    Button(action: goBack) {
                        Image(systemName: "chevron.left")
                            .imageScale(.large)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 32, height: 32)
                    }.disabled(!webViewStore.canGoBack)
                    Button(action: goForward) {
                        Image(systemName: "chevron.right")
                            .imageScale(.large)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 32, height: 32)
                    }.disabled(!webViewStore.canGoForward)
                })
        }.onAppear {
            
            //queryTricount(tricountLink: URL(string: "https://api.tricount.com/displayTricount.jsp?tricountID=mzJsYvsiSrsEDgivW&acceptGACookies=true")!, shopName: "Aldi Suisse", payer: "Corentin", listOfNames: ["Hugo", "Corentin", "Nicolas"], listOfAmounts: [3.1, 7.89, 2.24], seconds1: 2.0, seconds2: 0.1)
            
        }
        .navigationViewStyle(.stack)
        
    }
    
    func queryTricount(tricountLink: URL, shopName: String, payer: String, listOfNames: [String], listOfAmounts: [Double], seconds1: Double, seconds2: Double){
        
        self.webViewStore.webView.load(URLRequest(url: tricountLink))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds1) {
            let fillForm = "[...document.querySelectorAll('div[class=\"identifiezVousFocusPanel\"]')].find(name => name.textContent==\"Hugo\").click()"
            self.webViewStore.webView.evaluateJavaScript(fillForm, completionHandler: {_,_ in
                print("done!")
            })
            
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds2) {
                // Add expense
                self.webViewStore.webView.evaluateJavaScript("document.querySelector('a[class=\"footerPanelText\"]').click()", completionHandler: nil)
                
                // Fill details
                self.webViewStore.webView.evaluateJavaScript(#"document.querySelectorAll('input[class="inputTextField"]')[0].value = "\#(shopName)""#, completionHandler: nil)
                self.webViewStore.webView.evaluateJavaScript(#"document.querySelector('select[class="inputDropDown"]').value = "\#(payer)""#, completionHandler: nil)
                self.webViewStore.webView.evaluateJavaScript(#"document.querySelectorAll('input[class="inputTextField"]')[2].value = "\#(listOfAmounts.reduce(0, +))""#, completionHandler: nil)
                self.webViewStore.webView.evaluateJavaScript("document.querySelector('a[class=\"detailsLink\"]').click()", completionHandler: nil)
                
                // Fill individual prices
                self.webViewStore.webView.evaluateJavaScript("ev = new CustomEvent('change', { isTrusted: false })", completionHandler: nil)
                self.webViewStore.webView.evaluateJavaScript("users = [...users = document.querySelectorAll('div[style=\"width: 300px;\"]')]", completionHandler: nil)
                
                for (index, name) in listOfNames.enumerated() {
                    self.webViewStore.webView.evaluateJavaScript(#"users.find(name => name.innerText.includes("\#(name)")).querySelector('input[class="repartitionAmountField"]').value = "\#(listOfAmounts[index])""#, completionHandler: nil)
                    self.webViewStore.webView.evaluateJavaScript(#"users.find(name => name.innerText.includes("\#(name)")).querySelector('input[class="repartitionAmountField"]').dispatchEvent(ev)"#, completionHandler: nil)
                }
                
                // Save
                self.webViewStore.webView.evaluateJavaScript("document.querySelector('a[class=\"footerPanelText\"]').click()", completionHandler: nil)
                                                             
            }
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
