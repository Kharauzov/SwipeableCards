//
//  
//  CardsView
//
//  Created by Serhii Kharauzov on 2/10/19.
//  Copyright © 2019 Serhii Kharauzov. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func roundCorners(corners: UIRectCorner, cornerRadii: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: self.bounds,
                                    byRoundingCorners: corners,
                                    cornerRadii:CGSize(width: cornerRadii, height: cornerRadii))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
    
    func roundCorners(top: Bool, cornerRadii: CGFloat){
        let corners: UIRectCorner = top ? [.topLeft , .topRight] : [.bottomRight , .bottomLeft]
        roundCorners(corners: corners, cornerRadii: cornerRadii)
    }
    
    func roundAllCorners(cornerRadii: CGFloat) {
        let corners: UIRectCorner = .allCorners
        roundCorners(corners: corners, cornerRadii: cornerRadii)
    }
    
    func show(animated: Bool) {
        let timeInterval: TimeInterval = animated ? 0.33 : 0
        UIView.animate(withDuration: timeInterval) {
            self.alpha = 1
        }
    }
    
    func hide(animated: Bool) {
        let timeInterval: TimeInterval = animated ? 0.33 : 0
        UIView.animate(withDuration: timeInterval) {
            self.alpha = 0
        }
    }
}
