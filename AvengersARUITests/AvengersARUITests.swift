//
//  AvengersARUITests.swift
//  AvengersARUITests
//
//  Created by Tim Shim on 8/28/19.
//  Copyright © 2019 Tim Shim. All rights reserved.
//

import XCTest
@testable import AvengersAR

class AvengersARUITests: XCTestCase {

    var sut: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false

        sut = XCUIApplication()
        sut.launch()
    }

    override func tearDown() {
        super.tearDown()
    }

}
