//
//  Storyboard.swift
//  CardsView
//
//  Created by Serhii Kharauzov on 2/7/19.
//  Copyright © 2019 Serhii Kharauzov. All rights reserved.
//

import Foundation
import UIKit

enum Storyboard: String {
    case main = "Main"
    
    var instance: UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    func viewController<T: UIViewController>(_ viewControllerClass: T.Type) -> T {
        return instance.instantiateViewController(withIdentifier: viewControllerClass.reuseIdentifier) as! T
    }
}
