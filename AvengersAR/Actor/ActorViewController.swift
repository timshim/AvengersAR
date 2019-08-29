//
//  ActorViewController.swift
//  AvengersAR
//
//  Created by Tim Shim on 8/28/19.
//  Copyright © 2019 Tim Shim. All rights reserved.
//

import UIKit

final class ActorViewController: UIViewController, Alertable {

    var viewModel: ActorViewModel!
    weak var coordinator: AppCoordinator?

    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.alwaysBounceVertical = true
        sv.contentInsetAdjustmentBehavior = .never
        return sv
    }()

    let imageView: CachedImageView = {
        let iv = CachedImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = Color.imageBg
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.accessibilityIdentifier = "actorImage"
        iv.clipsToBounds = true
        return iv
    }()

    let overlayView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let placeOfBirthLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor(white: 1, alpha: 0.7)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let dateOfBirthLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor(white: 1, alpha: 0.7)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let bioTextView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.textColor = .white
        tv.backgroundColor = .clear
        tv.textContainerInset = .zero
        tv.isScrollEnabled = false
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "close_button")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        return button
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .white)
        ai.hidesWhenStopped = true
        ai.translatesAutoresizingMaskIntoConstraints = false
        ai.alpha = 0.7
        return ai
    }()

    private var isLoaded = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.mainBg

        setupScrollView()
        setupProfileImageView()
        setupOverlay()
        setupLabels()
        setupNavBar()
        setupActivityIndicator()

        guard let actorName = viewModel.actor?.name else { return }
        activityIndicator.startAnimating()
        viewModel.fetchActorDetails(name: actorName) { (actor, error) in
            if let error = error {
                self.showAlert(title: "Error", message: error.localizedDescription)
                return
            }
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.configure()
            }
        }
    }

    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    private func setupNavBar() {
        view.addSubview(closeButton)
        closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        closeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 45).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }

    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    private func setupProfileImageView() {
        scrollView.addSubview(imageView)

        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height

        imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: width).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: height).isActive = true
    }

    private func setupOverlay() {
        scrollView.addSubview(overlayView)
        overlayView.topAnchor.constraint(equalTo: imageView.topAnchor).isActive = true
        overlayView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
        overlayView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        overlayView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor).isActive = true

        let colorTop = UIColor(hue: 0, saturation: 0, brightness: 0, alpha: 0.2).cgColor
        let colorBottom = Color.mainBg.cgColor

        let gradient = CAGradientLayer()
        gradient.colors = [colorTop, colorBottom]
        gradient.locations = [0, 0.7]
        gradient.frame = self.view.bounds

        overlayView.layer.insertSublayer(gradient, at: 0)
    }

    private func setupLabels() {
        let labelTop = UIScreen.main.bounds.height / 5
        scrollView.addSubview(nameLabel)
        nameLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor, constant: labelTop).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 16).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -16).isActive = true

        scrollView.addSubview(dateOfBirthLabel)
        dateOfBirthLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 0).isActive = true
        dateOfBirthLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 16).isActive = true
        dateOfBirthLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -16).isActive = true

        scrollView.addSubview(placeOfBirthLabel)
        placeOfBirthLabel.topAnchor.constraint(equalTo: dateOfBirthLabel.bottomAnchor, constant: 0).isActive = true
        placeOfBirthLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 16).isActive = true
        placeOfBirthLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -16).isActive = true

        scrollView.addSubview(bioTextView)
        bioTextView.topAnchor.constraint(equalTo: placeOfBirthLabel.bottomAnchor, constant: 20).isActive = true
        bioTextView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 12).isActive = true
        bioTextView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -12).isActive = true
        bioTextView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -50).isActive = true
    }

    @objc private func closeTapped() {
        coordinator?.dismissActor()
    }

    func configure() {
        guard isLoaded == false else { return }

        nameLabel.text = viewModel.actor?.name
        dateOfBirthLabel.text = viewModel.actor?.birthday
        placeOfBirthLabel.text = viewModel.actor?.place_of_birth
        bioTextView.text = viewModel.actor?.biography

        if let profilePath = viewModel.actor?.profile_path, let url = URL(string: "https://image.tmdb.org/t/p/w1280\(profilePath)") {
            imageView.loadFromUrl(url)
            self.isLoaded = true
        }
    }
}
