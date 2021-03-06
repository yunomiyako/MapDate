//
//  MapView.swift
//  MapDemoApp
//
//  Created by kitaharamugirou on 2019/03/10.
//  Copyright © 2019 kitaharamugirou. All rights reserved.
//

import UIKit
import MapKit

protocol MapViewDelegate : class {
    func canShowCircleAroundUser() -> Bool
    func onLongTapMapView(gestureRecognizer: UILongPressGestureRecognizer)
    func canDrawGatherHere() -> Bool
    func canDrawPartnerLocation() -> Bool
    func isNear(near : Bool)
    func getMatchData() -> MatchDataModel?
    func getShareLocation() -> Bool
    
}

class MapView: UIView {
    // MARK: - Properties -
    lazy private var mapView:MKMapView = self.createMapView()
    lazy private var trackingButton : MKUserTrackingButton = self.createTrackingButton()
    
    private var locationManager : CLLocationManager?
    private var mapModel : MapModel? = nil
    private var locationExchange = LocationExchange()
    weak var delegate : MapViewDelegate? = nil
    

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
        LogDebug("MapView childInit")
        self.mapModel = MapModel(mapView: mapView)
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        
        self.addSubview(mapView)
        self.mapView.addSubview(trackingButton)
        
    }
    
    func matchUpdate(matchData : MatchDataModel) {
        self.locationExchange.receivePartnerLocation(matchData: matchData, handler: {log in
            LogDebug("receivePartnerLocation log come in")
            if self.delegate?.canDrawPartnerLocation() ?? false == false {return}
            let location = CLLocationCoordinate2D(latitude: log.latitude, longitude: log.longitude)
            self.showAnotherUserLocation(id: log.id , location: location)
            
            //近くにいるかを判定
            let isNear = self.mapModel?.isNear(x: location, y: self.getUserLocation()) ?? false
            self.delegate?.isNear(near : isNear)
        })
        
        self.locationExchange.receiveGatherHereLocation(matchData: matchData, handler : {log in
            if self.delegate?.canDrawGatherHere() ?? false == false {return}
            let location = CLLocationCoordinate2D(latitude: log.latitude, longitude: log.longitude)
            self.addAnnotation(center: location, title: "Gather Here")
        })
    }
    
    func addAnnotation(center : CLLocationCoordinate2D, title : String) {
        self.mapModel?.removeGatherHere()
        self.mapModel?.addAnnotation(center: center , title : title)
    }
    
    //自分の近くに円を描く。
    func showCircleAroundUser(radius : Double) {
        if self.delegate?.canShowCircleAroundUser() ?? false {
            self.mapModel?.removeCircleOverlay()
            self.mapModel?.showCircleAroundUser(radius: radius)
            self.mapModel?.zoomCircleAroundUser(radius: radius)
        }
    }
    
    //指定したロケーションに円を描く
    func showCircleAroundLocation(location : CLLocationCoordinate2D, radius : Double) {
        self.mapModel?.removeCircleOverlay()
        self.mapModel?.showCircleAroundLocation(location: location, radius: radius)
        self.mapModel?.zoomCircleAroundLocation(location: location, radius: radius)
    }
    
    //state変わった時に
    func removeAllOverlays() {
        self.mapModel?.removeAllOverlays()
    }
    
    func removeAllAnnotations() {
        self.mapModel?.removeAllAnnotations()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutMapView()
        self.layoutTrackingButton()
    }
    
    // MARK: - Create subviews -
    private func createMapView() -> MKMapView {
        let view = MKMapView()
        view.showsUserLocation = true
        view.mapType = MKMapType.standard
        view.isZoomEnabled = true
        view.isScrollEnabled = true
        view.showsCompass = false
        
        //set delegate to render views such as line
        view.delegate = self
        
        //タップリスナー　使ってない
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapMapView) )
//        view.addGestureRecognizer(tapGesture)
//
        //ロングタップリスナー
        let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(onLongTapMapView) )
        view.addGestureRecognizer(longTapGesture)
        return view
    }
    
    private func createTrackingButton() -> MKUserTrackingButton {
        let btn = MKUserTrackingButton(mapView: mapView)
        btn.setShadow()
        btn.backgroundColor = UIColor.white
        return btn
    }
    
    // MARK: - Layout subviews -
    private func layoutMapView() {
        mapView.frame = self.frame
    }
    
    private func layoutTrackingButton() {
        let x : CGFloat = mapView.frame.width - 50
        let y : CGFloat = 50
        trackingButton.setRound(cornerRadius: 5)
        trackingButton.frame = CGRect(x: x, y: y, width: 40, height: 40)
    }
    
    
    // MARK : Listener
    @objc private func onLongTapMapView(gestureRecognizer: UILongPressGestureRecognizer) {
        self.delegate?.onLongTapMapView(gestureRecognizer: gestureRecognizer)
    }
    
    func longTapGathereHereHandler(gestureRecognizer: UILongPressGestureRecognizer) {
        let matchData = self.delegate?.getMatchData()
        guard let m = matchData else {return}
        self.mapModel?.longTapGathereHereHandler(matchData: m, gestureRecognizer: gestureRecognizer)
    }
    
    func longTapChangeDiscoveryCenter(gestureRecognizer: UILongPressGestureRecognizer , endHandler : (CLLocationCoordinate2D) -> ()) {
        self.mapModel?.longTapChangeDiscoveryCenter(gestureRecognizer: gestureRecognizer , endHandler : endHandler)
    }
    
    //別のユーザを表示させる
    private func showAnotherUserLocation(id : String , location : CLLocationCoordinate2D) {
        //test by kitahara これいらなくなりそう
        let imageNamed = "image01.jpg"
        let image = UIImage(named: imageNamed )
        
        //idは再利用のために必要
        self.mapModel?.showAnotherUserLocation(id : id , location : location , image : image)
    }
    
    
    /*外に晒すfunction*/
    func getUserLocation() -> CLLocationCoordinate2D{
        return mapView.userLocation.coordinate
    }
    
    func startUpdatingLocation(on : Bool) {
        if CLLocationManager.locationServicesEnabled() && on {
            locationManager!.startUpdatingLocation()
        } else {
            locationManager!.stopUpdatingLocation()
        }
    }
    
    func removeCircleOverlay() {
        self.mapModel?.removeCircleOverlay()
    }
    
    func stopCircleAnimation() {
        self.mapModel?.stopCircleAnimation()
    }
    
    func startSearchingAnimation(location : CLLocationCoordinate2D , radius : Double) {
        self.mapModel?.startCircleAnimation(location : location , radius: radius)
    }
    
}

