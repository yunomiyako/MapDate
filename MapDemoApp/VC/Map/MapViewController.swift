//
//  MapViewController.swift
//  MapDemoApp
//
//  Created by kitaharamugirou on 2019/03/10.
//  Copyright © 2019 kitaharamugirou. All rights reserved.
//

import UIKit
import Cartography
import MapKit
import SwiftIcons

class MapViewController: UIViewController , PopUpShowable {

    // MARK: - Properties -
    lazy private var mapView:MapView = {
        let view = MapView()
        view.delegate = self
        return view;
    }()
    
    lazy private var bottomView : MapBottomView = {
        let view = MapBottomView()
        view.delegate = self
        return view
    }()
    
    lazy private var bottomWhenMatchView : MapBottomWhenMatchedView = {
        let view = MapBottomWhenMatchedView()
        view.delegate = self
        view.setTopShadow()
        return view
    }()
    
    lazy private var searchBarView : MapSearchBarView = {
        let view = MapSearchBarView()
        return view
    }()
    
    private var modalPresentationController : CustomPresentationController? = nil
    
    private let mapUseCase = MapUseCase()
    private let matchUseCase = MatchUseCase()
    private let firebaseUseCase = FirebaseUseCase()
    
    private var discoveryRadius : Double = 3000
    private var discoveryCenter : CLLocationCoordinate2D? = nil
    
    private var didConfirmShareLocation = false
    
    //test by kitahara
    private var stateToBottom : [MapState : UIView]  = [:]
    private var state : MapState = .initial  {
        willSet {
            
            if newValue == .initial {
                self.circleRange()
            }
            
            //FIXME : もっと綺麗に書けそう
            let bottomPoint =  CGPoint(x: 0, y: self.view.frame.height)
            if let fromVC = self.stateToBottom[state] , let toVC = self.stateToBottom[newValue] {
                AnimationUtils.transitionTwoViewAppearance(fromView: fromVC, toView: toVC, whereGo: bottomPoint, afterLayout: {
                    self.switchBottomViewLayout()
                })
            }
            
//            if state == .initial && newValue == .matched {
//                let bottomPoint =  CGPoint(x: 0, y: self.view.frame.height)
//                AnimationUtils.transitionTwoViewAppearance(fromView: self.bottomView, toView: self.bottomWhenMatchView, whereGo: bottomPoint, afterLayout: {
//                    self.switchBottomViewLayout()
//                })
//            } else if state == .matched && newValue == .initial {
//                let bottomPoint =  CGPoint(x: 0, y: self.view.frame.height)
//                AnimationUtils.transitionTwoViewAppearance(fromView: self.bottomWhenMatchView, toView: self.bottomView, whereGo: bottomPoint, afterLayout: {
//                    self.switchBottomViewLayout()
//                })
//            }
        }
        didSet {
            if oldValue == .initial {
                self.mapView.stopCircleAnimation()
                self.mapView.removeCircleOverlay()
            }
        }
    }
    
    var goProf = UIBarButtonItem()
    let navBar = UINavigationBar()
    let navItem = UINavigationItem(title: "Map")
    let navigationView = UIView()
    let baceView = UIView()
    
    // MARK: - Life cycle events -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(baceView)
        self.baceView.addSubview(mapView)
        self.view.addSubview(bottomView)
        self.view.addSubview(bottomWhenMatchView)
        //self.baceView.addSubview(searchBarView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //起動時にだけ発動させたいから、もう少しいい実装
        if self.state == .initial {
            circleRange()
        }
        
        stateToBottom = [
            .initial : bottomView ,
            .matched : bottomWhenMatchView ,
            .rating : UIView()
        ]
        
