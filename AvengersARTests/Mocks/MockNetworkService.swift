//
//  MockNetworkService.swift
//  AvengersARTests
//
//  Created by Tim Shim on 8/30/19.
//  Copyright © 2019 Tim Shim. All rights reserved.
//

import UIKit
@testable import AvengersAR

final class MockNetworkService: NetworkServiceProtocol {

    var returnsError = false

    func request(url: URL, httpMethod: HTTPMethod, params: [String : Any], completion: @escaping (Data?, ErrorProtocol?) -> Void) {
        if returnsError {
            let error = NetworkError("Error")
            completion(nil, error)
            return
        }

        let json: Any = [
            "id": 3223,
            "name": "Robert Downey Jr.",
            "profile_path": "/1YjdSym1jTG7xjHSI0yGGWEsw5i.jpg",
            "birthday": "1965-04-04",
            "deathday": nil,
            "gender": 2,
            "biography": "Robert John Downey Jr. (born April 4, 1965) is an American actor and producer. Downey made his screen debut in 1970, at the age of five, when he appeared in his father's film Pound, and has worked consistently in film and television ever since. He received two Academy Award nominations for his roles in films Chaplin (1992) and Tropic Thunder (2008).",
            "popularity": 12.492,
            "place_of_birth": "Manhattan, New York City, New York, USA"
        ]

        do {
            let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            completion(data, nil)
        } catch {
            let decodeError = NetworkError("Decode error")
            completion(nil, decodeError)
            return
        }
    }

}
