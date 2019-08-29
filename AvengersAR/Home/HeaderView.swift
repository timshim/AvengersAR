//
//  HeaderView.swift
//  AvengersAR
//
//  Created by Tim Shim on 8/28/19.
//  Copyright © 2019 Tim Shim. All rights reserved.
//

import UIKit

protocol HeaderViewDelegate: class {
    func didTapPhoto()
}

final class HeaderView: UICollectionReusableView {

    private let bgView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let logoView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.image = UIImage(named: "AvengersLogo")
        return view
    }()

    private let photoButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageEdgeInsets = UIEdgeInsets(top: 27, left: 27, bottom: 27, right: 27)
        button.addTarget(self, action: #selector(photoTapped), for: .touchUpInside)
        return button
    }()

    private let separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let textLabel: UIView = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor(white: 1, alpha: 0.5)
        label.text = "Tap the logo to start analyzing a photo"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var isLoaded: Bool = false
    var disableButtons = false {
        didSet {
            if self.disableButtons {
                self.photoButton.isEnabled = false
            } else {
                self.photoButton.isEnabled = true
            }
        }
    }
    weak var delegate: HeaderViewDelegate?

    private func setupBgView() {
        addSubview(bgView)
        bgView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bgView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        bgView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        bgView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true

        let colorTop = UIColor.black.cgColor
        let colorBottom = Color.mainBg.cgColor

        let gradient = CAGradientLayer()
        gradient.colors = [colorTop, colorBottom]
        gradient.locations = [0.6, 1.0]
        gradient.frame = self.bounds

        bgView.layer.insertSublayer(gradient, at: 0)
    }

    private func setupLogoView() {
        addSubview(logoView)
        let width = UIScreen.main.bounds.width / 2
        logoView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        logoView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        logoView.widthAnchor.constraint(equalToConstant: width).isActive = true
        logoView.heightAnchor.constraint(equalToConstant: width).isActive = true
    }

    private func setupButtons() {
        let buttonWidth = UIScreen.main.bounds.width / 1.1

        addSubview(separatorView)
        separatorView.centerXAnchor.constraint(equalTo: logoView.centerXAnchor).isActive = true
        separatorView.topAnchor.constraint(equalTo: logoView.bottomAnchor, constant: 50).isActive = true
        separatorView.widthAnchor.constraint(equalToConstant: 1).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 200).isActive = true

        let clearColor = UIColor.clear.cgColor
        let lineColor = UIColor(hue: 0, saturation: 0, brightness: 0.3, alpha: 1).cgColor

        let lineGrad = CAGradientLayer()
        lineGrad.colors = [clearColor, lineColor, clearColor]
        lineGrad.locations = [0, 0.5, 1.0]
        lineGrad.frame = CGRect(x: self.bounds.origin.x, y: self.bounds.origin.y, width: 1, height: 200)

        separatorView.layer.insertSublayer(lineGrad, at: 0)

        addSubview(textLabel)
        textLabel.centerXAnchor.constraint(equalTo: separatorView.centerXAnchor).isActive = true
        textLabel.centerYAnchor.constraint(equalTo: separatorView.centerYAnchor).isActive = true
        textLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        textLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true

        addSubview(photoButton)
        photoButton.centerYAnchor.constraint(equalTo: logoView.centerYAnchor).isActive = true
        photoButton.centerXAnchor.constraint(equalTo: logoView.centerXAnchor).isActive = true
        photoButton.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        photoButton.heightAnchor.constraint(equalToConstant: buttonWidth).isActive = true

        photoButton.transform = CGAffineTransform(scaleX: 0, y: 0)
        photoButton.alpha = 0
        UIView.animate(withDuration: 1.2, delay: 0.12, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.photoButton.transform = CGAffineTransform.identity
            self.photoButton.alpha = 1
        }, completion: { _ in
            self.isLoaded = true
        })
    }

    func configure() {
        guard isLoaded == false else { return }
        
        setupBgView()
        setupLogoView()
        setupButtons()
    }

    @objc private func photoTapped() {
        delegate?.didTapPhoto()
    }

}
