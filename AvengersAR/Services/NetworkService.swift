//
//  NetworkService.swift
//  AvengersAR
//
//  Created by Tim Shim on 8/28/19.
//  Copyright © 2019 Tim Shim. All rights reserved.
//

import UIKit

enum HTTPMethod: String {
    case GET, POST, PUT, PATCH, DELETE
}

protocol NetworkServiceProtocol {
    func request(url: URL, httpMethod: HTTPMethod, params: [String: Any], completion: @escaping (Data?, ErrorProtocol?) -> Void)
}

final class NetworkService: NetworkServiceProtocol {

    func request(url: URL, httpMethod: HTTPMethod, params: [String: Any], completion: @escaping (Data?, ErrorProtocol?) -> Void) {
        var mutableUrl = url
        mutableUrl = mutableUrl.appendingQueryParameters(params)

        var request = URLRequest(url: mutableUrl, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 10)
        request.httpMethod = httpMethod.rawValue

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                let requestError = NetworkError("Request error")
                completion(nil, requestError)
                return
            }
            completion(data, nil)
        }.resume()
    }

}

protocol ErrorProtocol: LocalizedError {
    var description: String? { get }
}

final class NetworkError: ErrorProtocol {
    var description: String?

    init(_ description: String) {
        self.description = description
    }
}
