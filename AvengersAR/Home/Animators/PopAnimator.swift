//
//  PopAnimator.swift
//  AvengersAR
//
//  Created by Tim Shim on 8/28/19.
//  Copyright © 2019 Tim Shim. All rights reserved.
//

import UIKit

final class PopAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    var indexPath: IndexPath?
    var finalFrame: CGRect?

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from) as? ActorViewController else { return }
        guard let toVC = transitionContext.viewController(forKey: .to) as? HomeViewController else { return }

        guard let indexPath = indexPath else { return }
        guard let actorCell = toVC.collectionView.cellForItem(at: indexPath) as? ActorCell else { return }
        guard var finalFrame = finalFrame else { return }
        finalFrame.origin.y -= 88
        let originFrame = fromVC.imageView.frame

        guard let initialSnapshotView = fromVC.imageView.snapshotView(afterScreenUpdates: false) else { return }
        initialSnapshotView.clipsToBounds = true
        initialSnapshotView.layer.cornerRadius = 3

        transitionContext.containerView.addSubview(toVC.view)
        toVC.view.alpha = 0
        actorCell.imageView.isHidden = true
        fromVC.imageView.isHidden = true

        initialSnapshotView.layer.anchorPoint = .zero
        initialSnapshotView.frame.origin.y += 100
        initialSnapshotView.frame.origin.x += 12
        initialSnapshotView.frame.origin.x -= initialSnapshotView.frame.width / 2
        initialSnapshotView.frame.origin.y -= initialSnapshotView.frame.height / 2
        transitionContext.containerView.addSubview(initialSnapshotView)

        let scale = finalFrame.width / originFrame.width
        let xPos = finalFrame.origin.x - originFrame.origin.x
        let yPos = -(originFrame.origin.y - finalFrame.origin.y)

        let transform = CGAffineTransform.identity.translatedBy(x: xPos, y: yPos).scaledBy(x: scale, y: scale)

        let duration = self.transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.3, options: .curveEaseInOut, animations: {
            initialSnapshotView.transform = transform
            toVC.view.alpha = 1
        }) { _ in
            toVC.view.isHidden = false
            actorCell.imageView.isHidden = false
            fromVC.imageView.isHidden = false
            initialSnapshotView.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }

}
