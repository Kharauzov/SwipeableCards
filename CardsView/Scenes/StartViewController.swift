//
//  
//  CardsView
//
//  Created by Serhii Kharauzov on 2/10/19.
//  Copyright © 2019 Serhii Kharauzov. All rights reserved.
//

import Foundation
import UIKit

class StartViewController: UIViewController, InteractiveTransitionableViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: IBOutlets
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var bottomTriggerButton: UIButton!
    @IBOutlet weak var bottomTriggerView: UIView!
    @IBOutlet weak var bottomTriggerImageView: UIImageView!
    @IBOutlet weak var bottomTriggerImageViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: Properties
    
    var cardsViewController: CardsViewController?
    var interactivePresentTransition: UIPercentDrivenInteractiveTransition?
    var interactiveDismissTransition: UIPercentDrivenInteractiveTransition?
    lazy var nextViewControllerInitialYPosition: CGFloat = {
        let bottomTriggerViewHeight = self.bottomTriggerView.frame.height
        let cardsViewYPosition = self.cardsViewController?.cardsView.frame.minY ?? 0
        let y = bottomTriggerViewHeight + cardsViewYPosition
        return y
    }()
    var userImage: UIImage?
    let storage = MockStorage.shared
    
    // MARK: Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setContentFromUserImage()
        prepareViewForCustomTransition()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateViewState(isCardsContentAvailable: storage.data.isEmpty)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        bottomTriggerView.hide(animated: false)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mainContainerView.roundAllCorners(cornerRadii: 10.0)
        bottomTriggerView.roundedCorners(top: true, cornerRadii: 10.0)
        bottomTriggerImageViewHeightConstraint.constant = cardsViewController?.cardImageViewHeight ?? 0
    }
    
    func updateViewState(isCardsContentAvailable: Bool) {
        if isCardsContentAvailable {
            bottomTriggerView.show(animated: true)
            removeCustomTransitionBehaviour()
        } else {
            bottomTriggerView.show(animated: false)
            bottomTriggerImageView.image = userImage
            prepareViewForCustomTransition()
        }
    }
    
    func setContentFromUserImage() {
        userImage = UIImage(named: storage.imageFileName)
        avatarImageView.image = userImage
        guard let userImage = userImage else { return }
        performBlurEffectOnImage(userImage, completion: { [weak self] (result) in
            self?.avatarImageView.image = result
        })
    }
    
    func performBlurEffectOnImage(_ image: UIImage, completion: @escaping ((_ image: UIImage) -> Void)) {
        DispatchQueue.global(qos: .default).async {
            image.applyBlurWithRadius(10, tintColor: UIColor(white: 0.11, alpha: 0.4), saturationDeltaFactor: 1.5, completion: { (bluredImage) in
                DispatchQueue.main.async {
                    completion(bluredImage ?? image)
                }
            })
        }
    }
    
    func prepareViewForCustomTransition() {
        let nextViewController = CardsViewController.instantiateViewController()
        nextViewController.transitioningDelegate = self
        nextViewController.modalPresentationStyle = .custom
        interactivePresentTransition = MiniToLargeViewInteractiveAnimator(fromViewController: self, toViewController: nextViewController, gestureView: bottomTriggerView)
        interactiveDismissTransition = MiniToLargeViewInteractiveAnimator(fromViewController: nextViewController, toViewController: nil, gestureView: nextViewController.view)
        self.cardsViewController = nextViewController
    }
    
    func removeCustomTransitionBehaviour() {
        bottomTriggerImageView.image = nil
        interactivePresentTransition = nil
        interactiveDismissTransition = nil
        cardsViewController = nil
    }
    
    // MARK: IBActions
    
    @IBAction func bottomTriggerButtonTapped() {
        if let viewControllerToPresent = cardsViewController, !storage.data.isEmpty {
            present(viewControllerToPresent, animated: true)
        }
    }
}

extension StartViewController {
    static func instantiateViewController() -> StartViewController {
        return Storyboard.main.viewController(StartViewController.self)
    }
}

extension StartViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return MiniToLargePresentingViewAnimator(initialY: nextViewControllerInitialYPosition)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return MiniToLargeDismissingViewAnimator(initialY: nextViewControllerInitialYPosition)
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let presentInteractor = interactivePresentTransition as? MiniToLargeViewInteractiveAnimator else {
            return nil
        }
        guard presentInteractor.isTransitionInProgress else {
            return nil
        }
        return presentInteractor
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let dismissInteractor = interactiveDismissTransition as? MiniToLargeViewInteractiveAnimator else {
            return nil
        }
        guard dismissInteractor.isTransitionInProgress else {
            return nil
        }
        return dismissInteractor
    }
}
