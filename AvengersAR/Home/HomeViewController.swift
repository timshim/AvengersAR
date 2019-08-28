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
        flowLayout.minimumLineSpacing = 12
        flowLayout.minimumInteritemSpacing = 12
        let cv = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: flowLayout)
        cv.backgroundColor = Color.mainBg
        cv.contentInsetAdjustmentBehavior = .never
        return cv
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .gray)
        ai.hidesWhenStopped = true
        ai.translatesAutoresizingMaskIntoConstraints = false
        return ai
    }()

    private let headerReuseIdentifier = "header"
    private let actorReuseIdentifier = "actor"

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupActivityIndicator()
    }

    private func setupCollectionView() {
        view.addSubview(collectionView)

        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier)
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
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: actorReuseIdentifier, for: indexPath) as? ActorCell else { return UICollectionViewCell() }
        cell.configure()
        return cell
    }

}

extension HomeViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard collectionView.numberOfItems(inSection: 0) > 0 else { return }
        guard viewModel.actors.count > 0 else { return }

        let selectedActor = viewModel.actors[indexPath.item]
        coordinator?.showActor(selectedActor, viewModel: viewModel)
    }

}

extension HomeViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard indexPath.section == 0 else { return CGSize.zero }

        let sideInset: CGFloat = 12
        let itemSpacing = (collectionViewLayout as! UICollectionViewFlowLayout).minimumInteritemSpacing
        let width = (UIScreen.main.bounds.width - (2 * sideInset) - itemSpacing) / 2
        let height = width * 1.33

        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch indexPath.section {
        case 0:
            if let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier, for: indexPath) as? HeaderView {
                headerView.delegate = self
                headerView.configure()
                return headerView
            }
        default:
            return UICollectionReusableView()
        }
        return UICollectionReusableView()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch section {
        case 0:
            let width = UIScreen.main.bounds.width
            let height = UIScreen.main.bounds.height
            return CGSize(width: width, height: height)
        default:
            return CGSize.zero
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView.numberOfItems(inSection: 0) > 0 {
            return UIEdgeInsets(top: 12, left: 12, bottom: 24, right: 12)
        }
        return UIEdgeInsets.zero
    }

}

extension HomeViewController: HeaderViewDelegate {

    func didTapCamera() {
        print("Camera tapped")
    }

    func didTapPhoto() {
        print("Photo tapped")
    }

}
