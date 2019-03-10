//
//  BottomView.swift
//  MapDemoApp
//
//  Created by kitaharamugirou on 2019/03/10.
//  Copyright © 2019 kitaharamugirou. All rights reserved.
//

import UIKit

class MapBottomView: UIView {
    // MARK: - Properties -
    lazy private var button:RoundFloatingButton = self.createButton()

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
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutButton()
    }
    
    // MARK: - Create subviews -
    private func createButton() -> RoundFloatingButton {
        let view = RoundFloatingButton()
        view.setText(text: "MeetMe")
        view.delegate = self
        return view
    }
    
    // MARK: - Layout subviews -
    private func layoutButton() {
        let height : CGFloat = 40
        let width : CGFloat = 180
        let x = self.frame.width / 2 - width / 2
        let y = self.frame.height - height - 40
        button.frame = CGRect(x: x, y: y, width: width, height: height)
    }
}

extension MapBottomView : RoundFloatingButtonDelegate {
    func onClickButton() {
        //popup TextView and
        button.setLoading(bool: true)
        dispatch_after(7.0) {
            self.button.setLoading(bool: false)
        }
    }
}
