//
//  MovieService.swift
//  AvengersAR
//
//  Created by Tim Shim on 8/28/19.
//  Copyright © 2019 Tim Shim. All rights reserved.
//

import UIKit

private enum MovieServiceRequest: String {
    case searchActor, getActorDetails

    func url() -> URL? {
        let host = "https://api.themoviedb.org/3"

        switch self {
        case .searchActor:
            guard let url = URL(string: host + "/search/person") else { return nil }
            return url
        case .getActorDetails:
            guard let url = URL(string: host + "/person") else { return nil }
            return url
        }
    }
}

final class MovieService {

    private var networkService: NetworkServiceProtocol
    private let apiKey: String? = {
        guard let path = Bundle.main.path(forResource: "Info", ofType: "plist") else { return nil }
        guard let dict = NSDictionary(contentsOfFile: path) else { return nil }
        guard let apiKey = dict["TMDB-API-KEY"] as? String else { return nil }

        return apiKey
    }()

    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }

    func searchActor(_ query: String) {
        guard let url = MovieServiceRequest.searchActor.url() else { return }
    }

    func getActorDetails() {
        guard let url = MovieServiceRequest.getActorDetails.url() else { return }
    }

}
