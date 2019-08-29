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

    func url(id: Int? = nil) -> URL? {
        let host = "https://api.themoviedb.org/3"

        switch self {
        case .searchActor:
            guard let url = URL(string: host + "/search/person") else { return nil }
            return url
        case .getActorDetails:
            guard let id = id else { return nil }
            guard let url = URL(string: host + "/person/\(id)") else { return nil }
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

    func getActorId(_ query: String, completion: @escaping (Int?, Error?) -> Void) {
        guard let url = MovieServiceRequest.searchActor.url() else { return }
        guard let apiKey = apiKey else { return }

        let params: [String: Any] = [
            "api_key": apiKey,
            "query": query
        ]
        networkService.request(url: url, httpMethod: .GET, params: params) { (data, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            if let data = data {
                do {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else { return }
                    guard let results = json["results"] as? [[String: Any]], let firstResult = results.first else { return }
                    guard let id = firstResult["id"] as? Int else { return }

                    completion(id, nil)
                } catch {
                    completion(nil, error)
                }
            }
        }
    }

    func getActorDetails(id: Int, completion: @escaping (Actor?, Error?) -> Void) {
        guard let url = MovieServiceRequest.getActorDetails.url(id: id) else { return }
        guard let apiKey = apiKey else { return }

        let params: [String: Any] = [
            "api_key": apiKey
        ]
        networkService.request(url: url, httpMethod: .GET, params: params) { (data, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            if let data = data {
                do {
                    let actor = try JSONDecoder().decode(Actor.self, from: data)
                    completion(actor, nil)
                } catch {
                    completion(nil, error)
                }
            }
        }
    }

}
