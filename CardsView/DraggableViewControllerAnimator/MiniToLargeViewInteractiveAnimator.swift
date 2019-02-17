//
//  MiniToLargeViewInteractiveAnimator.swift
//  CardsView
//
//  Created by Serhii Kharauzov on 2/10/19.
//  Copyright © 2019 Serhii Kharauzov. All rights reserved.
//

import Foundation
import UIKit

class MiniToLargeViewInteractiveAnimator: UIPercentDrivenInteractiveTransition {
    let fromViewController: UIViewController
    let toViewController: UIViewController?
    var isTransitionInProgress = false
    var isEnabled = true
    private var shouldComplete = false
    private let pan: UIPanGestureRecognizer
    private let threshold: CGFloat = 0.3
    private let targetScreenHeight = UIScreen.main.bounds.height - 150
    private lazy var dragAmount = toViewController == nil ? targetScreenHeight : -targetScreenHeight
    
    init(fromViewController: UIViewController, toViewController: UIViewController?, gestureView: UIView) {
        self.fromViewController = fromViewController
        self.toViewController = toViewController
        self.pan = UIPanGestureRecognizer()
        super.init()
        pan.addTarget(self, action: #selector(onPan(_:)))
        gestureView.addGestureRecognizer(pan)
        completionSpeed = 0.6
    }
    
    deinit {
        pan.view?.removeGestureRecognizer(pan)
    }
    
    @objc func onPan(_ pan: UIPanGestureRecognizer) {
        if !isEnabled { return }
        let translation = pan.translation(in: pan.view?.superview)
        switch pan.state {
        case .began:
            isTransitionInProgress = true
            if let toViewController = toViewController {
                fromViewController.present(toViewController, animated: true, completion: nil)
            } else {
                fromViewController.dismiss(animated: true, completion: nil)
            }
        case .changed:
            isTransitionInProgress = true
            var percent = translation.y / dragAmount
            percent = fmax(percent, 0)
            percent = fmin(percent, 1)
            update(percent)
            shouldComplete = percent > threshold
            if shouldComplete {
                (fromViewController as? MiniToLargeAnimatable)?.prepareBeingDismissed()
                finish()
            }
        case .ended:
            shouldComplete ? finish() : cancel()
            isTransitionInProgress = false
        case .cancelled:
            cancel()
            isTransitionInProgress = false
        default:
            isTransitionInProgress = false
        }
    }
}
