//
//  VerticalProfileView.swift
//  MapDemoApp
//
//  Created by kitaharamugirou on 2019/03/24.
//  Copyright © 2019 kitaharamugirou. All rights reserved.
//

import UIKit
import Cartography
import TinyConstraints
class VerticalProfileView: UIView {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var rateBaseView: UIView!
    
    
    lazy private var rateView : RatingView = self.createRatingView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.rateBaseView.addSubview(rateView)
        
        rateView.width(200)
        rateView.centerX(to: self.rateBaseView)
        rateView.centerY(to: self.rateBaseView)
        rateView.top(to: self.rateBaseView)
        //test by kitahara not work
        profileImageView.setRound()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func createRatingView() -> RatingView {
        let view = RatingView()
        view.customizeRateView(updateOnTouch: false , starSize : 40)
        return view
    }
    
    func setUpdateOnTouch(touchable : Bool , startSize : Double) {
        rateView.customizeRateView(updateOnTouch: touchable , starSize : startSize)
    }
    
    func setRate(rating: Double, text: String?) {
        rateView.setRate(rating: rating, text: text)
    }
    
    func setName(name : String) {
        nameLabel.text = name
    }
    
}
