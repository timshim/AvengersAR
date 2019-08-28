//
//  HeaderView.swift
//  AvengersAR
//
//  Created by Tim Shim on 8/28/19.
//  Copyright © 2019 Tim Shim. All rights reserved.
//

import UIKit

protocol HeaderViewDelegate: class {
    func didTapCamera()
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

    private let cameraButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "Camera")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(cameraTapped), for: .touchUpInside)
        return button
    }()

    private let photoButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "Photo")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.imageEdgeInsets = UIEdgeInsets(top: 27, left: 27, bottom: 27, right: 27)
        button.addTarget(self, action: #selector(photoTapped), for: .touchUpInside)
        return button
    }()

    private let separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    weak var delegate: HeaderViewDelegate?

    private func setupBgView() {
        addSubview(bgView)
        bgView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bgView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        bgView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        bgView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true

        let colorTop = UIColor.black.cgColor
        let colorBottom = UIColor(hue: 0, saturation: 0, brightness: 0.2, alpha: 1).cgColor

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
        logoView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -50).isActive = true
        logoView.widthAnchor.constraint(equalToConstant: width).isActive = true
        logoView.heightAnchor.constraint(equalToConstant: width).isActive = true
    }

    private func setupButtons() {
        let buttonWidth = UIScreen.main.bounds.width / 3

        addSubview(separatorView)
        separatorView.centerXAnchor.constraint(equalTo: logoView.centerXAnchor).isActive = true
        separatorView.topAnchor.constraint(equalTo: logoView.bottomAnchor, constant: 50).isActive = true
        separatorView.widthAnchor.constraint(equalToConstant: 1).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: buttonWidth + 50).isActive = true

        let clearColor = UIColor.clear.cgColor
        let lineColor = UIColor(hue: 0, saturation: 0, brightness: 0.5, alpha: 1).cgColor

        let lineGrad = CAGradientLayer()
        lineGrad.colors = [clearColor, lineColor, clearColor]
        lineGrad.locations = [0, 0.5, 1.0]
        lineGrad.frame = CGRect(x: self.bounds.origin.x, y: self.bounds.origin.y, width: 1, height: buttonWidth + 50)

        separatorView.layer.insertSublayer(lineGrad, at: 0)

        addSubview(cameraButton)
        cameraButton.centerYAnchor.constraint(equalTo: separatorView.centerYAnchor).isActive = true
        cameraButton.trailingAnchor.constraint(equalTo: separatorView.leadingAnchor, constant: -20).isActive = true
        cameraButton.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        cameraButton.heightAnchor.constraint(equalToConstant: buttonWidth).isActive = true

        cameraButton.transform = CGAffineTransform(scaleX: 0, y: 0).concatenating(CGAffineTransform(translationX: 80, y: -80))
        cameraButton.alpha = 0
        UIView.animate(withDuration: 1.1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.cameraButton.transform = CGAffineTransform.identity
            self.cameraButton.alpha = 1
        }, completion: nil)

        addSubview(photoButton)
        photoButton.centerYAnchor.constraint(equalTo: separatorView.centerYAnchor).isActive = true
        photoButton.leadingAnchor.constraint(equalTo: separatorView.trailingAnchor, constant: 16).isActive = true
        photoButton.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        photoButton.heightAnchor.constraint(equalToConstant: buttonWidth).isActive = true

        photoButton.transform = CGAffineTransform(scaleX: 0, y: 0).concatenating(CGAffineTransform(translationX: -80, y: -80))
        photoButton.alpha = 0
        UIView.animate(withDuration: 1.2, delay: 0.12, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.photoButton.transform = CGAffineTransform.identity
            self.photoButton.alpha = 1
        }, completion: nil)
    }

    func configure() {
        setupBgView()
        setupLogoView()
        setupButtons()
    }

    @objc private func cameraTapped() {
        delegate?.didTapCamera()
    }

    @objc private func photoTapped() {
        delegate?.didTapPhoto()
    }

}
