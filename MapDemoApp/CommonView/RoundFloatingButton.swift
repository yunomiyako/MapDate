//
//  RoundFloatingButton.swift
//  MapDemoApp
//
//  Created by kitaharamugirou on 2019/03/10.
//  Copyright © 2019 kitaharamugirou. All rights reserved.
//

import UIKit

protocol RoundFloatingButtonDelegate : class {
    func onClickButton()
}

class RoundFloatingButton: UIView {
    // MARK: - Properties -
    lazy private var button = self.createButton()
    weak var delegate :RoundFloatingButtonDelegate? = nil
    private var loading = false
    private let indicator = UIActivityIndicatorView()
    
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
    
    private func createButton() -> UIButton {
        let button = UIButton()
        button.addTarget(self, action: #selector(self.onClickButton(_:)), for: UIControl.Event.touchUpInside)
        return button
    }
    
    private func layoutButton() {
        if loading {
            button.frame.size = CGSize(width: 50, height: 50)
            button.center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
            button.titleLabel?.isHidden = true
            
        } else {
            button.frame.size = self.frame.size
            button.center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
            button.backgroundColor = UIColor.mainRed()
            button.titleLabel?.font = UIFont.bigBoldFont()
            button.setShadow()
            button.setRound()
        }
        
    }
    
    func setLoading(bool : Bool) {
        loading = bool
        if !bool {
            self.button.isUserInteractionEnabled = true
            self.button.titleLabel?.alpha = 1
            indicator.stopAnimating()
            indicator.removeFromSuperview()
        } else {
            self.button.isUserInteractionEnabled = false
            self.button.titleLabel?.alpha = 0
        }

        UIView.animate(withDuration: 0.8, animations: {
            self.layoutButton()
        }, completion: { _ in
            if bool {
                self.button.addSubview(self.indicator)
                self.indicator.center = CGPoint(x : 25, y : 25)
                self.indicator.startAnimating()
            } else {
                self.indicator.removeFromSuperview()
            }
        })
    }
    
    func setText(text : String) {
        button.setTitle(text, for: .normal)
    }
    
    @IBAction func onClickButton(_ sender : Any) {
        self.delegate?.onClickButton()
    }
    
    

}
