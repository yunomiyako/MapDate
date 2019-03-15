//
//  SliderCellTableViewCell.swift
//  MapDemoApp
//
//  Created by kitaharamugirou on 2019/03/15.
//  Copyright © 2019 kitaharamugirou. All rights reserved.
//

import UIKit
import MultiSlider
import Cartography
class SliderCellTableViewCell: UITableViewCell {
    
    lazy private var sliderView: MultiSlider = createMultiSlider()
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var bottomBaseView: UIView!
    
    private var rightTextUnit : String = ""
    private var by : Float = 0
    private var key : String = ""
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.bottomBaseView.addSubview(sliderView)
        Cartography.constrain(sliderView) { view in
            view.left == view.superview!.left + 20
            view.right == view.superview!.right - 20
            view.centerX == view.superview!.centerX
            view.centerY == view.superview!.centerY - 5
        }
    }
    
    private func createMultiSlider() -> MultiSlider {
//        let view = MultiSlider()
//        view.addTarget(self, action: #selector(sliderDidChangeValue(_:)), for: .valueChanged)

        let horizontalMultiSlider = MultiSlider()
        horizontalMultiSlider.orientation = .horizontal
        horizontalMultiSlider.showsThumbImageShadow = true
        horizontalMultiSlider.tintColor = UIColor.mainRed()
        horizontalMultiSlider.outerTrackColor = UIColor.gray
        horizontalMultiSlider.trackWidth = 10
        horizontalMultiSlider.addTarget(self, action: #selector(sliderDidChangeValue(_:)), for: .valueChanged)
        return horizontalMultiSlider
    }
    
    @objc private func sliderDidChangeValue(_ sender : Any) {
        let value = sliderView.value
        if value.count == 1 {
            rightLabel.text = "\(Int(value[0])) \(rightTextUnit)"
        } else {
            rightLabel.text = "\(Int(value[0])) \(rightTextUnit) \(Int(value[1]))"
        }
        
        //user defaultsに保存
        if value.count == 1 {
            UserDefaultsUseCase.sharedInstance.set(value[0], forKey: self.key)
        } else {
            UserDefaultsUseCase.sharedInstance.set(value, forKey: self.key)
        }
        
    }
    
    func setValue(value : [CGFloat]) {
        sliderView.thumbCount = value.count
        sliderView.value = value
        LogDebug(sliderView.value.debugDescription)
    }
    
    func setText(leftText : String , rightTextUnit : String) {
        self.leftLabel.text = leftText
        self.rightTextUnit = rightTextUnit
        
        let value = self.sliderView.value
        if value.count == 1 {
            rightLabel.text = "\(Int(value[0])) \(rightTextUnit)"
        } else {
            rightLabel.text = "\(Int(value[0])) \(rightTextUnit) \(Int(value[1]))"
        }
        LogDebug("setText : " + sliderView.value.debugDescription)
    }
    
    func setSliderConfig(min : CGFloat , max: CGFloat , by : CGFloat , key : String) {
        self.sliderView.maximumValue = max
        self.sliderView.minimumValue = min
        self.sliderView.snapStepSize = by
        self.key = key
    }
    
    func getValue() -> [CGFloat]? {
        return sliderView.value
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bottomBaseView.setRound(cornerRadius: 20)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
