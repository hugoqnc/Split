//
//  Tricount.swift
//  Split
//
//  Created by Hugo Queinnec on 28/07/2022.
//

import Foundation
import WebKit


struct Tricount: Codable { //default values
    var tricountName = ""
    var tricountID = ""
    var names: [String] = []
}


func getInfoFromTricount(tricountID: String) async throws -> Tricount {
    let webView = WKWebView()
    
    var tricount = Tricount()
    tricount.tricountID = tricountID
    
    let tricountLink = URL(string: "https://api.tricount.com/displayTricount.jsp?tricountID=\(tricountID)&acceptGACookies=true")!
    
    await webView.load(URLRequest(url: tricountLink))
    
    try await Task.sleep(nanoseconds: UInt64(2 * Double(NSEC_PER_SEC)))
    
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
    
    print("async tricountName:"+tricountName)
    
    
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
    
    print("async names:"+names.description)
    
    tricount.tricountName = tricountName
    tricount.names = names
    
    return tricount
}
