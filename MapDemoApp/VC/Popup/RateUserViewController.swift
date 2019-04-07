//
//  RateUserViewController.swift
//  MapDemoApp
//
//  Created by kitaharamugirou on 2019/03/28.
//  Copyright © 2019 kitaharamugirou. All rights reserved.
//

import UIKit

protocol RateuserViewControllerDelegate : class {
    func onClickRateOk(rate : Double)
}

class RateUserViewController: UIViewController {
    lazy private var topLabel : UILabel = {
        let view = UILabel()
        view.text = "Have a good day!"
        view.textAlignment = .center
        view.numberOfLines = 0
        view.font = UIFont.bigBoldFont()
        return view
    }()
    
    lazy private var profileView : VerticalProfileView = {
        let view = VerticalProfileView.instantiate(className: "VerticalProfileView")
        view.hideStar(visible : false)
        view.delegate = self
        return view
    }()
    
    lazy private var okButton : RoundFloatingButton = {
        let view = RoundFloatingButton()
        view.setText(text: "said Goodbye?")
        view.delegate = self
        return view
    }()
    
    weak var delegate : RateuserViewControllerDelegate? = nil
    fileprivate var onClickHandler : (() -> ())? = nil
    fileprivate var isRateMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.view.setRound(cornerRadius: 40)
        
        self.view.addSubview(topLabel)
        self.view.addSubview(profileView)
        self.view.addSubview(okButton)
        
        //test by kitahara
        profileView.setRate(rating: 0, text: nil)
        profileView.setUpdateOnTouch(touchable: true, startSize: 50)
        profileView.setName(name: "田中公平")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.layoutTopLabel()
        self.layoutProfileView()
        self.layoutOkButton()
    }
    
    private func layoutTopLabel() {
        let width = self.view.frame.width - 20
        let height : CGFloat = 30 //test by kitahara let it be auto
        topLabel.frame = CGRect(x: 10, y: 20, width: width, height: height)
        topLabel.sizeToFit()
        topLabel.frame.size.width = self.view.frame.width - 20
    }
    
    private func layoutProfileView() {
        let width = self.view.frame.width - 20
        let height : CGFloat = 420
        let y : CGFloat = self.view.frame.height / 2 - height / 2
        profileView.frame = CGRect(x: 10, y: y, width: width, height: height)
        LogDebug("profileView frame = \(profileView.frame.debugDescription)")
    }
    
    private func layoutOkButton() {
        let width = self.view.frame.width - 70
        let height : CGFloat = 60
        let y : CGFloat = self.view.frame.height - 20 - height
        okButton.frame = CGRect(x: 35, y: y, width: width, height: height)
    }
    
    func addButtonClickListener(handler : @escaping () -> ()) {
        self.onClickHandler = handler
    }
    
}

extension RateUserViewController : RoundFloatingButtonDelegate {
    func onClickButton() {
        profileView.hideStar(visible : true)
        if !isRateMode {
            self.topLabel.text = "How was your day? Rate him/her."
            self.okButton.setText(text: "OK")
            self.okButton.setDisable(disable: true)
            self.onClickHandler?()
            isRateMode = true
        } else {
            let rate = profileView.getRate()
            self.delegate?.onClickRateOk(rate: rate)
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension RateUserViewController : VerticalProfileViewDelegate {
    func didFinishTouchingCosmos(rate: Double) {
        self.okButton.setDisable(disable: false)
    }
}
