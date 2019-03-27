//
//  RatingView.swift
//  MapDemoApp
//
//  Created by kitaharamugirou on 2019/03/21.
//  Copyright © 2019 kitaharamugirou. All rights reserved.
//

import UIKit
import Cosmos
import TinyConstraints

class RatingView: UIView {
    lazy private var rateView : CosmosView = self.createRateView()
    
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
        self.addSubview(rateView)
        rateView.centerInSuperview()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutRateView()
    }
    
    private func layoutRateView() {
        //rateView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        //rateView.center = self.center
    }
    
    private func createRateView() -> CosmosView {
        let view = CosmosView()
        return view
    }
    
    func setRate(rating : Double , text : String?) {
        rateView.rating = rating
        rateView.text = text
    }
    
    func customizeRateView(
        updateOnTouch : Bool ,
        fillMode : StarFillMode = .precise,
        starSize : Double = 30 ,
        starMargin : Double = 5 ,
        filledColor : UIColor = UIColor.mainRed() ,
        emptyBorderColor : UIColor = UIColor.mainRed() ,
        filledBorderColor : UIColor = UIColor.mainRed()
        ) {
        // Do not change rating when touched
        // Use if you need just to show the stars without getting user's input
        rateView.settings.updateOnTouch = updateOnTouch
        
        // Show only fully filled stars
        rateView.settings.fillMode = fillMode
        // Other fill modes: .half, .precise
        
        // Change the size of the stars
        rateView.settings.starSize = starSize
        
        // Set the distance between stars
        rateView.settings.starMargin = starMargin
        
        // Set the color of a filled star
        rateView.settings.filledColor = filledColor
        
        // Set the border color of an empty star
        rateView.settings.emptyBorderColor = emptyBorderColor
        
        // Set the border color of a filled star
        rateView.settings.filledBorderColor = filledBorderColor
    }
    
}
