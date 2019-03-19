//
//  BottomView.swift
//  MapDemoApp
//
//  Created by kitaharamugirou on 2019/03/10.
//  Copyright © 2019 kitaharamugirou. All rights reserved.
//

import UIKit
protocol MapBottomViewDelegate : class {
    func onClickSettingButton()
    func onClickButton()
}
class MapBottomView: UIView {
    // MARK: - Properties -
    lazy private var button:RoundFloatingButton = self.createButton()
    lazy private var settingButton : UIButton = self.createSettingButton()
    weak var delegate : MapBottomViewDelegate? = nil

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
        self.addSubview(button)
        self.addSubview(settingButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutSelf()
        self.layoutButton()
        self.layoutSettingButton()
    }
    
    // MARK: - Create subviews -
    private func createButton() -> RoundFloatingButton {
        let view = RoundFloatingButton()
        view.setText(text: "MeetMe")
        view.delegate = self
        return view
    }
    
    private func createSettingButton() -> UIButton {
        let view = UIButton()
        let image = UIImage(named: "setting2.png")
        view.setImage(image, for: .normal)
        view.setRound()
        view.addTarget(self, action: #selector(self.onClickSettingButton(_:)), for: UIControl.Event.touchUpInside)
        return view
    }
    
    @objc private func onClickSettingButton(_ sender : Any) {
        self.delegate?.onClickSettingButton()
    }
    
    // MARK: - Layout subviews -
    private func layoutButton() {
        let height : CGFloat = 40
        let width : CGFloat = 180
        let x = self.frame.width / 2 - width / 2
        let y = self.frame.height - height - 40
        button.frame = CGRect(x: x, y: y, width: width, height: height)
    }
    
    private func layoutSettingButton() {
        let height : CGFloat = 40
        let width : CGFloat = 40
        let x = self.frame.width - width - 30
        let y = self.frame.height - height - 40
        settingButton.frame = CGRect(x: x, y: y, width: width, height: height)
    }
    
    private func layoutSelf() {
        let top = UIColor(red: 0, green: 0, blue: 9, alpha: 0)
        let bottom = UIColor(red: 255, green: 255, blue: 255, alpha: 0.8)
        self.gradation(topColor: top, bottomColor: bottom)
    }
}

extension MapBottomView : RoundFloatingButtonDelegate {
    func onClickButton() {
        //popup TextView and
        self.delegate?.onClickButton()
        button.setLoading(bool: true)
        dispatch_after(5.0) {
            self.button.setLoading(bool: false)
        }
    }
}