extension MapView : MKMapViewDelegate {
    //MARK:- MapKit delegates
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let circle = overlay as? CustomMKCircle {
            //円の時
            let renderer = MKCircleRenderer(overlay: overlay)
            renderer.fillColor = circle.fillColor
            renderer.strokeColor = UIColor.mainRed()
            renderer.alpha = CGFloat(circle.alpha)
            renderer.lineWidth = 1
            return renderer
            
        } else if (overlay.isKind(of: MKPolyline.self)) {
            //線の時
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.mainBlue()
            renderer.lineWidth = 3.0
            return renderer
        } else {
            let renderer = MKOverlayRenderer(overlay: overlay)
            return renderer
        }
    }
    
    //カスタムアノテーション
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        if let annot = annotation as? CustomAnnotation {
            let dequeView = mapView.dequeueReusableAnnotationView(withIdentifier: annot.id)
            if dequeView == nil {
                //TODO : ここが呼ばれ続けている？
                LogDebug("dequeView was not prepared")
                let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annot.id)
                annotationView.image = annot.image?.resize(size: CGSize(width: 45, height: 45))
                annotationView.layer.cornerRadius = annotationView.frame.size.height/2
                annotationView.layer.masksToBounds = true
                annotationView.layer.borderColor = UIColor.white.cgColor
                annotationView.layer.borderWidth = 5
                annotationView.setShadow()
                mapView.register(MKAnnotationView.self , forAnnotationViewWithReuseIdentifier: annot.id)
                return annotationView
            }
            return dequeView
        } else {
            //それ以外はデフォルトを使用する
            return nil
        }
    }
}

extension MapView :CLLocationManagerDelegate {
    
    //authorization
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            //ここの処理かく
            break
        case .authorizedAlways, .authorizedWhenInUse:
            break
        }
    }
    
    //ユーザの座標が更新されるたびに呼ばれる
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else {
            return
        }
        let matchData = self.delegate?.getMatchData()
        guard let shareLocation = self.delegate?.getShareLocation() else {return}
        guard let m = matchData else {return}
        self.locationExchange.sendLocation(matchData: m, coordinate: newLocation.coordinate , shareLocation : shareLocation)
    }
}
