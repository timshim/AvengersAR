//
//  Actor.swift
//  AvengersAR
//
//  Created by Tim Shim on 8/28/19.
//  Copyright © 2019 Tim Shim. All rights reserved.
//

struct Actor: Equatable, Codable {

    var id: Int?
    var name: String
    var faceDetectPhotoUrl: String?
    var profile_path: String?
    var ageRange: String?
    var birthday: String?
    var deathday: String?
    var gender: Int?
    var biography: String?
    var popularity: Double?
    var place_of_birth: String?

    static func ==(lhs: Actor, rhs: Actor) -> Bool {
        return lhs.name == rhs.name
    }

    init(id: Int? = nil, name: String, faceDetectPhotoUrl: String? = nil, profile_path: String? = nil, ageRange: String? = nil, birthday: String? = nil, deathday: String? = nil, gender: Int? = nil, biography: String? = nil, popularity: Double? = nil, place_of_birth: String? = nil) {
        self.name = name
        self.faceDetectPhotoUrl = faceDetectPhotoUrl
        self.ageRange = ageRange
    }

}
