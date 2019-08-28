//
//  Dictionary.swift
//  AvengersAR
//
//  Created by Tim Shim on 8/28/19.
//  Copyright © 2019 Tim Shim. All rights reserved.
//

import UIKit

protocol URLQueryParameterStringConvertible {
    var queryParameters: String { get }
}

extension Dictionary: URLQueryParameterStringConvertible {

    var queryParameters: String {
        var parts: [String] = []
        for (key, value) in self {
            guard let keyItem = String(describing: key).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return "" }
            guard let valueItem = String(describing: value).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return "" }
            let part = String(format: "%@=%@", keyItem, valueItem)
            parts.append(part as String)
        }
        return parts.joined(separator: "&")
    }

}