        //test by kitahara
        self.startUpdatingLocation()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.layoutMapView()
        self.switchBottomViewLayout()
        self.layoutSearchBarView()
        addNavBackView()
        addNavigationBar()
        self.layoutBaceView()
    }
    

    //遷移先Viewから戻る処理
    @objc func returnView(){
        self.dismiss(animated: true, completion: nil)
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
    func layoutBaceView(){
        baceView.frame = self.view.frame
        baceView.frame.origin.y = navBar.frame.maxY
        self.view.backgroundColor = UIColor.white
    }
    
    
    @objc func goToProfile(sender: AnyObject){
        let vc = MyProfileViewController()
        self.present(vc, animated: true)
    }
    
    func addNavBackView(){
        
        self.view.addSubview(navigationView)
        navigationView.backgroundColor = UIColor.white
        //navigationBarの背景のサイズと位置を調整
        if #available(iOS 11.0, *) {
            navigationView.frame.origin = self.view.safeAreaLayoutGuide.owningView!.frame.origin
            navigationView.frame.size = CGSize(width: self.view.safeAreaLayoutGuide.owningView!.frame.width, height: navBar.frame.origin.y + navBar.frame.height)
        }else{
            navigationView.frame.origin = self.view.frame.origin
            navigationView.frame.size = CGSize(width: self.view.frame.width, height: navBar.frame.origin.y + navBar.frame.height)
        }
    }
    
    func addNavigationBar(){
        
        self.view.addSubview(navBar)
        //navigationBarの色を透明にする
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.shadowImage = UIImage()
        //        navItem.rightBarButtonItem = UIBarButtonItem(
        //            barButtonSystemItem: .done,
        //            target: self,
        //            action: #selector(returnView))
        navItem.hidesBackButton = true
        goProf.setIcon(icon: .ionicons(.iosContact), iconSize: 30, color: .orange, cgRect: CGRect(x: 0, y: 0, width: 30, height: 30), target: self, action: #selector(goToProfile(sender:)))
        navItem.leftBarButtonItem = goProf
        
        
        navBar.pushItem(navItem, animated: true)
        //navigationBarのサイズと位置を調整
        if #available(iOS 11.0, *) {
            //iOS11よりも上だったら(iPhoneXだろうがiPhone8だろうがiOSが11より上ならこっちでまとめて対応できる)
            navBar.frame.origin = self.view.safeAreaLayoutGuide.layoutFrame.origin
            navBar.frame.size = CGSize(width: self.view.safeAreaLayoutGuide.layoutFrame.width, height: 44)
        }else{
            //もしもiOS11よりも下だったら
            navBar.frame.origin = self.view.frame.origin
            navBar.frame.size = CGSize(width: self.view.frame.width, height: 44)
        }
    }

    // MARK: - Layout subviews -
    private func layoutMapView() {
        mapView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
    }
    
    private func layoutBottomView() {
        let height : CGFloat = 100
        let y = self.view.frame.height
        bottomView.frame = CGRect(x: 0, y: y - height, width: self.view.frame.width, height: height)
    }
    
    private func layoutBottomWhenMatchView() {
        let height : CGFloat = 270
        let y = self.view.frame.height
        bottomWhenMatchView.frame = CGRect(x: 0, y: y - height, width: self.view.frame.width, height: height)
    }
    
    private func layoutSearchBarView() {
        let x : CGFloat = 20
        let y : CGFloat = 50
        let width = self.view.frame.width - 90
        let height : CGFloat = 40
        searchBarView.frame = CGRect(x: x, y: y, width: width, height: height)
        searchBarView.setSize(width: width, height: height)
    }

    
    private func openDiscoverySettingPage() {
        let vc = DiscoverySettingViewController()
        vc.delegate = self
        let nc = UINavigationController(rootViewController: vc)
        self.present(nc, animated: true, completion: nil)
    }
    
    fileprivate func circleRange() {
        //radiusを設定から取得して、自分か指定したローケーションを中心に円を描く
        let centerLocation = self.discoveryCenter ?? self.mapView.getUserLocation()
        let radius = Double(mapUseCase.getSyncDiscoveryDistance())
        self.mapView.showCircleAroundLocation(location: centerLocation, radius: radius)
        
        self.mapUseCase.getNearPeopleNumber(location: centerLocation, radius: radius, completion: { number in
            LogDebug("getNearPeopleNumber = \(number)")
        })
        
        if let pinnedLocation = self.discoveryCenter  {
            self.mapView.addAnnotation(center: pinnedLocation, title: "")
        }
    }
    
    //位置情報をリアルタイムに取得する
    fileprivate func startUpdatingLocation() {
        self.mapView.startUpdatingLocation()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        LogDebug("touchesBegan")
        self.view.endEditing(true)
    }
}

