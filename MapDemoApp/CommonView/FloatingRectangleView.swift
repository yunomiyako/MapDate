//
//  FloatingRectangleView.swift
//  MapDemoApp
//
//  Created by kitaharamugirou on 2019/03/10.
//  Copyright © 2019 kitaharamugirou. All rights reserved.
//

import UIKit
import Cartography

class FloatingRectangleView: UIView {
    
    lazy var baseView = UIView()
    lazy var label = UILabel()
    private var isShow = false

    // MARK: - Life cycle events -
    required override init(frame: CGRect) {
        super.init(frame: frame)
        self.childInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        self.childInit()
    }
    
    private func childInit() {
        self.isUserInteractionEnabled = false
        self.addSubview(baseView)
        baseView.backgroundColor = UIColor.white
        baseView.setRound(cornerRadius: 30)
        baseView.setShadow()
        baseView.isHidden = true
        
        label.textColor = UIColor.black
        label.font = UIFont.normalFont()
        self.baseView.addSubview(label)
        Cartography.constrain(label) { view in
            view.top == view.superview!.top + 10
            view.left == view.superview!.left + 20
            view.right == view.superview!.right - 20
            view.bottom == view.superview!.bottom - 10
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutBaseView()
    }
    
    private func layoutBaseView() {
        let x_margin : CGFloat = 30
        let y_margin : CGFloat = 50
        baseView.frame.size = CGSize(width: self.frame.width - 2*x_margin, height: self.frame.height - y_margin)
        if isShow {
            baseView.frame.origin = CGPoint(x: x_margin , y: y_margin)
            baseView.center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        } else {
            self.baseView.center = CGPoint(x: self.frame.width / 2, y: -self.frame.height)
        }

    }
    
    
    func setText(text : String) {
        label.text = text
    }
    
    func showUpAnimation() {
        self.isShow = true
        self.baseView.isHidden = false
        self.baseView.center = CGPoint(x: self.frame.width / 2, y: -self.frame.height)
        UIView.animate(withDuration: 2 , animations: {
            self.layoutBaseView()
        }, completion : { _ in
            self.isShow = false
            UIView.animate(withDuration: 2 , delay : 3 ,  animations: {
                self.layoutBaseView()
            } , completion : { _ in
                self.isHidden = true
            })
        })
    }
}
