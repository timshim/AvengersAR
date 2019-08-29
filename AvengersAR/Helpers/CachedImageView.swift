//
//  CachedImageView.swift
//  AvengersAR
//
//  Created by Tim Shim on 8/28/19.
//  Copyright © 2019 Tim Shim. All rights reserved.
//

import UIKit

final class CachedImageView: UIImageView {

    private let imageCache = NSCache<NSString, UIImage>()
    private let activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .white)
        ai.hidesWhenStopped = true
        ai.translatesAutoresizingMaskIntoConstraints = false
        return ai
    }()

    func loadFromUrl(_ url: URL) {
        let urlString = url.absoluteString as NSString

        if let imageInCache = self.imageCache.object(forKey: urlString) {
            self.image = imageInCache
            return
        }

        DispatchQueue.main.async {
            self.addSubview(self.activityIndicator)
            self.activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            self.activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            self.activityIndicator.startAnimating()

            self.image = nil
        }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                if let data = data, let image = UIImage(data: data) {
                    self.imageCache.setObject(image, forKey: urlString)
                    self.image = image
                }
                self.activityIndicator.stopAnimating()
                self.activityIndicator.removeFromSuperview()
            }
        }.resume()
    }

}
