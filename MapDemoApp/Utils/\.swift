//
//  UIButton.swift
//  MapDemoApp
//
//  Created by kitaharamugirou on 2019/03/10.
//  Copyright © 2019 kitaharamugirou. All rights reserved.
//

import Foundation
import UIKit

//押された感が出る
class UIButtonAnimated: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.touchStartAnimation()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        self.touchEndAnimation()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.touchEndAnimation()
    }

    private func touchStartAnimation(){
        UIView.animate(withDuration: 0.1,
                                   delay: 0.0,
                                   options: UIView.AnimationOptions.curveEaseIn,
                                   animations: {() -> Void in
                                    self.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        },
                                   completion: nil
        )
    }
    private func touchEndAnimation(){
        UIView.animate(withDuration: 0.1,
                                   delay: 0.0,
                                   options: UIView.AnimationOptions.curveEaseIn,
                                   animations: {() -> Void in
                                    
                                    self.transform = CGAffineTransform.identity
        },
                                   completion: nil
        )
    }
    
}
