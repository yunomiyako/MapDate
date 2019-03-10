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
            button.layer.shadowColor = UIColor.black.cgColor
            button.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            button.layer.masksToBounds = false
            button.layer.shadowRadius = 1.0
            button.layer.shadowOpacity = 0.5
            button.layer.cornerRadius = button.frame.height / 2
            button.titleLabel?.font = UIFont.bigBoldFont()
        }
        
    }
    
    func setLoading(bool : Bool) {
        let tag = 808404
        loading = bool
        if bool {
            button.titleLabel?.alpha = 0
            let indicator = UIActivityIndicatorView()
            indicator.tag = tag
            button.addSubview(indicator)
            indicator.center = CGPoint(x : 25, y : 25)
            indicator.startAnimating()
        } else {
            button.titleLabel?.alpha = 1
            if let indicator = button.viewWithTag(tag) as? UIActivityIndicatorView {
                indicator.stopAnimating()
                indicator.removeFromSuperview()
            }
        }
        
        UIView.animate(withDuration: 0.8) {
            self.layoutButton()
        }
    }
    
    func setText(text : String) {
        button.setTitle(text, for: .normal)
    }
    
    @IBAction func onClickButton(_ sender : Any) {
        self.delegate?.onClickButton()
    }
    
    

}
