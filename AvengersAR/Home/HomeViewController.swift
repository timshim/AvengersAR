//
//  HomeViewController.swift
//  AvengersAR
//
//  Created by Tim Shim on 8/28/19.
//  Copyright © 2019 Tim Shim. All rights reserved.
//

import UIKit

final class HomeViewController: UIViewController, Alertable {

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
        let ai = UIActivityIndicatorView(style: .white)
        ai.hidesWhenStopped = true
        ai.translatesAutoresizingMaskIntoConstraints = false
        ai.alpha = 0.7
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
        activityIndicator.centerYAnchor.constraint(equalTo: view.bottomAnchor, constant: -60).isActive = true
    }

    private func analyzeImage(_ image: UIImage) {
        guard let headerView = collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: 0)) as? HeaderView else { return }

        activityIndicator.startAnimating()
        headerView.disableButtons = true

        self.viewModel.findFaces(image) { (actorsInLastImage, error) in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                headerView.disableButtons = false
                if let error = error {
                    self.showAlert(title: "Error", message: error.localizedDescription)
                    return
                }

                guard self.viewModel.actors.count > 0 else {
                    self.showAlert(title: "No faces found", message: "Please try picking a photo with at least one face in it.")
                    return
                }

                self.collectionView.reloadData()
                self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)

                if let actorsInLastImage = actorsInLastImage, !actorsInLastImage.isEmpty {
                    let actorsName = actorsInLastImage.map { $0.name }
                    let message = actorsName.joined(separator: ", ")
                    self.showAlert(title: "People from last photo", message: message)
                }
            }
        }
    }

}

extension HomeViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.actors.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: actorReuseIdentifier, for: indexPath) as? ActorCell else { return UICollectionViewCell() }
        guard viewModel.actors.count > 0 else { return UICollectionViewCell() }

        cell.actor = viewModel.actors[indexPath.item]
        cell.configure()
        return cell
    }

}

extension HomeViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard collectionView.numberOfItems(inSection: 0) > 0 else { return }
        guard viewModel.actors.count > 0 else { return }

        let actorsArray = Array(viewModel.actors)
        let selectedActor = actorsArray[indexPath.item]
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

    func didTapPhoto() {
        collectionView.setContentOffset(CGPoint.zero, animated: true)
        activityIndicator.startAnimating()

        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = false
        pickerController.mediaTypes = ["public.image"]
        pickerController.sourceType = .photoLibrary

        self.present(pickerController, animated: true, completion: {
            self.activityIndicator.stopAnimating()
        })
    }

}

extension HomeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else { return }

        self.dismiss(animated: true, completion: {
            self.analyzeImage(selectedImage)
        })
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }

}
