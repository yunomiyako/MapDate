//
//  MapBottomWhenMatchedView.swift
//  MapDemoApp
//
//  Created by kitaharamugirou on 2019/03/19.
//  Copyright © 2019 kitaharamugirou. All rights reserved.
//

import UIKit
import RAMPaperSwitch

class MapBottomWhenMatchedView: UIView {

    // MARK: - Properties -
    lazy private var paperSwitch : RAMPaperSwitch = {
        let view = RAMPaperSwitch(view: self, color: UIColor.mainRed())
        view.tintColor = UIColor.mainRed()
        return view
    }()
    
    
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
        self.backgroundColor = .white
        self.addSubview(paperSwitch)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutButton()
    }
    
    // MARK: - Create subviews -

    // MARK: - Layout subviews -
    private func layoutButton() {
        let x = self.frame.width / 2 - paperSwitch.frame.width / 2
        let y = self.frame.height / 2 - paperSwitch.frame.height / 2
        paperSwitch.frame.origin = CGPoint(x: x, y: y)
    }
}
