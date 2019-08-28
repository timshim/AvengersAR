//
//  PushAnimator.swift
//  AvengersAR
//
//  Created by Tim Shim on 8/28/19.
//  Copyright © 2019 Tim Shim. All rights reserved.
//

import UIKit

final class PushAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    var indexPath: IndexPath?

    private var hasTopNotch: Bool {
        if #available(iOS 11.0, *) {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
        }
        return false
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from) as? HomeViewController else { return }
        guard let toVC = transitionContext.viewController(forKey: .to) as? ActorViewController else { return }

        guard let indexPath = indexPath else { return }
        guard let actorCell = fromVC.collectionView.cellForItem(at: indexPath) as? ActorCell else { return }
        let originFrame = fromVC.collectionView.convert(actorCell.frame, to: nil)

        guard let initialSnapshotView = actorCell.imageView.snapshotView(afterScreenUpdates: false) else { return }

        transitionContext.containerView.addSubview(toVC.view)
        toVC.view.alpha = 0
        toVC.imageView.isHidden = true
        actorCell.imageView.isHidden = true

        initialSnapshotView.layer.anchorPoint = .zero
        transitionContext.containerView.addSubview(initialSnapshotView)
        initialSnapshotView.frame.origin = originFrame.origin
        initialSnapshotView.layer.anchorPoint = CGPoint.zero

        let finalWidth = UIScreen.main.bounds.width - (12 * 2)
        let finalHeight = finalWidth * 0.67
        let finalFrame = CGRect(x: 12, y: 12, width: finalWidth, height: finalHeight)
        let scale = finalFrame.width / originFrame.width
        let xPos = finalFrame.origin.x - originFrame.origin.x
        let yPos = -(originFrame.origin.y - finalFrame.origin.y) + (hasTopNotch ? 88 : 64)

        let transform = CGAffineTransform.identity.translatedBy(x: xPos, y: yPos).scaledBy(x: scale, y: scale)

        let duration = self.transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.3, options: .curveEaseInOut, animations: {
            initialSnapshotView.transform = transform
            toVC.view.alpha = 1
        }) { _ in
            toVC.view.isHidden = false
            toVC.imageView.isHidden = false
            actorCell.imageView.isHidden = false
            fromVC.view.transform = CGAffineTransform.identity
            initialSnapshotView.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }

}
