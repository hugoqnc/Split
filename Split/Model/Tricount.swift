//
//  Tricount.swift
//  Split
//
//  Created by Hugo Queinnec on 28/07/2022.
//

import Foundation
import WebKit
import UIKit

let numberOfCharactersForValidTricountID = [17, 18]

struct Tricount: Codable { //default values
    var tricountName = ""
    var tricountID = ""
    var names: [String] = []
    var status = "" // status when loaded from network
}


class TricountViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var tricountID: String!
    var hasLoaded = false
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        let myURL = URL(string: "https://api.tricount.com/displayTricount.jsp?tricountID=\(tricountID ?? "")&acceptGACookies=true")
        //print(myURL)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
    
    func setTricountID(tricountID: String){
        self.tricountID = tricountID
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Finished navigating to url")
        hasLoaded = true
    }
}

func getInfoFromTricount(tricountID: String) async throws -> Tricount {
    let tricountViewController = TricountViewController()
    await tricountViewController.setTricountID(tricountID: tricountID)
    await tricountViewController.loadView()
    await tricountViewController.viewDidLoad()
    
    let webView = await tricountViewController.webView!
    var tricount = Tricount()
    tricount.tricountID = tricountID
    
    // Wait for page to load before executing JavaScript
    let maxTime = 10.0
    var time = 0.0
    let checkTimeInterval = 0.1
    var hasLoaded = false
    
    while time<maxTime && !hasLoaded {
        print("time: \(time)")
        try await Task.sleep(nanoseconds: UInt64(checkTimeInterval * Double(NSEC_PER_SEC)))
        hasLoaded = await tricountViewController.hasLoaded
        time += checkTimeInterval
    }
    
    // Here the page is loaded. We still need to wait for the Tricount UI to load, which supposedly takes a fixed amount of time, <1.2sc
    try await Task.sleep(nanoseconds: UInt64(1.2 * Double(NSEC_PER_SEC)))
    
    
    // Continuations help from:
    //  https://www.hackingwithswift.com/quick-start/concurrency/how-to-use-continuations-to-convert-completion-handlers-into-async-functions
    //  https://stackoverflow.com/questions/70329835/call-to-main-actor-isolated-instance-method-xxx-in-a-synchronous-nonisolated-con
    //  https://stackoverflow.com/questions/39793459/xcode-8-ios-10-starting-webfilter-logging-for-process (remove warnings)
    
    let getTricountName = #"document.querySelector('div[class="tricountTitle"]').textContent"#
    let tricountName: String = await withCheckedContinuation { continuation in

        Task{
            await webView.evaluateJavaScript(getTricountName) { res, error in
                if let result = res {
                    var tricountName = String(describing: result)
                    let start = tricountName.index(tricountName.startIndex, offsetBy: 10)
                    let end = tricountName.index(tricountName.endIndex, offsetBy: -1)
                    tricountName = String(tricountName[start..<end])
                    //print(tricountName)
                    continuation.resume(returning: tricountName)
                } else {
                    continuation.resume(returning: "")
                }
            }
        }
    }
    
    //print("async tricountName:"+tricountName)
    
    
    let getNames = #"[...document.querySelectorAll('div[class="identifiezVousFocusPanel"]')].map(div => div.textContent)"#
    let names: [String] = await withCheckedContinuation { continuation in

        Task{
            await webView.evaluateJavaScript(getNames) { res, error in
                if let result = res {
                    let namesString = String(describing: result)
                    //print(namesString)
                    var names = namesString.components(separatedBy: "\n")
                    names.remove(at: 0)
                    names.remove(at: names.count-1)
                    for i in names.indices {
                        names[i] = names[i].trimmingCharacters(in: .whitespaces)
                        if i != names.count-1 {
                            names[i] = String(names[i].dropLast())
                        }
                    }
                    continuation.resume(returning: names)
                } else {
                    continuation.resume(returning: [])
                }
            }
        }
    }
    
    //print("async names:"+names.description)
    
    tricount.tricountName = tricountName
    tricount.names = names
    
    if (tricountName == "" || names == []) && !hasLoaded {
        // case of a network failure
        tricount.status = "NETWORK_FAILURE"
    } else if (tricountName == "" || names == []) && hasLoaded {
        // probably case of an invalid tricount ID, but it can also be due to a network failure
        tricount.status = "UNKNOWN_FAILURE"
    }
    return tricount
}
