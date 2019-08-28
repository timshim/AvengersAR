//
//  HomeViewModel.swift
//  AvengersAR
//
//  Created by Tim Shim on 8/28/19.
//  Copyright © 2019 Tim Shim. All rights reserved.
//

final class HomeViewModel {

    var api: MovieService
    var actors = [Actor]()

    init(api: MovieService) {
        self.api = api
    }
    
}
