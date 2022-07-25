//
//  LetterStatusTest.swift
//  OverTheRainbowTests
//
//  Created by Leo Bang on 2022/07/20.
//

import XCTest
@testable import OverTheRainbow

class LetterStatusTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testEnumStringIsString() throws {
        let status: LetterStatus = .sent
        XCTAssert(status.rawValue == "Sent")
    }
}
