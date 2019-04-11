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
    private var matchModel = MatchModel()
    
    
    // MARK: - Life cycle events -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(mapView)
        self.view.addSubview(bottomView)
        self.view.addSubview(bottomWhenMatchView)
        //self.view.addSubview(searchBarView)
        
        matchModel.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //起動時にだけ発動させたいから、もう少しいい実装
        if matchModel.state == .initial {
            circleRange()
        }
        
        matchModel.stateToBottom = [
            .initial : bottomView ,
            .matched : bottomWhenMatchView ,
            .rating : UIView()
        ]
        
        //test by kitahara 適切なタイミングに変更
        self.startUpdatingLocation()
        
        //マッチング中のマッチを探す
        self.matchUseCase.restoreMatch(completion: { response in
            self.finishLoadMatch(response: response)
        })
    }
    
    
    fileprivate func finishLoadMatch(response : RequestMatchResponse) {
        let result = response.result
        if result == "success" {
            LogDebug("\(response.partner_location_id)とマッチしました")
            self.onMatch()
        } else if result == "fail" {
            LogDebug("マッチしませんでした")
            self.bottomView.buttonLoading(bool : false)
        } else {
            LogDebug("レスポンスの形がおかしい")
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.layoutMapView()
        self.switchBottomViewLayout()
        self.layoutSearchBarView()
    }
    
    private func switchBottomViewLayout() {
        if matchModel.state == .initial {
            self.layoutBottomView()
        } else {
            bottomView.isHidden = true
        }
        
        if matchModel.state == .matched {
            self.layoutBottomWhenMatchView()
        } else {
            bottomWhenMatchView.isHidden = true
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
        let centerLocation = matchModel.discoveryCenter ?? self.mapView.getUserLocation()
        let radius = Double(mapUseCase.getSyncDiscoveryDistance())
        self.mapView.showCircleAroundLocation(location: centerLocation, radius: radius)
        
        self.mapUseCase.getNearPeopleNumber(location: centerLocation, radius: radius, completion: { number in
            LogDebug("getNearPeopleNumber = \(number)")
        })
        
        if let pinnedLocation = matchModel.discoveryCenter  {
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
        matchModel.state = .rating
        
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
            self.matchModel.state = .initial
        }
    }
    
    func onTapUserIcon() {
        LogDebug("onTapUserIcon")
    }
    
    func onToggleShareLocation(on : Bool) {
        if on && !matchModel.didConfirmShareLocation {
            self.bottomWhenMatchView.toggleShareLocation(on : false)
            self.showOKCancelPopup(NSLocalizedString("ShareLocationMessage", tableName: "MapStrings", comment: ""), completionHandler: {
                self.bottomWhenMatchView.toggleShareLocation(on:true)
                self.matchModel.didConfirmShareLocation = true
            })
        }
    }
    
    func onClickChatButton() {
        let chatVC = ChatViewController()
        chatVC.delegate = self
        let nc = UINavigationController(rootViewController: chatVC)
        self.present(nc, animated: true) {
            guard let m = self.matchModel.matchData else {return}
            chatVC.startLoadingChatMessage(matchData: m)
        }
    }
    
    func onClickSettingButton() {
        //test by kitahara マッチの受け取りを適当にここでやってる
        let coord = self.mapView.getUserLocation()
        let location = LocationLog(coordinate: coord, id: "")
        matchUseCase.findRequestMatch(location: location, completion: {res in
            let partner_location_id = res.partner_location_ids[0]
            self.matchUseCase.receiveMatch(partner_location_id: partner_location_id, completion: {res in
                //ここ順番大事
                self.matchModel.matching(transaction_id: res.transaction_id, your_location_id: res.your_location_id, partner_location_id: res.partner_location_id)
                self.matchModel.state = .matched
            })
        })
        
        self.openDiscoverySettingPage()
    }
    
    private func onMatch() {
        self.bottomView.buttonLoading(bool : false)
        matchModel.state = .matched
        let vc = MatchPopupViewController()
        vc.setButtonListener(handler : {
            self.onClickChatButton()
        })
        self.modalPresentationController = CustomPresentationController(presentedViewController: vc, presenting: self)
        self.modalPresentationController?.isDismissable = true
        self.modalPresentationController?.contentHeight = 700
        PopupUtils.showModalPopup(presentingVC: self, presentedVC: vc, delegate: self)
    
    }
    
    func onClickButton() {
        let centerLocation = matchModel.discoveryCenter ?? self.mapView.getUserLocation()
        let radius = Double(mapUseCase.getSyncDiscoveryDistance())
        self.mapView.startSearchingAnimation(location : centerLocation , radius : radius)
        
        //周りの人に通知を投げる
        let location = LocationLog(coordinate: centerLocation, id: "")
        self.matchUseCase.requestMatch(location: location) {response in
            self.finishLoadMatch(response : response)
        }
    }
}

extension MapViewController : MapViewDelegate , ChatViewControllerDelegate {
    func getMatchData() -> MatchDataModel? {
        return self.matchModel.matchData
    }
    
    func isNear(near: Bool) {
        if near {
            self.bottomWhenMatchView.setButtonDisable(disable: false)
        } else {
            self.bottomWhenMatchView.setButtonDisable(disable: true)
        }
    }
    
    func canDrawPartnerLocation() -> Bool {
        switch(matchModel.state) {
        case .initial:
            return false
        case .matched:
            return true
        case .rating:
            return false
        }
    }
    
    func canDrawGatherHere() -> Bool {
        switch(matchModel.state) {
        case .initial:
            return false
        case .matched:
            return true
        case .rating:
            return false
        }
    }
    
    func canShowCircleAroundUser() -> Bool {
        switch(matchModel.state) {
        case .initial:
            return true
        case .matched:
            return false
        case .rating:
            return false
        }
    }
    
    func onLongTapMapView(gestureRecognizer: UILongPressGestureRecognizer) {
        switch matchModel.state {
        case .initial:
            self.mapView.longTapChangeDiscoveryCenter(gestureRecognizer: gestureRecognizer) {location in
                matchModel.discoveryCenter = location
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
        matchModel.state = .initial
    }
}

extension MapViewController : MatchModelDelegate {
    func whenStateWillChange(newValue: MapState, value: MapState) {
        if newValue == .initial {
            self.circleRange()
        }
        
        let bottomPoint =  CGPoint(x: 0, y: self.view.frame.height)
        if let fromVC = matchModel.stateToBottom[matchModel.state] , let toVC = matchModel.stateToBottom[newValue] {
            AnimationUtils.transitionTwoViewAppearance(fromView: fromVC, toView: toVC, whereGo: bottomPoint, afterLayout: {
                self.switchBottomViewLayout()
            })
        }
    
    }
    
    func whenStateDidChange(oldValue: MapState, value: MapState) {
        if oldValue == .initial {
            self.mapView.stopCircleAnimation()
            self.mapView.removeCircleOverlay()
        }
        
        if value == .matched {
            let matchData = self.matchModel.matchData
            guard let m = matchData else {
                LogDebug("matte matchDataがない")
                return
            }
            self.mapView.matchUpdate(matchData: m)
        }
    }
}
