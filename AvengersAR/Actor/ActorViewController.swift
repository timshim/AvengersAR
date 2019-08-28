//
//  ActorViewController.swift
//  AvengersAR
//
//  Created by Tim Shim on 8/28/19.
//  Copyright © 2019 Tim Shim. All rights reserved.
//

import UIKit

final class ActorViewController: UIViewController {

    var viewModel: HomeViewModel!
    weak var coordinator: AppCoordinator?

    var actor: Actor! {
        didSet {
            print(self)
        }
    }

    let imageView: CachedImageView = {
        let iv = CachedImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .white
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 5
        iv.accessibilityIdentifier = "actorImage"
        return iv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
