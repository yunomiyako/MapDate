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

protocol SliderCellTableViewCellDelegate : class {
    func onChangeValue(value : [CGFloat])
}

class SliderCellTableViewCell: UITableViewCell {
    
    lazy private var sliderView: MultiSlider = createMultiSlider()
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var bottomBaseView: UIView!
    
    weak var delegate : SliderCellTableViewCellDelegate? = nil
    
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
        
        self.delegate?.onChangeValue(value: value)
    }
    
    func setValue(value : [CGFloat]) {
        sliderView.thumbCount = value.count
        sliderView.value = value
        if value.count == 1 {
            sliderView.tintColor = UIColor.gray
        }
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
    }
    
    func setSliderConfig(min : CGFloat , max: CGFloat , by : CGFloat , delegate : SliderCellTableViewCellDelegate ) {
        self.sliderView.maximumValue = max
        self.sliderView.minimumValue = min
        self.sliderView.snapStepSize = by
        self.delegate = delegate
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
