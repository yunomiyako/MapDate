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
    fileprivate var mapFireStore = MapFireStore()
    
    //test by kitahara
    fileprivate var transactionId = "test_transactionId"
    fileprivate var user_id = "test_user_id"
    
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
        self.mapModel = MapModel(mapView: mapView, state: .initial)
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        self.addSubview(mapView)
        self.mapView.addSubview(trackingButton)
    }
    
    //自分の近くを円で描く
    func showCircleAroundUser(radius : Double) {
        LogDebug("showCircleAroundUser")
        self.mapModel?.removeAllOverlays()
        self.mapModel?.showCircleAroundUser(radius: radius)
        self.mapModel?.zoomCircleAroundUser(radius: radius)
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
            
            //test by kitahara
            self.showAnotherUserLocation(id : "test user" , location : center)
        }
    }
    
    //別のユーザを表示させる
    private func showAnotherUserLocation(id : String , location : CLLocationCoordinate2D) {
        let imageNamed = "image01.jpg"
        let image = UIImage(named: imageNamed )
        self.mapModel?.showAnotherUserLocation(id : id , location : location , image : image)
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
        if(overlay.isKind(of: MKCircle.self)) {
            //円の時
            let renderer = MKCircleRenderer(overlay: overlay)
            renderer.fillColor = UIColor.mainGreen()
            renderer.strokeColor = UIColor.black
            renderer.alpha = 0.2
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
            break
        case .authorizedAlways, .authorizedWhenInUse:
            break
        }
    }
    
    //ユーザの座標が更新されるたびに呼ばれる
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        LogDebug("locationManager")
        guard let newLocation = locations.last else {
            return
        }
        
        let log = LocationLog(location: newLocation.coordinate, id: self.user_id)
        self.mapFireStore.setLocation(transactionId: self.transactionId, location: log)
    }
}
