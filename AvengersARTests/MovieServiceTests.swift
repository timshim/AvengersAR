//
//  MovieServiceTests.swift
//  AvengersARTests
//
//  Created by Tim Shim on 8/30/19.
//  Copyright © 2019 Tim Shim. All rights reserved.
//

import XCTest
@testable import AvengersAR

class MovieServiceTests: XCTestCase {

    var mockNetworkService: MockNetworkService!
    var sut: MovieService!

    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        sut = MovieService(networkService: mockNetworkService)
    }

    override func tearDown() {
        sut = nil
        mockNetworkService = nil
        super.tearDown()
    }

    func test_getActorId_returns3223() {
        sut.getActorId("Robert Downey Jr.") { (id, error) in
            XCTAssertNil(error)
            XCTAssertEqual(id, 3223)
        }
    }

    func test_getActorDetails_returnsRDJ() {
        sut.getActorDetails(id: 3223) { (actor, error) in
            XCTAssertNil(error)
            if let actorName = actor?.name {
                XCTAssertEqual(actorName, "Robert Downey Jr.")
            }
        }
    }

}
