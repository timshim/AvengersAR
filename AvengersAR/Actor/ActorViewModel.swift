//
//  ActorViewModel.swift
//  AvengersAR
//
//  Created by Tim Shim on 8/29/19.
//  Copyright © 2019 Tim Shim. All rights reserved.
//

import UIKit

final class ActorViewModel {

    var api: MovieService
    var actor: Actor?

    init(api: MovieService) {
        self.api = api
    }

    func fetchActorDetails(name: String, completion: @escaping (Actor?, Error?) -> Void) {
        api.getActorId(name) { (id, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            if let id = id {
                self.api.getActorDetails(id: id, completion: { (actor, error) in
                    var newActor = actor
                    newActor?.faceDetectPhotoUrl = self.actor?.faceDetectPhotoUrl
                    newActor?.ageRange = self.actor?.ageRange

                    self.actor = newActor

                    completion(newActor, error)
                })
            }
        }
    }

}
