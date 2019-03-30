//
//  MapBottomWhenMatchedView.swift
//  MapDemoApp
//
//  Created by kitaharamugirou on 2019/03/19.
//  Copyright © 2019 kitaharamugirou. All rights reserved.
//

import UIKit
import RAMPaperSwitch
import SwiftIcons

class MapBottomWhenMatchedView: UIView {

    // MARK: - Properties -
    lazy private var baseView : UIView = UIView()
    lazy private var paperSwitch : RAMPaperSwitch = {
        let view = RAMPaperSwitch(view: self.baseView , color: UIColor.mainPink())
        view.tintColor = UIColor.mainPink()
        view.animationDidStartClosure = { _ in
            self.delegate?.onToggleShareLocation(on : view.isOn)
        }
        return view
    }()
    lazy private var locationInfoDescriptionLabel : UILabel = {
        let label = UILabel()
        label.setIcon(prefixText: "" , icon: .fontAwesomeSolid(.locationArrow), postfixText: " Share Your Location", size: 20)
        label.textColor = UIColor.black
        label.numberOfLines = 1
        return label
    }()
    
    lazy private var partitionView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    
    lazy private var miniProfileView = self.createMiniProfile()
    
    lazy private var chatButton : UIButton = {
        let view = UIButton()
        let image = UIImage.init(bgIcon: .fontAwesomeRegular(.circle), topIcon: .fontAwesomeRegular(.comments))
        view.setImage(image, for: .normal)
        view.clipsToBounds = true
        view.setRound()
        view.addTarget(self, action: #selector(self.onClickChatButton(_:)), for: UIControl.Event.touchUpInside)
        return view
    }()
    
    lazy private var finishButton : UIButton = {
        let view = UIButton()
        // Icon with size and color
        view.setIcon(icon: .fontAwesomeRegular(.timesCircle ), iconSize: 40, color: UIColor.mainRed(), forState: .normal)
        view.clipsToBounds = true
        view.setRound()
        view.addTarget(self, action: #selector(self.onClickFinishButton(_:)), for: UIControl.Event.touchUpInside)
        return view
    }()
    
    lazy private var safelyMetButton : RoundFloatingButton = {
        let view = RoundFloatingButton()
        view.setText(text: NSLocalizedString("ICouldMeetSafely", tableName: "MapStrings", comment: ""))
        view.delegate = self
        view.setDisable(disable: true)
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
        self.addSubview(baseView)
        self.baseView.addSubview(paperSwitch)
        self.baseView.addSubview(locationInfoDescriptionLabel)
        self.baseView.addSubview(partitionView)
        self.baseView.addSubview(chatButton)
        self.baseView.addSubview(finishButton)
        self.baseView.addSubview(safelyMetButton)
        //なぜかminiProfileViewをbaseViewに乗せるとバグる・・・
        self.addSubview(miniProfileView)
        
        //test by kitahara
        miniProfileView.setRate(rating: 3.5, text: nil)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutUpperFrame()
        self.layoutChatButton()
        self.layoutBaseView()
        self.layoutSafelyMetButton()
    }
    
    // MARK: - Create subviews -
    
    private func createMiniProfile() -> MinimumProfileView {
        let view = MinimumProfileView.instantiate(className: "MinimumProfileView")
        view.backgroundColor = UIColor.clear
        return view
    }

    // MARK: - Layout subviews -
    private func layoutBaseView() {
        self.baseView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
    }
    
    private func layoutUpperFrame() {
        let x_1 = self.frame.width  - paperSwitch.frame.width - 30
        let x_2 : CGFloat = 30
        let y : CGFloat = 20
        paperSwitch.frame.origin = CGPoint(x: x_1, y: y)
        locationInfoDescriptionLabel.frame.origin = CGPoint(x: x_2, y: y)
        locationInfoDescriptionLabel.sizeToFit()
        
        let partition_y = y  + max(paperSwitch.frame.height , locationInfoDescriptionLabel.frame.height)
        partitionView.frame = CGRect(x: 0, y: partition_y + 10, width: self.frame.width, height: 1)
    }
    
    private func layoutChatButton() {
        self.bringSubviewToFront(chatButton)
        self.bringSubviewToFront(finishButton)
        //ちょっとごちゃごちゃしすぎ
        let miniProfileHeight : CGFloat = 70
        let chatButtonSideLength : CGFloat = 60
        
        let x = self.frame.width  - chatButtonSideLength - 15
        let y = partitionView.frame.maxY + 20 + (miniProfileHeight - chatButtonSideLength) / 2
        chatButton.frame = CGRect(x: x, y: y, width: chatButtonSideLength, height: chatButtonSideLength)
        finishButton.frame = CGRect(x: x - chatButtonSideLength - 5, y: y, width: chatButtonSideLength, height: chatButtonSideLength)
        
        let x_2 : CGFloat = 10
        let y_2 = partitionView.frame.maxY + 20
        let width = min(self.frame.width - 2 * chatButtonSideLength - 50 , 400)

        miniProfileView.frame = CGRect(x: x_2, y: y_2, width: width, height: miniProfileHeight)
        self.bringSubviewToFront(miniProfileView)
    }
    
    private func layoutSafelyMetButton() {
        let x : CGFloat = 10
        let y = miniProfileView.frame.maxY + 20
        let height : CGFloat = 60
        safelyMetButton.frame = CGRect(x: x, y: y, width: self.frame.width - 2*x, height: height)
        self.baseView.bringSubviewToFront(safelyMetButton)
    }
    
    
    
    @objc private func onClickChatButton(_ sender : Any) {
        self.delegate?.onClickChatButton()
    }

    @objc private func onClickFinishButton(_ sender : Any) {
        self.delegate?.onClickFinishButton()
    }
    
    func setButtonDisable(disable : Bool) {
        self.safelyMetButton.setDisable(disable: disable)
    }
}

extension MapBottomWhenMatchedView : RoundFloatingButtonDelegate {
    func onClickButton() {
        self.delegate?.onClickSafelyMetButton()
    }
}
