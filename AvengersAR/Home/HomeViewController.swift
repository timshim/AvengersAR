//
//  HomeViewController.swift
//  AvengersAR
//
//  Created by Tim Shim on 8/28/19.
//  Copyright © 2019 Tim Shim. All rights reserved.
//

import UIKit

final class HomeViewController: UIViewController {

    var viewModel: HomeViewModel!
    weak var coordinator: AppCoordinator?

    let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        let cv = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: flowLayout)
        cv.backgroundColor = .green
        return cv
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .gray)
        ai.hidesWhenStopped = true
        ai.translatesAutoresizingMaskIntoConstraints = false
        return ai
    }()

    private let actorReuseIdentifier = "actorReuseIdentifier"

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupCollectionView()
        setupActivityIndicator()
    }

    private func setupNavBar() {
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = false

        let image = UIImage(named: "search_image")?.withRenderingMode(.alwaysTemplate)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(cameraTapped))
    }

    private func setupCollectionView() {
        view.addSubview(collectionView)

        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)

        collectionView.register(ActorCell.self, forCellWithReuseIdentifier: actorReuseIdentifier)
    }

    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    @objc private func cameraTapped() {
        print("Camera tapped")
    }

}

extension HomeViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: actorReuseIdentifier, for: indexPath) as? ActorCell else { return UICollectionViewCell() }
        cell.configure()
        return cell
    }

}

extension HomeViewController: UICollectionViewDelegate {

}
