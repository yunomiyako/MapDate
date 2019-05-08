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
    private var matchModel : MatchModel = MatchModel(state: .initial)
    
    
    init?(matchModel : MatchModel) {
        super.init(nibName: nil, bundle: nil)
        matchModel.delegate = self
        self.matchModel = matchModel
        self.matchModel.loadMatchData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    }
    
    
    fileprivate func finishLoadMatch(response : RequestMatchResponse) {
        let result = response.result
        if result == "success" {
            LogDebug("マッチしました")
            self.onMatch(response : response)
        } else if result == "fail" {
            LogDebug("マッチしませんでした")
            self.mapView.stopCircleAnimation()
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
        addNavBackView()
        addNavigationBar()
        self.layoutBaceView()
    }
    

    //遷移先Viewから戻る処理
    @objc func returnView(){
        self.dismiss(animated: true, completion: nil)
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
    
    private func receiveMatch(partner_location_id : String) {
        self.matchModel.receiveMatch(partner_location_id: partner_location_id)
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
        
        if let pinnedLocation = matchModel.discoveryCenter  {
            self.mapView.addAnnotation(center: pinnedLocation, title: "")
        }
    }
    
    //位置情報をリアルタイムに取得する
    fileprivate func startUpdatingLocation(on : Bool) {
        self.mapView.startUpdatingLocation(on : on)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    
    fileprivate func popUpNotificationViews(users : [MatchRequestUserModel]) {
        //test by kitahara
        if users.count > 0 {
        }
    }
    


}

extension MapViewController : DiscoverySettingViewControllerDelegate {
    func willDismissIfEdited() {
        self.circleRange()
    }
}

extension MapViewController : MapBottomViewDelegate {
    func onClickSafelyMetButton() {
        matchModel.meet()
        matchModel.state = .rating
    }
    
    
    func onClickFinishButton() {
        self.showOKCancelPopup(NSLocalizedString("FinishConfirm", tableName: "MapStrings", comment: "")) {
            self.matchModel.quitRelationship()
        }
    }
    
    func onTapUserIcon() {
        LogDebug("onTapUserIcon")
    }
    
    func onToggleShareLocation(on : Bool) {
        if on && !matchModel.didConfirmShareLocation {
            self.bottomWhenMatchView.toggleShareLocation(on : false)
            self.showOKCancelPopup(NSLocalizedString("ShareLocationMessage", tableName: "MapStrings", comment: ""), completionHandler: {
                self.startUpdatingLocation(on: true)
                self.matchModel.didConfirmShareLocation = true
                self.matchModel.shareLocation = true
                self.bottomWhenMatchView.toggleShareLocation(on:true)
            })
        } else {
            self.matchModel.shareLocation = on
            self.startUpdatingLocation(on: on)
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
        self.openDiscoverySettingPage()
    }
    
    private func onMatch(response : RequestMatchResponse ) {
        self.mapView.stopCircleAnimation()
        self.bottomView.buttonLoading(bool : false)
        matchModel.matching(transaction_id: response.transaction_id, your_location_id: response.your_location_id, partner_location_id: response.partner_location_id)
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
    
    func getShareLocation() -> Bool {
        return self.matchModel.shareLocation
    }
    
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
        matchModel.rateMatch(rate : rate)
    }
}

extension MapViewController : MatchModelDelegate {
    func foundRequestMatch(foundUsers: [MatchRequestUserModel]) {
        //test by kitahara 本来は通知ビューを表示
        if foundUsers.count > 0 {
            self.popUpNotificationViews(users : foundUsers)
            //self.receiveMatch(partner_location_id: foundUsers[0].partner_location_id)
        }
    }
    
    func getNowUserLocation() -> LocationLog {
        let coord = self.mapView.getUserLocation()
        return LocationLog(coordinate: coord, id: "") //test by kitahara : ここid必要？
    }

    func whenStateWillChange(newValue: MatchState, value: MatchState) {
        if newValue == .initial {
            self.circleRange()
        }
        
        if newValue == .rating {
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
        
        let bottomPoint =  CGPoint(x: 0, y: self.view.frame.height)
        if let fromVC = matchModel.stateToBottom[value] , let toVC = matchModel.stateToBottom[newValue] {
            AnimationUtils.transitionTwoViewAppearance(fromView: fromVC, toView: toVC, whereGo: bottomPoint, afterLayout: {
                self.switchBottomViewLayout()
            })
        }
    
    }
    
    func whenStateDidChange(oldValue: MatchState, value: MatchState) {
        LogDebug("state did changed from \(oldValue) to \(value)")
        if oldValue == .initial {
            self.mapView.stopCircleAnimation()
            self.mapView.removeCircleOverlay()
        }
        
        if oldValue != .initial && value == .initial {
            self.mapView.removeAllAnnotations()
        }
        
        if value == .matched {
            self.bottomWhenMatchView.toggleShareLocation(on: self.matchModel.shareLocation)
            let matchData = self.matchModel.matchData
            guard let m = matchData else {
                LogDebug("matte matchDataがない")
                return
            }
            self.mapView.matchUpdate(matchData: m)
        }
    }
}
