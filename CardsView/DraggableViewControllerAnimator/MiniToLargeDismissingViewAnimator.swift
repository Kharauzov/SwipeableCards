//
//  MiniToLargeDismissingViewAnimator.swift
//  CardsView
//
//  Created by Serhii Kharauzov on 2/10/19.
//  Copyright © 2019 Serhii Kharauzov. All rights reserved.
//

import Foundation
import UIKit

class MiniToLargeDismissingViewAnimator: NSObject, UIViewControllerAnimatedTransitioning {
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
        guard let toVC = transitionContext.viewController(forKey: .to) else {
            return
        }
        guard let fromVC = transitionContext.viewController(forKey: .from) else {
            return
        }
        guard let animatableFromVC = fromVC as? MiniToLargeAnimatable else {
            return
        }
        var fromVCRect = transitionContext.initialFrame(for: fromVC)
        fromVCRect.origin.y = fromVCRect.size.height - initialY
        animatableFromVC.animatableBackgroundView.alpha = 1
        UIView.animate(withDuration: duration, animations: {
            animatableFromVC.animatableMainView.frame = fromVCRect
            animatableFromVC.animatableBackgroundView.alpha = 0
        }) { (_) in
            if !transitionContext.transitionWasCancelled {
                fromVC.beginAppearanceTransition(false, animated: true)
                toVC.beginAppearanceTransition(true, animated: true)
                fromVC.endAppearanceTransition()
                toVC.endAppearanceTransition()
            }
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
