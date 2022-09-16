//
//  TricountTests.swift
//  TricountTests
//
//  Created by Hugo Queinnec on 29/08/2022.
//

import XCTest
@testable import Split_

class TricountTests: XCTestCase {
    
    let tricountID = "aqFUjtBCMGOyLQhZjq"

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func exportToTricount(shopName: String) async throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        
        let payerName = "Hugo"
        let listOfNames = ["Hugo", "Thomas", "Lucas"]
        let listOfAmounts = [1.0, 0.0, 0.0]
        
        var exportStatus = ""
        do {
            let res = try await addToTricount(tricountID: tricountID, shopName: shopName, payerName: payerName, listOfNames: listOfNames, listOfAmounts: listOfAmounts)
            print(res)
            exportStatus = res
        } catch {}
        
        XCTAssertEqual(exportStatus, "SUCCESS", "A Tricount has not been exported (\(shopName))")
    }
    
    func verification(shopName: String) async throws {
        let payerName = "Hugo"
        
        var exportStatus = ""
        do {
            let res = try await verifyTricountTransaction(tricountID: tricountID, shopName: shopName, payerName: payerName, tricountViewControllerOpt: nil)
            print(res)
            exportStatus = res
        } catch {}
        
        XCTAssertEqual(exportStatus, "SUCCESS", "The Tricount is missing (\(shopName))")
    }
    
    func testMultipleTricountExports() async throws {
        let numberOfIterations = 5
        
        for _ in 1...numberOfIterations {
            var randomID = UUID().uuidString
            randomID = String(randomID.prefix(18))
            
            try await exportToTricount(shopName: randomID)
            
            try await verification(shopName: randomID)
        }
    }

}
