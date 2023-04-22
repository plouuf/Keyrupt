//
//  KeyruptTests.swift
//  KeyruptTests
//
//  Created by ploouf on 2022-10-16.
//

import XCTest
@testable import Keyrupt

final class KeyruptTests: XCTestCase {


    func testSnippetMatching() throws {
        let snippet = Snippet(trigger: "xname", content: "ploouf")
        XCTAssert(snippet.matches("xname"))
        XCTAssert(snippet.matches(" xname"))
        XCTAssert(snippet.matches("test xname"))
        XCTAssert(!snippet.matches("xnot"))
        XCTAssert(!snippet.matches("xnam"))
        XCTAssert(!snippet.matches("thexname"))
    }

}