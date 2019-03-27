//
//  AnimationUtils.swift
//  MapDemoApp
//
//  Created by kitaharamugirou on 2019/03/21.
//  Copyright © 2019 kitaharamugirou. All rights reserved.
//

import Foundation
import UIKit

class AnimationUtils {
    static func transitionTwoViewAppearance(fromView : UIView , toView : UIView , whereGo : CGPoint , afterLayout : @escaping () -> () ) {
        
        toView.frame.origin = whereGo
        toView.isHidden = false
        UIView.animate(withDuration: 0.8, animations: {
            fromView.frame.origin = whereGo
        }){ animated in
            UIView.animate(withDuration: 0.8, animations: {
                afterLayout()
            })
        }
    }
}
