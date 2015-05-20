//
//  InterstellarTests.swift
//  InterstellarTests
//
//  Created by Jens Ravens on 16/05/15.
//  Copyright (c) 2015 nerdgeschoss GmbH. All rights reserved.
//

import XCTest
import Interstellar

class InterstellarTests: XCTestCase {
    
    func greeter(subject: String) -> Result<String> {
        if count(subject) > 0 {
            return .Success(Box("Hello \(subject)"))
        } else {
            let error: NSError = NSError(domain: "No one to greet!", code: 404, userInfo: nil)
            return .Error(error)
        }
    }
    
    func identity(a: String) -> Result<String> {
        return .Success(Box(a))
    }
    
    func asyncIdentity(a: String, completion: Result<String>->Void) {
        completion(identity(a))
    }
    
    func testMappingASignal() {
        let greeting = Signal("World").map { subject in
            "Hello \(subject)"
        }
        XCTAssertEqual(greeting.peek()!, "Hello World")
    }
    
    func testBindingASignal() {
        let greeting = Signal("World").bind(greeter).peek()!
        XCTAssertEqual(greeting, "Hello World")
    }
    
    func testError() {
        let greeting = Signal("").bind(greeter).peek()
        XCTAssertNil(greeting)
    }
    
    func testSubscription() {
        let signal = Signal<String>()
        let expectation = expectationWithDescription("subscription not completed")
        signal.next { a in
            expectation.fulfill()
        }
        signal.update(Result.Success(Box("Hello")))
        waitForExpectationsWithTimeout(0.2, handler: nil)
    }
    
    func testComposition() {
        let myIdent = identity |> asyncIdentity
        let anotherIndent = asyncIdentity |> identity
        let asyncSyncThing = Thread.background |> identity |> Thread.main
    }
}
