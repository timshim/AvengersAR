//
//  AvengersARTests.swift
//  AvengersARTests
//
//  Created by Tim Shim on 8/28/19.
//  Copyright © 2019 Tim Shim. All rights reserved.
//

import XCTest
@testable import AvengersAR

class AvengersARTests: XCTestCase {

    var sut: HomeViewModel!

    override func setUp() {
        super.setUp()
        sut = HomeViewModel()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_findFaces_returnsArrayOfActors() {
        guard let testImage = UIImage(named: "TestImage") else {
            XCTFail()
            return
        }
        let expectation = XCTestExpectation(description: "Should find faces")
        sut.findFaces(testImage) { (actors, actorsInLastImage, error) in
            XCTAssertNil(error)
            guard let actors = actors else {
                XCTFail()
                return
            }
            XCTAssertTrue(actors.count > 0)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 60)
    }

}
