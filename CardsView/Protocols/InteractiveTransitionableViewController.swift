//
//  InteractiveTransitionableViewController.swift
//  CardsView
//
//  Created by Serhii Kharauzov on 2/11/19.
//  Copyright © 2019 Serhii Kharauzov. All rights reserved.
//

import Foundation
import UIKit

protocol InteractiveTransitionableViewController {
    var interactivePresentTransition: MiniToLargeViewInteractiveAnimator? { get }
    var interactiveDismissTransition: MiniToLargeViewInteractiveAnimator? { get }
}
