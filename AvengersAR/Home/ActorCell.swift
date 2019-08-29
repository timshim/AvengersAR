//
//  ActorCell.swift
//  AvengersAR
//
//  Created by Tim Shim on 8/28/19.
//  Copyright © 2019 Tim Shim. All rights reserved.
//

import UIKit

final class ActorCell: UICollectionViewCell {

    var actor: Actor!

    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = Color.imageBg
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 6
        return iv
    }()

    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        return label
    }()

    let labelBgView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var isLoaded = false

    private func setupImageView() {
        addSubview(imageView)

        imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true

    }

    private func setupLabelBgView() {
        imageView.addSubview(labelBgView)

        labelBgView.topAnchor.constraint(equalTo: imageView.topAnchor).isActive = true
        labelBgView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
        labelBgView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        labelBgView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 2).isActive = true

        let colorTop = UIColor.clear.cgColor
        let colorBottom = UIColor(hue: 0, saturation: 0, brightness: 0, alpha: 0.5).cgColor

        let gradient = CAGradientLayer()
        gradient.colors = [colorTop, colorBottom]
        gradient.locations = [0.2, 1.0]
        gradient.frame = self.bounds

        labelBgView.layer.insertSublayer(gradient, at: 0)
    }

    private func setupNameLabel() {
        labelBgView.addSubview(nameLabel)

        nameLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -12).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 12).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -12).isActive = true
    }

    func configure() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.08
        self.layer.shadowRadius = 5
        self.layer.shadowOffset = CGSize(width: 0, height: 1)

        if isLoaded == false {
            setupImageView()
            setupLabelBgView()
            setupNameLabel()
            isLoaded = true
        }

        if let faceDetectPhotoUrl = actor.faceDetectPhotoUrl {
            let imageUrl = URL(fileURLWithPath: faceDetectPhotoUrl)
            if let image = UIImage(contentsOfFile: imageUrl.path) {
                imageView.image = image
            }
        }

        var labelString = actor.name
        if let ageRange = actor.ageRange {
            labelString += "\nAge: \(ageRange)"
        }
        nameLabel.text = labelString
    }
    
}
