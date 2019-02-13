//
//
//  CardsView
//
//  Created by Serhii Kharauzov on 2/10/19.
//  Copyright © 2019 Serhii Kharauzov. All rights reserved.
//

import UIKit

// Protocol to inform that cell is being swiped up or down.
 protocol SwipingCollectionViewCellDelegate : class {
    func cellSwipedUp(_ cell: SwipingCollectionViewCell)
    func cellReturnedToInitialState(_ cell: SwipingCollectionViewCell)
}

open class SwipingCollectionViewCell: UICollectionViewCell {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var frontContentView: UIView!
    @IBOutlet weak var backContentView: UIView!
    
    // MARK: Public properties
    
    weak var delegate: SwipingCollectionViewCellDelegate?
    var swipeDistanceOnY: CGFloat = 0
    var swipeDistancePoint = CGPoint() //Distance of the swipe over "x" & "y" axis.
    var originalPoint = CGPoint()
    var isMovingFromInitialState = true
    var frontContainerViewCenterY: CGFloat {
        set {
            frontContentView.transform.ty = newValue
        } get {
            return frontContentView.transform.ty
        }
    }
    lazy var frontContainerViewInitialCenterY = self.frontContainerViewCenterY
    lazy var pan: UIPanGestureRecognizer = {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        pan.delegate = self
        return pan
    }()
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        _ = frontContainerViewInitialCenterY
        addGestureRecognizer(pan)
    }
    
    /// Called, when user tapped on any of the buttons at frontView of cell.
    func moveCellToInitialState(completion: @escaping () -> Void) {
        moveTargetViewToInitialPoint { 
            completion()
        }
    }
    
    /// 'percent' is a CGFloat value from 0 to 1.
    func frontViewPositionChanged(on percent: CGFloat) {
    }
}

// MARK: Swiping logic

extension SwipingCollectionViewCell {
    private struct Constants {
        static let swipeDistanceToTakeAction: CGFloat = UIScreen.main.bounds.size.height / 5 //Distance required for the cell to go off the screen.
        static let swipeImageAnimationDuration: TimeInterval = 0.3 //Duration of the Animation when Swiping Up/Down.
        static let centerImageAnimationDuration: TimeInterval = 0.3 //Duration of the Animation when image gets back to original postion.
    }
    
    @objc fileprivate func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        swipeDistancePoint = sender.translation(in: frontContentView) //Get the distance of the Swipe on "y" axis.
        let velocity = sender.velocity(in: frontContentView)
        //debugPrint("velocity \(velocity)")
        switch sender.state {
        case .began:
            originalPoint.y = frontContainerViewCenterY
        case .changed:
            let newYPointToSet = originalPoint.y + swipeDistancePoint.y
            if newYPointToSet > frontContainerViewInitialCenterY {
                if frontContainerViewInitialCenterY != frontContainerViewCenterY {
                    moveTargetViewToInitialPoint()
                }
                return
            }
            if velocity.x < 200 { // moves up
                frontContainerViewCenterY = newYPointToSet
                var delta: CGFloat = 0
                if isMovingFromInitialState {
                    delta = 1 - ((swipeDistanceOnY - abs(swipeDistancePoint.y)) / swipeDistanceOnY)
                } else {
                    delta = ((swipeDistanceOnY - abs(swipeDistancePoint.y)) / swipeDistanceOnY)
                }
                //debugPrint("delta \(delta)")
                frontViewPositionChanged(on: delta)
            }
        case .ended:
            //Take action after the Swipe gesture ends.
            afterSwipeAction()
        default:
            break
        }
    }
    
    func afterSwipeAction() {
        if swipeDistancePoint.y < -Constants.swipeDistanceToTakeAction {
            moveTargetViewUp()
        } else {
            moveTargetViewToInitialPoint()
        }
    }
    
    func moveTargetViewToInitialPoint(completion: (() -> Void)? = nil) {
        isMovingFromInitialState = true
        if frontContainerViewCenterY == 0 { return }
        let displayLink = CADisplayLink(target: self, selector: #selector(animationDidUpdate))
        displayLink.preferredFramesPerSecond = 60
        displayLink.add(to: RunLoop.main, forMode: RunLoop.Mode.default)
        UIView.animate(withDuration: Constants.centerImageAnimationDuration, animations: {
            self.frontContainerViewCenterY = 0
            (self.superview as? UICollectionView)?.isScrollEnabled = true
            self.delegate?.cellReturnedToInitialState(self)
        }, completion: { flag in
            displayLink.invalidate()
            if let completion = completion {
                completion()
            }
        })
    }
    
    func moveTargetViewUp() {
        isMovingFromInitialState = false
        let displayLink = CADisplayLink(target: self, selector: #selector(animationDidUpdate))
        displayLink.preferredFramesPerSecond = 60
        displayLink.add(to: RunLoop.main, forMode: RunLoop.Mode.default)
        UIView.animate(withDuration: Constants.swipeImageAnimationDuration, animations: {
            self.frontContainerViewCenterY = -self.swipeDistanceOnY
            (self.superview as? UICollectionView)?.isScrollEnabled = false
            self.delegate?.cellSwipedUp(self)
        }) { (finished) in
            displayLink.invalidate()
        }
    }
    
    @objc func animationDidUpdate() {
        if let presentationLayer = frontContentView.layer.presentation() {
            let delta = 1 - (swipeDistanceOnY - abs(presentationLayer.frame.origin.y)) / swipeDistanceOnY
            frontViewPositionChanged(on: delta)
        }
    }
}

// MARK: UIGestureRecognizerDelegate

extension SwipingCollectionViewCell: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
