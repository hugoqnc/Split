//
//  Tricount.swift
//  Split
//
//  Created by Hugo Queinnec on 28/07/2022.
//

import Foundation
import WebKit
import UIKit

let timeForTricountUIToLoad = 1.2 // seconds, after it has loaded its ressources from the internet

struct Tricount: Codable, Hashable { //default values
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
        hasLoaded = false
        let myURL = URL(string: "https://api.tricount.com/displayTricount.jsp?tricountID=\(tricountID ?? "")&acceptGACookies=true")
        //print(myURL)
        let myRequest = URLRequest(url: myURL ?? URL(string: "https://api.tricount.com/")!)
        webView.load(myRequest)
    }
    
    func setTricountID(tricountID: String){
        self.tricountID = tricountID
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Finished navigating to url")
        hasLoaded = true
    }
    
    func evaluateJavaScriptWrapper(_ script: String) async throws -> String {
        let result: String = await withCheckedContinuation { continuation in
            Task{
                webView.evaluateJavaScript(script) { res, error in
                    //print(res)
                    if error == nil {
                        continuation.resume(returning: "SUCCESS")
                    } else {
                        print(error as Any)
                        if (error! as NSError).code == 5 {
                            continuation.resume(returning: "SUCCESS")
                        } else {
                            continuation.resume(returning: "FAIL")
                        }
                    }
                }
            }
        }
        //try await Task.sleep(nanoseconds: UInt64(0.05 * Double(NSEC_PER_SEC)))
        return result
    }
}

