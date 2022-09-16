//
//  RestrictedBrowserView.swift
//  Split
//
//  Created by Hugo Queinnec on 29/08/2022.
//

import SwiftUI
import WebKit
import Foundation
import Combine

var verboseDebug = true

class LoadingModel: ObservableObject {
    @Published var hasLoaded = false
}

struct WebView: UIViewRepresentable {
    var imageName: String
    @StateObject var model: LoadingModel
    
    // Make a coordinator to co-ordinate with WKWebView's default delegate functions
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView(frame: CGRect.zero)
        webView.navigationDelegate = context.coordinator
        //webView.allowsBackForwardNavigationGestures = true
        webView.scrollView.isScrollEnabled = true
        
        // Load a public website
        let urlString = urlString()
        let url = URL(string: urlString)!
        webView.load(URLRequest(url: url))
        
        return webView
    }
    
    func urlString() -> String {
        return (#"https://www.google.com/search?q=\#(imageName)&tbm=isch"#).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        if verboseDebug {print("Loaded: "+String(model.hasLoaded))}
    }
    
    class Coordinator : NSObject, WKNavigationDelegate {
        var parent: WebView
        
        init(_ uiWebView: WebView) {
            self.parent = uiWebView
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            if verboseDebug {print("Finished navigating to url")}
            parent.model.hasLoaded = true
        }
        
        // This function is essential for intercepting every navigation in the webview
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if let host = navigationAction.request.url?.absoluteString {
                if verboseDebug {
                    print(host)
                    print("Authorized: "+String(host.contains(parent.urlString()) || host.contains("consent.google.com")))
                }
                if host.contains(parent.urlString()) || host.contains("consent.google.com") {
                    // Navigation is authorized
                    decisionHandler(.allow)
                    return
                }
            }
            decisionHandler(.cancel)
        }
    }
}

struct RestrictedBrowserView: View {
    @Binding public var isShown: Bool
    @StateObject var model = LoadingModel()
    public var imageName: String
    
    var body: some View {
        NavigationView {
            VStack {
                //Text("\(String(model.hasLoaded))")
                WebView(imageName: imageName, model: model)
                    .ignoresSafeArea()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if !model.hasLoaded {
                        ProgressView()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isShown = false
                    } label: {
                        Text("Close")
                    }
                }
            }
        }
    }
}

struct RestrictedBrowserView_Previews: PreviewProvider {
    static var previews: some View {
        Text("Browser")
            .sheet(isPresented: .constant(true)) {
                RestrictedBrowserView(isShown: .constant(true), imageName: "camembert")
            }
    }
}
