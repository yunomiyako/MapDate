//
//  MapView.swift
//  MapDemoApp
//
//  Created by kitaharamugirou on 2019/03/10.
//  Copyright © 2019 kitaharamugirou. All rights reserved.
//

import UIKit
import MapKit
class MapView: UIView {
    // MARK: - Properties -
    lazy private var mapView:MKMapView = self.createMapView()
    lazy private var trackingButton : MKUserTrackingButton = self.createTrackingButton()
    
    private var locationManager : CLLocationManager?
    private var mapModel : MapModel? = nil
    
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
        self.mapModel = MapModel(mapView: mapView, state: .initial)
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        self.addSubview(mapView)
        self.mapView.addSubview(trackingButton)
        
    }
    
    //自分の近くを円で描く
    func showCircleAroundUser(radius : Double) {
        self.mapModel?.showCircleAroundUser(radius: radius)
        //self.mapModel?.zoomCircleAroundUser(radius: radius)
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
        
        //タップリスナー
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapMapView) )
        view.addGestureRecognizer(tapGesture)
        
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
    @objc private func onTapMapView(gestureRecognizer: UITapGestureRecognizer) {
        // タップした位置（CGPoint）を指定してMkMapView上の緯度経度を取得する
        let tapPoint = gestureRecognizer.location(in: mapView)
        let center = mapView.convert(tapPoint, toCoordinateFrom: mapView)
    }
    
    @objc private func onLongTapMapView(gestureRecognizer: UILongPressGestureRecognizer) {
        // ロングタップ開始
        if gestureRecognizer.state == .began {
            self.mapModel?.removeGatherHere()
        }
        // ロングタップ終了（手を離した）
        else if gestureRecognizer.state == .ended {
            let tapPoint = gestureRecognizer.location(in: mapView)
            let center = mapView.convert(tapPoint, toCoordinateFrom: mapView)
            self.mapModel?.addAnnotation(center: center , title : "Gather Here")
            
            // 現在地と目的地のMKPlacemarkを生成
            let fromPlacemark = MKPlacemark(coordinate:mapView.userLocation.coordinate, addressDictionary:nil)
            let toPlacemark   = MKPlacemark(coordinate:center, addressDictionary:nil)
            showRoute(from: fromPlacemark, to: toPlacemark)
        }
    }
    

    /*from to のrouteを表示*/
    private func showRoute(from : MKPlacemark, to : MKPlacemark) {
        self.mapModel?.showRoute(from: from, to: to)
    }
    
    func getUserLocation() -> CLLocationCoordinate2D{
        return mapView.userLocation.coordinate
    }
    
    func startUpdatingLocation() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager!.startUpdatingLocation()
        }
    }
    
}

extension MapView : MKMapViewDelegate {
    //MARK:- MapKit delegates
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.mainBlue()
        renderer.lineWidth = 3.0
        return renderer
    }
}

extension MapView :CLLocationManagerDelegate {
    
    //authorization
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted, .denied:
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
    }
}
