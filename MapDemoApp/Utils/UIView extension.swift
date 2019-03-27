//
//  UIView extension.swift
//  MapDemoApp
//
//  Created by kitaharamugirou on 2019/03/11.
//  Copyright © 2019 kitaharamugirou. All rights reserved.
//

import Foundation
import UIKit
extension UIView {
    func setShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.layer.shadowRadius = 1.0
        self.layer.shadowOpacity = 0.5
    }
    
    func setTopShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: -3.0)
        self.layer.shadowRadius = 10.0
        self.layer.shadowOpacity = 0.5
    }
    
    func setRound(cornerRadius : CGFloat? = nil) {
        self.layer.masksToBounds = false
        self.layer.cornerRadius = cornerRadius ?? self.frame.height / 2
    }
    
    func gradation(topColor : UIColor , bottomColor : UIColor) {
        //グラデーションの色を配列で管理
        let gradientColors: [CGColor] = [topColor.cgColor, bottomColor.cgColor]
        
        //グラデーションレイヤーを作成
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        
        //グラデーションの色をレイヤーに割り当てる
        gradientLayer.colors = gradientColors
        //グラデーションレイヤーをスクリーンサイズにする
        gradientLayer.frame = self.bounds
        
        //グラデーションレイヤーをビューの一番下に配置
        self.layer.insertSublayer(gradientLayer, at: 0)

    }
}
