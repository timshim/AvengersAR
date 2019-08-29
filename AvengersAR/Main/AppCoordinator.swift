//
//  AppCoordinator.swift
//  AvengersAR
//
//  Created by Tim Shim on 8/28/19.
//  Copyright © 2019 Tim Shim. All rights reserved.
//

import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }

    func start()
}

final class AppCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController

    }

    func start() {
        let homeVM = HomeViewModel()
        let homeVC = HomeViewController()
        homeVC.viewModel = homeVM
        homeVC.coordinator = self

        navigationController.isNavigationBarHidden = true
        navigationController.pushViewController(homeVC, animated: false)
    }

    func showActor(_ actor: Actor, viewModel: HomeViewModel) {
        let networkService = NetworkService()
        let api = MovieService(networkService: networkService)
        let actorVM = ActorViewModel(api: api)
        let actorVC = ActorViewController()
        actorVM.actor = actor
        actorVC.viewModel = actorVM
        actorVC.coordinator = self

        self.navigationController.present(actorVC, animated: true, completion: nil)
    }

    func dismissActor() {
        self.navigationController.dismiss(animated: true, completion: nil)
    }

}
