//
//  MapViewController.swift
//  MapDemoApp
//
//  Created by kitaharamugirou on 2019/03/10.
//  Copyright © 2019 kitaharamugirou. All rights reserved.
//

import UIKit
import Cartography

class MapViewController: UIViewController {

    // MARK: - Properties -
    lazy private var mapView:MapView = self.createMapView()
    lazy private var bottomView : MapBottomView = self.createBottomView()
    lazy private var bottomWhenMatchView : MapBottomWhenMatchedView = self.createBottomWhenMatchView()
    lazy private var topTextView : FloatingRectangleView = self.createTopTextView()
    
    private let mapUseCase = MapUseCase()
    private let matchUseCase = MatchUseCase()
    private let firebaseUseCase = FirebaseUseCase()
    
    private var radius : Float = 3000
    
    //test by kitahara
    private var state : MapState = .chatting
    
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
        
        if self.state == .initial {
            self.layoutBottomView()
        } else {
            bottomView.isHidden = true
        }
        
        if self.state == .chatting {
            self.layoutBottomWhenMatchView()
        } else {
            bottomWhenMatchView.isHidden = true
        }
        
        self.layoutTopTextView()
    
    }
    
    // MARK: - Create subviews -
    private func createMapView() -> MapView {
        let rect = MapView()
        return rect;
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
        let height : CGFloat = 200
        let y = self.view.frame.height
        bottomWhenMatchView.frame = CGRect(x: 0, y: y - height, width: self.view.frame.width, height: height)
    }


    
    private func layoutTopTextView() {
        let height : CGFloat = 120
        topTextView.frame = CGRect(x: 0, y: 50 , width: self.view.frame.width, height: height)
    }

    private func changedCircleRange(radius : Double) {
        //初期読み込み時はuserLocationはまともにとれないのでは？
        let userLocation = self.mapView.getUserLocation()
        self.mapView.showCircleAroundUser(radius : radius)
        self.mapUseCase.getNearPeopleNumber(location: userLocation, radius: radius, completion: { number in
            dispatch_after(1, block: {
                self.topTextView.setText(text: "\(number) people wait you nearby")
                self.topTextView.showUpAnimation()
            })
        })
    }
    
    private func openDiscoverySettingPage() {
        let vc = DiscoverySettingViewController()
        vc.delegate = self
        let nc = UINavigationController(rootViewController: vc)
        self.present(nc, animated: true, completion: nil)
    }
    
    fileprivate func circleRange() {
        //radiusを設定からとってきている
        let radius = mapUseCase.getSyncDiscoveryDistance()
        self.changedCircleRange(radius : Double( radius ))
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
    func onClickChatButton() {
        //test by kitahara
        let chatVC = ChatViewController()
        let nc = UINavigationController(rootViewController: chatVC)
        self.present(nc, animated: true)
        //self.navigationController?.pushViewController(chatVC, animated: true)
    }
    
    func onClickSettingButton() {
        self.openDiscoverySettingPage()
    }
    
    func onClickButton() {
        //周りの人に通知を投げる
        let coord = mapView.getUserLocation()
        let user = firebaseUseCase.getCurrentUser()
        if let uid = user.uid {
            let location = LocationLog(coordinate: coord, id: uid)
            self.matchUseCase.requestMatch(uid: uid, location: location) {response in
                let result = response.result
                if result == "success" {
                    LogDebug("マッチしました！")
                } else if result == "fail" {
                    LogDebug("マッチしませんでした")
                    self.bottomView.buttonLoading(bool : false)
                } else {
                    LogDebug("レスポンスの形がおかしい")
                }
                
            }
        }
    }
}
