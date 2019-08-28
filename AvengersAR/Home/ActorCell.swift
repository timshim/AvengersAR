//
//  ActorCell.swift
//  AvengersAR
//
//  Created by Tim Shim on 8/28/19.
//  Copyright © 2019 Tim Shim. All rights reserved.
//

import UIKit

final class ActorCell: UICollectionViewCell {

    let imageView: CachedImageView = {
        let iv = CachedImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .white
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 3
        return iv
    }()

    func configure() {
        self.clipsToBounds = true
        self.backgroundColor = .blue
    }
    
}
