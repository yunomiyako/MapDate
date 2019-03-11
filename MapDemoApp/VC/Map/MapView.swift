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
    private var gatherHereAnnotation :MKPointAnnotation? = nil
    
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
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        self.addSubview(mapView)
        self.mapView.addSubview(trackingButton)
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
        view.userTrackingMode = MKUserTrackingMode.followWithHeading
        
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
        let y : CGFloat = 100
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
            //古いannotationを消す
            if let anno = gatherHereAnnotation {
                mapView.removeAnnotation(anno)
            }
        }
        // ロングタップ終了（手を離した）
        else if gestureRecognizer.state == .ended {
            let tapPoint = gestureRecognizer.location(in: mapView)
            let center = mapView.convert(tapPoint, toCoordinateFrom: mapView)
            
            let distance = MapUtils.calcDistance(mapView.userLocation.coordinate, center)
            print("distance : " + distance.description)
            addAnnotation(center: center)
            
        }
    }
    
    private func addAnnotation(center : CLLocationCoordinate2D) {
        let pointAno: MKPointAnnotation = MKPointAnnotation()
        pointAno.coordinate = center // 座標（CLLocationCoordinate2D）
        pointAno.title = "Gather Here"
        mapView.addAnnotation(pointAno)
        gatherHereAnnotation = pointAno
    }
    
    
    
    func zoomUpUserLocation() {
        // 縮尺を設定
        var region:MKCoordinateRegion = mapView.region
        region.span.latitudeDelta = 0.02
        region.span.longitudeDelta = 0.02
        mapView.setRegion(region,animated:true)
        
        LogDebug("zoomUp to " + region.center.latitude.description + " : " + region.center.longitude.description)
        
        // 現在位置表示の有効化
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
    }
    
    func getUserLocation() -> CLLocationCoordinate2D{
        return mapView.userLocation.coordinate
    }
    
    func pinLocation(peoples : [PeopleLocation]) {
        for people in peoples {
            let circle = MKCircle(center: people.getCLLocationCoordinate2D(), radius: 100)
            mapView.addOverlay(circle)
        }
    }
    
    func startUpdatingLocation() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager!.startUpdatingLocation()
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
