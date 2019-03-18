//
//  MapModel.swift
//  MapDemoApp
//
//  Created by kitaharamugirou on 2019/03/11.
//  Copyright © 2019 kitaharamugirou. All rights reserved.
//

import Foundation
import MapKit
class MapModel {
    private var state : MapState = .initial
    private let mapView : MKMapView
    
    private var gatherHereAnnotation :MKPointAnnotation? = nil
    fileprivate var mapFireStore = MapFireStore()
    
    init(mapView : MKMapView , state : MapState) {
        self.state = state
        self.mapView = mapView
    }
    
    //経路の計算
    func showRoute(from : MKPlacemark, to : MKPlacemark) {
        // MKPlacemark から MKMapItem を生成
        let fromItem = MKMapItem(placemark:from)
        let toItem   = MKMapItem(placemark:to)
        
        // MKMapItem をセットして MKDirectionsRequest を生成
        let request = MKDirections.Request()
        
        request.source = fromItem
        request.destination = toItem
        request.requestsAlternateRoutes = false // 単独の経路を検索
        request.transportType = MKDirectionsTransportType.any
        
        let directions = MKDirections(request:request)
        directions.calculate(completionHandler:  { response,error in
            if let res = response {
                if (error != nil || res.routes.isEmpty) {
                    return
                }
                let route: MKRoute = res.routes[0] as MKRoute
                let overlay = route.polyline
                
                //全てのoverlayを消してから線を描画
                self.removeAllOverlays()
                self.mapView.addOverlay(overlay)
                // 現在地と目的地を含む表示範囲を設定する
                self.showTwoPointRegion(a: from.coordinate, b: to.coordinate)
            }
        })
    }
    
    //２点が表示される描画領域の計算
    func showTwoPointRegion(a:CLLocationCoordinate2D , b:CLLocationCoordinate2D)
    {
        // 現在地と目的地を含む矩形を計算
        let maxLat:Double = fmax(a.latitude,  b.latitude)
        let maxLon:Double = fmax(a.longitude, b.longitude)
        let minLat:Double = fmin(a.latitude,  b.latitude)
        let minLon:Double = fmin(a.longitude, b.longitude)
        
        // 地図表示するときの緯度、経度の幅を計算
        let mapMargin:Double = 1.5;  // 経路が入る幅(1.0)＋余白(0.5)
        let leastCoordSpan:Double = 0.005;    // 拡大表示したときの最大値
        let span_x:Double = fmax(leastCoordSpan, fabs(maxLat - minLat) * mapMargin);
        let span_y:Double = fmax(leastCoordSpan, fabs(maxLon - minLon) * mapMargin);
        
        let span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: span_x, longitudeDelta: span_y);
        
        // 現在地を目的地の中心を計算
        let center:CLLocationCoordinate2D = CLLocationCoordinate2DMake((maxLat + minLat) / 2, (maxLon + minLon) / 2);
        let region:MKCoordinateRegion = MKCoordinateRegion(center: center, span: span);
        
        self.mapView.setRegion(self.mapView.regionThatFits(region), animated:true);
    }
    
    //自分が中心の半径n[m]の丸を描画する
    func showCircleAroundUser(radius : Double) {
        let center = self.mapView.userLocation.coordinate
        let radius_distance = CLLocationDistance(exactly: radius)
        if let rad = radius_distance {
            let circle = MKCircle(center: center, radius: rad)
            self.mapView.addOverlay(circle)
        }
    }
    
    //自分が中心の半径n[m]の丸が見えるようにズームする
    func zoomCircleAroundUser(radius : Double ) {
        let mapMargin = 1.3
        let rad_degree = CLLocationDegrees(exactly: radius * mapMargin)
        let center = self.mapView.userLocation.coordinate
        if let rad = rad_degree {
            let region = MKCoordinateRegion(center: center, latitudinalMeters: 2*rad, longitudinalMeters: 2*rad)
            LogDebug(region.debugDescription)
            let fittedRegion = self.mapView.regionThatFits(region)
            self.mapView.setRegion(fittedRegion, animated: false)
        }
    }
    
    //アノテーションを加える
    func addAnnotation(center : CLLocationCoordinate2D , title : String) {
        let pointAno: MKPointAnnotation = MKPointAnnotation()
        pointAno.coordinate = center
        pointAno.title = title
        self.mapView.addAnnotation(pointAno)
        gatherHereAnnotation = pointAno
    }
    

    //古いannotationを消す
    func removeGatherHere() {
        if let anno = gatherHereAnnotation {
            mapView.removeAnnotation(anno)
        }
    }
    
    func removeAllOverlays() {
        self.mapView.removeOverlays(self.mapView.overlays)
    }
    
    func removeCustomAnnotation(id : String) {
        for annot in self.mapView.annotations {
            if let customAnno = annot as? CustomAnnotation {
                if customAnno.id == id {
                    self.mapView.removeAnnotation(customAnno)
                }
            }
        }
    }
    
    //他のユーザを表示する
    func showAnotherUserLocation(id : String , location : CLLocationCoordinate2D , image : UIImage?) {
        let customAnno = CustomAnnotation(coor: location , image : image , id : id)
        self.removeCustomAnnotation(id: id)
        self.mapView.addAnnotation(customAnno)
    }
    
    //自分の位置情報をfirestoreに送る
    func sendLocation(coordinate : CLLocationCoordinate2D) {
        //test by kitahara
        let transactionId = "test_transactionId"
        let user_location_id = "user_location_id"
        //let user_location_id = "partner_location_id"
        let log = LocationLog(coordinate: coordinate, id: user_location_id)
        mapFireStore.setLocation(transactionId: transactionId, location: log)
    }
    
    //相手の位置情報をfirestoreから受け取る
    func receivePartnerLocation(handler : @escaping (LocationLog) -> ()) {
        //test by kitahara
        let transactionId = "test_transactionId"
        let user_location_id = "partner_location_id"
        //let user_location_id = "user_location_id"
        
        mapFireStore.getLocation(transactionId: transactionId, location_id: user_location_id, handler: {log in
            handler(log)
        })
    }
    
    
}
