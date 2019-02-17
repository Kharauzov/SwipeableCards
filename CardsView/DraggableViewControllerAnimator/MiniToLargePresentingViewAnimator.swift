//
//  MiniToLargePresentingViewAnimator.swift
//  CardsView
//
//  Created by Serhii Kharauzov on 2/10/19.
//  Copyright © 2019 Serhii Kharauzov. All rights reserved.
//

import Foundation
import UIKit

protocol MiniToLargeAnimatable {
    var animatableBackgroundView: UIView { get }
    var animatableMainView: UIView { get }
    func prepareBeingDismissed()
}

class MiniToLargePresentingViewAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    let duration: TimeInterval
    let initialY: CGFloat

    init(duration: TimeInterval = 0.4, initialY: CGFloat) {
        self.duration = duration
        self.initialY = initialY
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from) else {
            return
        }
        guard let toVC = transitionContext.viewController(forKey: .to) else {
            return
        }
        guard let animatableToVC = toVC as? MiniToLargeAnimatable else {
            return
        }
        let fromVCRect = transitionContext.initialFrame(for: fromVC)
        var toVCRect = fromVCRect
        toVCRect.origin.y = toVCRect.size.height - initialY
        animatableToVC.animatableMainView.frame = toVCRect
        toVC.view.frame = fromVCRect
        animatableToVC.animatableBackgroundView.alpha = 0
        transitionContext.containerView.addSubview(toVC.view)
        fromVC.beginAppearanceTransition(false, animated: true)
        toVC.beginAppearanceTransition(true, animated: true)
        UIView.animate(withDuration: duration, animations: {
            animatableToVC.animatableMainView.frame = fromVCRect
            animatableToVC.animatableBackgroundView.alpha = 1
        }) { (_) in
            fromVC.beginAppearanceTransition(transitionContext.transitionWasCancelled, animated: false)
            fromVC.endAppearanceTransition()
            toVC.endAppearanceTransition()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
