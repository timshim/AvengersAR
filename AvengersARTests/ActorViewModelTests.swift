//
//  ActorViewModelTests.swift
//  AvengersARTests
//
//  Created by Tim Shim on 8/30/19.
//  Copyright © 2019 Tim Shim. All rights reserved.
//

import XCTest
@testable import AvengersAR

class ActorViewModelTests: XCTestCase {

    var sut: ActorViewModel!
    var mockNetworkService: MockNetworkService!
    var api: MovieService!

    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        api = MovieService(networkService: mockNetworkService)
        sut = ActorViewModel(api: api)
    }

    override func tearDown() {
        sut = nil
        mockNetworkService = nil
        api = nil
        super.tearDown()
    }

    func test_fetchActorDetails_returnsData() {
        sut.fetchActorDetails(name: "Robert Downey Jr.") { (actor, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(actor)
        }
    }

    func test_fetchActorDetails_returnsError() {
        mockNetworkService.returnsError = true
        sut.fetchActorDetails(name: "Robert Downey Jr.") { (actor, error) in
            XCTAssertNotNil(error)
        }
    }

}
