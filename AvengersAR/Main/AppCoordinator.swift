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

final class AppCoordinator: NSObject, Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    private var transition: UIViewControllerAnimatedTransitioning?
    var indexPath: IndexPath?
    var initialFrame: CGRect?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
        self.navigationController.delegate = self
        self.navigationController.isNavigationBarHidden = true
    }

    func start() {
        let homeVM = HomeViewModel()
        let homeVC = HomeViewController()
        homeVC.viewModel = homeVM
        homeVC.coordinator = self

        navigationController.navigationBar.shadowImage = UIImage()
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

//        let pushTransition = PushAnimator()
//        pushTransition.indexPath = indexPath
//        self.transition = pushTransition

        self.navigationController.present(actorVC, animated: true, completion: nil)
    }

    func dismissActor() {
//        let popTransition = PopAnimator()
//        popTransition.indexPath = indexPath
//        popTransition.finalFrame = initialFrame
//        self.transition = popTransition

        self.navigationController.dismiss(animated: true, completion: nil)
    }

}

extension AppCoordinator: UINavigationControllerDelegate {

    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.transition
    }

}