extension MapViewController : DiscoverySettingViewControllerDelegate {
    func willDismissIfEdited() {
        self.circleRange()
    }
}

extension MapViewController : MapBottomViewDelegate {
    func onClickSafelyMetButton() {
        //pop up something
        self.state = .rating
        
        let vc = RateUserViewController()
        vc.delegate = self
        self.modalPresentationController = CustomPresentationController(presentedViewController: vc, presenting: self)
        self.modalPresentationController?.isDismissable = false
        //FIXME: マジックナンバーすぎる　レイアウトが変わった時に対応できない
        self.modalPresentationController?.contentHeight = 550
        PopupUtils.showModalPopup(presentingVC: self, presentedVC: vc, delegate: self)
        
        vc.addButtonClickListener(handler: {
            self.modalPresentationController?.contentHeight = 650
        })
    }
    
    
    func onClickFinishButton() {
        self.showOKCancelPopup(NSLocalizedString("FinishConfirm", tableName: "MapStrings", comment: "")) {
            self.state = .initial
        }
    }
    
    func onTapUserIcon() {
        LogDebug("onTapUserIcon")
    }
    
    func onToggleShareLocation(on : Bool) {
        if on && !didConfirmShareLocation {
            self.bottomWhenMatchView.toggleShareLocation(on : false)
            self.showOKCancelPopup(NSLocalizedString("ShareLocationMessage", tableName: "MapStrings", comment: ""), completionHandler: {
                self.bottomWhenMatchView.toggleShareLocation(on:true)
                self.didConfirmShareLocation = true
            })
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
        dispatch_after(1, block: {
            self.bottomView.buttonLoading(bool : false)
            self.state = .matched
            let vc = MatchPopupViewController()
            vc.setButtonListener(handler : {
                self.onClickChatButton()
            })
            self.modalPresentationController = CustomPresentationController(presentedViewController: vc, presenting: self)
            self.modalPresentationController?.isDismissable = true
            self.modalPresentationController?.contentHeight = 700
            PopupUtils.showModalPopup(presentingVC: self, presentedVC: vc, delegate: self)
        })
        let centerLocation = self.discoveryCenter ?? self.mapView.getUserLocation()
        let radius = Double(mapUseCase.getSyncDiscoveryDistance())
        self.mapView.startSearchingAnimation(location : centerLocation , radius : radius)
        
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
    func isNear(near: Bool) {
        if near {
            self.bottomWhenMatchView.setButtonDisable(disable: false)
        } else {
            self.bottomWhenMatchView.setButtonDisable(disable: true)
        }
    }
    
    func canDrawPartnerLocation() -> Bool {
        switch(self.state) {
        case .initial:
            return false
        case .matched:
            return true
        case .rating:
            return false
        }
    }
    
    func canDrawGatherHere() -> Bool {
        switch(self.state) {
        case .initial:
            return false
        case .matched:
            return true
        case .rating:
            return false
        }
    }
    
    func canShowCircleAroundUser() -> Bool {
        switch(self.state) {
        case .initial:
            return true
        case .matched:
            return false
        case .rating:
            return false
        }
    }
    
    func onLongTapMapView(gestureRecognizer: UILongPressGestureRecognizer) {
        switch self.state {
        case .initial:
            self.mapView.longTapChangeDiscoveryCenter(gestureRecognizer: gestureRecognizer) {location in
                self.discoveryCenter = location
                self.circleRange()
            }
        case .matched:
            self.mapView.longTapGathereHereHandler(gestureRecognizer: gestureRecognizer)
        case .rating:
            break
        }
    }
}

// modalViewController.modalPresentationStyle = .custom
// でカスタムとしたので、こちらで設定するように呼び出す。
extension MapViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return modalPresentationController
    }
}

extension MapViewController : RateuserViewControllerDelegate {
    func onClickRateOk(rate: Double) {
        LogDebug("rate : \(rate)")
        self.state = .initial
    }
}
