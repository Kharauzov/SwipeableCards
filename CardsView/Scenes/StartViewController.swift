//
//  
//  CardsView
//
//  Created by Serhii Kharauzov on 2/10/19.
//  Copyright © 2019 Serhii Kharauzov. All rights reserved.
//

import Foundation
import UIKit

class StartViewController: UIViewController {
    
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
    
    var userImage: UIImage?
    let storage = MockStorage.shared
    let transition = MiniToLargeTransitionCoordinator()
    
    // MARK: Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setContentFromUserImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateViewState(isCardsContentAvailable: !storage.data.isEmpty)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        bottomTriggerView.hide(animated: false)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mainContainerView.roundAllCorners(cornerRadii: 10.0)
        bottomTriggerView.roundCorners(top: true, cornerRadii: 10.0)
        bottomTriggerImageViewHeightConstraint.constant = transition.bottomTriggerImageViewHeight
    }
    
    func updateViewState(isCardsContentAvailable: Bool) {
        if isCardsContentAvailable {
            bottomTriggerView.show(animated: false)
            bottomTriggerImageView.image = userImage
            transition.prepareViewForCustomTransition(fromViewController: self)
        } else {
            bottomTriggerView.show(animated: true)
            bottomTriggerImageView.image = nil
            transition.removeCustomTransitionBehaviour()
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
    
    // MARK: IBActions
    
    @IBAction func bottomTriggerButtonTapped() {
        if let viewControllerToPresent = transition.toViewController, !storage.data.isEmpty {
            present(viewControllerToPresent, animated: true)
        }
    }
}

extension StartViewController {
    static func instantiateViewController() -> StartViewController {
        return Storyboard.main.viewController(StartViewController.self)
    }
}

extension StartViewController: InteractiveTransitionableViewController {
    var interactivePresentTransition: MiniToLargeViewInteractiveAnimator? {
        return transition.interactivePresentTransition
    }
    var interactiveDismissTransition: MiniToLargeViewInteractiveAnimator? {
        return transition.interactiveDismissTransition
    }
}
