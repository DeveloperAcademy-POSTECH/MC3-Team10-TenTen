//
//  ModelTest.swift
//  OverTheRainbowTests
//
//  Created by Leo Bang on 2022/07/20.
//

import XCTest
@testable import OverTheRainbow
import RealmSwift

class ModelTest: XCTestCase {
//    var realm: Realm?

    override func setUpWithError() throws {
//        let config = Realm.Configuration(inMemoryIdentifier: "ModelTest")
//        realm = try! Realm(configuration: config)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPet_add() throws {
//        let pet1 = Pet("name", "species", imgUrl: nil, birth: Date.now, weight: 12)
//        try! realm!.write {
//            realm!.add(pet1)
//        }
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}