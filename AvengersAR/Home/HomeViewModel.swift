//
//  HomeViewModel.swift
//  AvengersAR
//
//  Created by Tim Shim on 8/28/19.
//  Copyright © 2019 Tim Shim. All rights reserved.
//

import UIKit
import Vision
import CoreML

final class HomeViewModel {

    var api: MovieService
    var actors = [Actor]()

    init(api: MovieService) {
        self.api = api
    }

    func findFaces(_ image: UIImage, completion: @escaping ([Actor]?, Error?) -> Void) {
        guard let cgImage = image.cgImage else { return }
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let detectFaceRequest = VNDetectFaceRectanglesRequest { (request, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            guard let results = request.results as? [VNFaceObservation] else { return }
            let images = self.processFacesResult(image, results)

            var actorsArray = [Actor]()
            var actorsInLastImage = [Actor]()
            for image in images {
                let resizedImage = image.resizedImage(scaledToSize: CGSize(width: 227, height: 227))
                if let actor = self.whoIsThis(image: resizedImage) {
                    actorsArray.append(actor)
                    if self.actors.contains(actor) {
                        actorsInLastImage.append(actor)
                    }
                }
            }
            self.actors = actorsArray
            completion(actorsInLastImage, nil)
        }

        do {
            try handler.perform([detectFaceRequest])
        } catch let error {
            completion(nil, error)
        }
    }

    private func processFacesResult(_ image: UIImage, _ results: [VNFaceObservation]) -> [UIImage] {
        var images = [UIImage]()
        for result in results {
            let w = result.boundingBox.size.width * image.size.width
            let h = result.boundingBox.size.height * image.size.height
            let x = result.boundingBox.origin.x * image.size.width
            let y = ((1 - result.boundingBox.origin.y) * image.size.height) - h

            let faceRect = CGRect(x: x - (w * 0.1), y: y - (h * 0.1), width: w + (w * 0.2), height: h + (h * 0.2))

            if let croppedImage = image.cgImage?.cropping(to: faceRect) {
                let finalImage = UIImage(cgImage: croppedImage)
                images.append(finalImage)
            }
        }
        return images
    }

    private func whoIsThis(image: UIImage) -> Actor? {
        if let imageBuffer = image.buffer() {
            let avengersModel = Avengers()
            do {
                let prediction = try avengersModel.prediction(image: imageBuffer)

                if let confidence = prediction.classLabelProbs[prediction.classLabel], confidence < 0.95 {
                    return nil
                }

                let ageRange = self.guessAge(image: image)
                let actor = Actor(name: prediction.classLabel, profilePhoto: image, ageRange: ageRange)
                return actor
            } catch {
                fatalError(error.localizedDescription)
            }
        }
        return nil
    }

    private func guessAge(image: UIImage) -> String? {
        if let imageBuffer = image.buffer() {
            let ageModel = AgeNet()
            do {
                let prediction = try ageModel.prediction(data: imageBuffer)
                return prediction.classLabel
            } catch {
                fatalError(error.localizedDescription)
            }
        }
        return nil
    }
    
}
