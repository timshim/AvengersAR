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

    let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "close_button")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()

        view.backgroundColor = Color.mainBg
    }

    private func setupNavBar() {
        view.addSubview(closeButton)
        closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        closeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 45).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }

    @objc private func closeTapped() {
        coordinator?.dismissActor()
    }
}
