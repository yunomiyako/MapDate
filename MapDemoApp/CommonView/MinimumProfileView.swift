//
//  MinimumProfileView.swift
//  MapDemoApp
//
//  Created by kitaharamugirou on 2019/03/21.
//  Copyright © 2019 kitaharamugirou. All rights reserved.
//

import UIKit
import Cartography
class MinimumProfileView: UIView {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var rateBaseView: UIView!
    
    lazy private var rateView : RatingView = self.createRatingView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.rateBaseView.addSubview(rateView)
        Cartography.constrain(rateView) { view in
            view.left == view.superview!.left + 10
            view.right == view.superview!.right - 20
            view.top == view.superview!.top
            view.bottom == view.superview!.bottom
        }
        
        profileImageView.setRound()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        LogDebug("minimum profile frame = \(self.frame.debugDescription)")
    }
    
    private func createRatingView() -> RatingView {
        let view = RatingView()
        view.customizeRateView(updateOnTouch: false , starSize : 20)
        return view
    }
    
    func setRate(rating: Double, text: String?) {
        rateView.setRate(rating: rating, text: text)
    }
    
}