func getInfoFromTricount(tricountID: String) async throws -> Tricount {
    let tricountViewController = await TricountViewController()
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
    try await Task.sleep(nanoseconds: UInt64(timeForTricountUIToLoad * Double(NSEC_PER_SEC)))
    
    
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
                        // Decode Unicode to UTF8 (for special characters)
                        names[i] = names[i].decoded.replacingOccurrences(of: "\"", with: "")
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


func compatibleTricounts(users: [User], tricountList:[Tricount]) -> [Tricount] {
    var compatibleTricounts: [Tricount] = []
    
    let nameList = users.map { user in
        return user.name
    }
    
    for tricount in tricountList {
        let intersection = Array(Set(nameList).intersection(tricount.names))
        if intersection.containsSameElements(as: nameList) {
            compatibleTricounts.append(tricount)
        }
    }
    
    return compatibleTricounts
}

func exactTricounts(users: [User], tricountList:[Tricount]) -> [Tricount] {
    var exactTricounts: [Tricount] = []
    
    let nameList = users.map { user in
        return user.name
    }
    
    for tricount in tricountList {
        if tricount.names.containsSameElements(as: nameList) {
            exactTricounts.append(tricount)
        }
    }
    
    return exactTricounts
}

func addToTricount(tricountID: String, shopName: String, payerName: String, listOfNames: [String], listOfAmounts: [Double]) async throws -> String {
    //timer
    let start = CFAbsoluteTimeGetCurrent()
    
    let tricountViewController = await TricountViewController()
    await tricountViewController.setTricountID(tricountID: tricountID)
    await tricountViewController.loadView()
    await tricountViewController.viewDidLoad()
    
    //let webView = await tricountViewController.webView!
    
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
    print("Start Wait 1")
    try await Task.sleep(nanoseconds: UInt64(timeForTricountUIToLoad * Double(NSEC_PER_SEC)))
    print("End Wait 1")
    
    
    // Continuations help from:
    //  https://www.hackingwithswift.com/quick-start/concurrency/how-to-use-continuations-to-convert-completion-handlers-into-async-functions
    //  https://stackoverflow.com/questions/70329835/call-to-main-actor-isolated-instance-method-xxx-in-a-synchronous-nonisolated-con
    //  https://stackoverflow.com/questions/39793459/xcode-8-ios-10-starting-webfilter-logging-for-process (remove warnings)
    
    var counter = 0
    let maxCounter = 10 + 2*listOfNames.count
    
    func counterUpdate(res: String) {
        if res=="SUCCESS" {
            counter += 1
        }
    }

    let fillForm = #"[...document.querySelectorAll('div[class="identifiezVousFocusPanel"]')].find(name => name.textContent=="\#(payerName)").click()"#
    var res = try await tricountViewController.evaluateJavaScriptWrapper(fillForm)
    counterUpdate(res: res)

    print("Start Wait 2")
    try await Task.sleep(nanoseconds: UInt64(timeForTricountUIToLoad/2 * Double(NSEC_PER_SEC)))
    print("End Wait 2")

    // Add expense
    res = try await tricountViewController.evaluateJavaScriptWrapper("document.querySelector('a[class=\"footerPanelText\"]').click()")
    counterUpdate(res: res)

    // Fill details
    res = try await tricountViewController.evaluateJavaScriptWrapper(#"document.querySelectorAll('input[class="inputTextField"]')[0].value = "\#(shopName)""#)
    counterUpdate(res: res)
    res = try await tricountViewController.evaluateJavaScriptWrapper(#"document.querySelector('select[class="inputDropDown"]').value = "\#(payerName)""#)
    counterUpdate(res: res)
    res = try await tricountViewController.evaluateJavaScriptWrapper(#"document.querySelectorAll('input[class="inputTextField"]')[2].value = "\#(listOfAmounts.reduce(0, +))""#)
    counterUpdate(res: res)
    res = try await tricountViewController.evaluateJavaScriptWrapper("document.querySelector('a[class=\"detailsLink\"]').click()")
    counterUpdate(res: res)

    // Fill individual prices
    res = try await tricountViewController.evaluateJavaScriptWrapper("ev = new CustomEvent('change', { isTrusted: false })")
    counterUpdate(res: res)
    res = try await tricountViewController.evaluateJavaScriptWrapper("users = [...users = document.querySelectorAll('div[style=\"width: 300px;\"]')]")
    counterUpdate(res: res)

    for (index, name) in listOfNames.enumerated() {
        res = try await tricountViewController.evaluateJavaScriptWrapper(#"users.find(name => name.innerText.includes("\#(name)")).querySelector('input[class="repartitionAmountField"]').value = "\#(listOfAmounts[index])""#)
        counterUpdate(res: res)
        res = try await tricountViewController.evaluateJavaScriptWrapper(#"users.find(name => name.innerText.includes("\#(name)")).querySelector('input[class="repartitionAmountField"]').dispatchEvent(ev)"#)
        counterUpdate(res: res)
    }

    print("Start Wait 3")
    try await Task.sleep(nanoseconds: UInt64(timeForTricountUIToLoad/4 * Double(NSEC_PER_SEC)))
    print("End Wait 3")

    if counter==maxCounter-2 {
        //res = try await tricountViewController.evaluateJavaScriptWrapper("document.querySelector('a[class=\"footerPanelText\"]').textContent")
        res = try await tricountViewController.evaluateJavaScriptWrapper("document.querySelector('a[class=\"footerPanelText\"]').click()")
        counterUpdate(res: res)
        //res = try await tricountViewController.evaluateJavaScriptWrapper("document.querySelector('a[class=\"footerPanelText\"]').textContent")
        //res = try await tricountViewController.evaluateJavaScriptWrapper(#"[...document.querySelectorAll('div[class="paymentListContent"]')].map(x => x.textContent);"#)
        try await Task.sleep(nanoseconds: UInt64(timeForTricountUIToLoad/4 * Double(NSEC_PER_SEC)))
    }
    
    // Verification
    //res = try await verifyTricountTransaction(tricountID: "", shopName: shopName, payerName: payerName, tricountViewControllerOpt: tricountViewController)
    //counterUpdate(res: res)
    counterUpdate(res: "SUCCESS")
    
    let diff = CFAbsoluteTimeGetCurrent() - start
    print("Took \(diff) seconds")
    
    return hasLoaded ? (counter==maxCounter ? "SUCCESS" : "UNKNOWN_FAILURE") : "NETWORK_FAILURE"
}


func verifyTricountTransaction(tricountID: String, shopName: String, payerName: String, tricountViewControllerOpt: TricountViewController?) async throws -> String {
    var tricountViewController: TricountViewController
    if let unwrapped = tricountViewControllerOpt {
        tricountViewController = unwrapped
    } else {
        tricountViewController = await TricountViewController()
    }
    
    if !tricountID.isEmpty {
        await tricountViewController.setTricountID(tricountID: tricountID)
        await tricountViewController.loadView()
    }
    await tricountViewController.viewDidLoad()
        
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
    print("Start Wait 1")
    try await Task.sleep(nanoseconds: UInt64(timeForTricountUIToLoad * Double(NSEC_PER_SEC)))
    print("End Wait 1")
    

    let fillForm = #"[...document.querySelectorAll('div[class="identifiezVousFocusPanel"]')].find(name => name.textContent=="\#(payerName)").click()"#
    let _ = try await tricountViewController.evaluateJavaScriptWrapper(fillForm)

    print("Start Wait 2")
    try await Task.sleep(nanoseconds: UInt64(timeForTricountUIToLoad/2 * Double(NSEC_PER_SEC)))
    print("End Wait 2")

    // Verify transaction
    let webView = await tricountViewController.webView!
    
    let getTransactions = #"[...document.querySelectorAll('a[class="paymentListContent"]')].map(e => e.textContent)"#
    let transactions: [String] = await withCheckedContinuation { continuation in

        Task{
            await webView.evaluateJavaScript(getTransactions) { res, error in
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
                        // Decode Unicode to UTF8 (for special characters)
                        names[i] = names[i].decoded.replacingOccurrences(of: "\"", with: "")
                    }
                    continuation.resume(returning: names)
                } else {
                    continuation.resume(returning: [])
                }
            }
        }
    }
    
    //print(transactions)
    print(transactions.last ?? "")
    
    var res = "FAIL"
    if transactions.last == shopName {
        res = "SUCCESS"
    }
    
    return res
}
