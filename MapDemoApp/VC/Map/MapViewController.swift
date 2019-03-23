//
//  MapViewController.swift
//  MapDemoApp
//
//  Created by kitaharamugirou on 2019/03/10.
//  Copyright © 2019 kitaharamugirou. All rights reserved.
//

import UIKit
import Cartography

class MapViewController: UIViewController , PopUpShowable {

    // MARK: - Properties -
    lazy private var mapView:MapView = self.createMapView()
    lazy private var bottomView : MapBottomView = self.createBottomView()
    lazy private var bottomWhenMatchView : MapBottomWhenMatchedView = self.createBottomWhenMatchView()
    lazy private var topTextView : FloatingRectangleView = self.createTopTextView()
    
    private let mapUseCase = MapUseCase()
    private let matchUseCase = MatchUseCase()
    private let firebaseUseCase = FirebaseUseCase()
    
    private var discoveryRadius : Double = 3000
    
    //test by kitahara
    private var state : MapState = .initial  {
        willSet {
            
            if newValue == .initial {
                self.circleRange()
            }
            
            //FIXME : もっと綺麗に書けそう
            if state == .initial && newValue == .matched {
                let bottomPoint =  CGPoint(x: 0, y: self.view.frame.height)
                AnimationUtils.transitionTwoViewAppearance(fromView: self.bottomView, toView: self.bottomWhenMatchView, whereGo: bottomPoint, afterLayout: {
                    self.switchBottomViewLayout()
                })
            } else if state == .matched && newValue == .initial {
                let bottomPoint =  CGPoint(x: 0, y: self.view.frame.height)
                AnimationUtils.transitionTwoViewAppearance(fromView: self.bottomWhenMatchView, toView: self.bottomView, whereGo: bottomPoint, afterLayout: {
                    self.switchBottomViewLayout()
                })
            }
        }
        didSet {
            if oldValue == .initial {
                self.mapView.stopCircleAnimation()
                self.mapView.removeCircleOverlay()
            }
        }
    }
    
    // MARK: - Life cycle events -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(mapView)
        self.view.addSubview(bottomView)
        self.view.addSubview(topTextView)
        self.view.addSubview(bottomWhenMatchView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.circleRange()
        
        //test by kitahara
        self.startUpdatingLocation()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.layoutMapView()
        self.switchBottomViewLayout()
        self.layoutTopTextView()
    }
    
    private func switchBottomViewLayout() {
        if self.state == .initial {
            self.layoutBottomView()
        } else {
            bottomView.isHidden = true
        }
        
        if self.state == .matched {
            self.layoutBottomWhenMatchView()
        } else {
            bottomWhenMatchView.isHidden = true
        }
    }
    
    // MARK: - Create subviews -
    private func createMapView() -> MapView {
        let view = MapView()
        view.delegate = self
        return view;
    }
    
    private func createBottomView() -> MapBottomView {
        let view = MapBottomView()
        view.delegate = self
        return view
    }
    
    private func createBottomWhenMatchView() -> MapBottomWhenMatchedView {
        let view = MapBottomWhenMatchedView()
        view.delegate = self
        return view
    }
    
    private func createTopTextView() -> FloatingRectangleView {
        let view = FloatingRectangleView()
        return view
    }
    
    // MARK: - Layout subviews -
    private func layoutMapView() {
        mapView.frame = self.view.frame
    }
    
    private func layoutBottomView() {
        let height : CGFloat = 100
        let y = self.view.frame.height
        bottomView.frame = CGRect(x: 0, y: y - height, width: self.view.frame.width, height: height)
    }
    
    private func layoutBottomWhenMatchView() {
        let height : CGFloat = 170
        let y = self.view.frame.height
        bottomWhenMatchView.frame = CGRect(x: 0, y: y - height, width: self.view.frame.width, height: height)
    }
    
    private func layoutTopTextView() {
        let height : CGFloat = 120
        topTextView.frame = CGRect(x: 0, y: 50 , width: self.view.frame.width, height: height)
    }


    
    private func openDiscoverySettingPage() {
        let vc = DiscoverySettingViewController()
        vc.delegate = self
        let nc = UINavigationController(rootViewController: vc)
        self.present(nc, animated: true, completion: nil)
    }
    
    fileprivate func circleRange() {
        //radiusを設定から取得して、自分を中心に円を描く
        let radius = Double(mapUseCase.getSyncDiscoveryDistance())
        let userLocation = self.mapView.getUserLocation()
        self.mapView.showCircleAroundUser(radius : radius)
        self.mapUseCase.getNearPeopleNumber(location: userLocation, radius: radius, completion: { number in
            dispatch_after(1, block: {
                self.topTextView.setText(text: "\(number) people wait you nearby")
                self.topTextView.showUpAnimation()
            })
        })
    }
    
    //位置情報をリアルタイムに取得する
    fileprivate func startUpdatingLocation() {
        self.mapView.startUpdatingLocation()
    }
}

extension MapViewController : DiscoverySettingViewControllerDelegate {
    func willDismissIfEdited() {
        self.circleRange()
    }
}

extension MapViewController : MapBottomViewDelegate {
    func onClickFinishButton() {
        self.showOKCancelPopup(NSLocalizedString("FinishConfirm", tableName: "MapStrings", comment: "")) {
            self.state = .initial
        }
    }
    
    func onTapUserIcon() {
        LogDebug("onTapUserIcon")
    }
    
    func onToggleShareLocation(on : Bool) {
        if on {
        self.showMessagePopup(NSLocalizedString("ShareLocationMessage", tableName: "MapStrings", comment: ""))
        }
    }
    
    func onClickChatButton() {
        let chatVC = ChatViewController()
        let nc = UINavigationController(rootViewController: chatVC)
        self.present(nc, animated: true)
    }
    
    func onClickSettingButton() {
        self.openDiscoverySettingPage()
    }
    
    func onClickButton() {
        //test by kitahara
        dispatch_after(5, block: {
            self.bottomView.buttonLoading(bool : false)
            self.state = .matched
        })
        let radius = Double(mapUseCase.getSyncDiscoveryDistance())
        self.mapView.startSearchingAnimation(radius : radius)
        
        //周りの人に通知を投げる
//        let coord = mapView.getUserLocation()
//        let user = firebaseUseCase.getCurrentUser()
//        if let uid = user.uid {
//            let location = LocationLog(coordinate: coord, id: uid)
//            self.matchUseCase.requestMatch(uid: uid, location: location) {response in
//                let result = response.result
//                if result == "success" {
//                    LogDebug("マッチしました！")
//                } else if result == "fail" {
//                    LogDebug("マッチしませんでした")
//                    self.bottomView.buttonLoading(bool : false)
//                } else {
//                    LogDebug("レスポンスの形がおかしい")
//                }
//
//            }
//        }
    }
}

extension MapViewController : MapViewDelegate {
    func canDrawPartnerLocation() -> Bool {
        switch(self.state) {
        case .initial:
            return false
        case .matched:
            return true
        }
    }
    
    func canDrawGatherHere() -> Bool {
        switch(self.state) {
        case .initial:
            return false
        case .matched:
            return true
        }
    }
    
    func canShowCircleAroundUser() -> Bool {
        switch(self.state) {
        case .initial:
            return true
        case .matched:
            return false
        }
    }
    
    func canOnLongTapMapView() -> Bool {
        switch self.state {
        case .initial:
            return false
        case .matched:
            return true
        }
    }
}
