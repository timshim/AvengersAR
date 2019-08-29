//
//  Actor.swift
//  AvengersAR
//
//  Created by Tim Shim on 8/28/19.
//  Copyright © 2019 Tim Shim. All rights reserved.
//

import UIKit

struct Actor: Equatable {

    let name: String
    let profilePhoto: UIImage
    let ageRange: String?

    static func ==(lhs: Actor, rhs: Actor) -> Bool {
        return lhs.name == rhs.name
    }

}
