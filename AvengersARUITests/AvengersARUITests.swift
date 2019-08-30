//
//  AvengersARUITests.swift
//  AvengersARUITests
//
//  Created by Tim Shim on 8/28/19.
//  Copyright © 2019 Tim Shim. All rights reserved.
//

import XCTest
@testable import AvengersAR

/*
In order for the UI tests to run correctly, please make sure to
add the 4 test images into your simulator's photo library
 */

class AvengersARUITests: XCTestCase {

    var sut: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false

        sut = XCUIApplication()
        sut.launch()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_logoAndButtonExists() {
        let headerView = sut.collectionViews.otherElements
        let logo = headerView.containing(.image, identifier:"AvengersLogo").element
        let button = logo.children(matching: .button).element
        XCTAssertTrue(logo.exists)
        XCTAssertTrue(button.exists)
    }

    func test_labelExists() {
        let label = sut.collectionViews.staticTexts["Tap the logo to analyze a photo"]
        XCTAssertTrue(label.exists)
    }

    func test_analysisReturnsActors() {
        let collectionViews = sut.collectionViews
        collectionViews.otherElements.containing(.image, identifier:"AvengersLogo").children(matching: .button).element.tap()

        let exists = NSPredicate(format: "exists == true")
        expectation(for: exists, evaluatedWith: sut.tables.cells.element(boundBy: 2), handler: nil)
        waitForExpectations(timeout: 5, handler: nil)

        sut.tables.cells.element(boundBy: 2).tap()
        sut.collectionViews.cells.element(boundBy: 1).tap()

        let count = NSPredicate(format: "count > 0")
        expectation(for: count, evaluatedWith: collectionViews.cells, handler: nil)
        waitForExpectations(timeout: 60, handler: nil)

        collectionViews.cells.element(boundBy: 0 ).tap()
        let textView = sut.scrollViews.children(matching: .textView).element

        expectation(for: exists, evaluatedWith: textView, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
    }

    func test_nextAnalysisShowsSamePeopleAlert() {
        let collectionViews = sut.collectionViews
        let analyzeButton = collectionViews.otherElements.containing(.image, identifier:"AvengersLogo").children(matching: .button).element
        analyzeButton.tap()

        let exists = NSPredicate(format: "exists == true")
        expectation(for: exists, evaluatedWith: sut.tables.cells.element(boundBy: 2), handler: nil)
        waitForExpectations(timeout: 5, handler: nil)

        sut.tables.cells.element(boundBy: 2).tap()
        sut.collectionViews.cells.element(boundBy: 1).tap()

        let count = NSPredicate(format: "count > 0")
        expectation(for: count, evaluatedWith: collectionViews.cells, handler: nil)
        waitForExpectations(timeout: 60, handler: nil)

        sut.swipeDown()
        sut.swipeDown()

        analyzeButton.tap()

        expectation(for: exists, evaluatedWith: sut.tables.cells.element(boundBy: 2), handler: nil)
        waitForExpectations(timeout: 5, handler: nil)

        sut.tables.cells.element(boundBy: 2).tap()
        sut.collectionViews.cells.element(boundBy: 2).tap()

        let alert = sut.alerts["People from last photo"]

        expectation(for: exists, evaluatedWith: alert, handler: nil)
        waitForExpectations(timeout: 60, handler: nil)
    }

}
