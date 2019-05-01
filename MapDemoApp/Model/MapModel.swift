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
    private let mapView : MKMapView
    private var gatherHereAnnotation : MKPointAnnotation? = nil
    private var circleOverlay : CustomMKCircle? = nil
    private var timer : Timer? = nil
    
    //test by kitahara あとで別のファイルに移す？
    private let NEAR_METER : Double = 300
    
    init(mapView : MKMapView ) {
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
    func showCircleAroundUser(radius : Double , alpha : Float = 1 , fillColor : UIColor? = nil) {
        let center = self.mapView.userLocation.coordinate
        self.showCircleAroundLocation(location: center, radius: radius, alpha: alpha, fillColor: fillColor)
    }
    
    //ロケーションを指定してその中心半径n[m]の丸を描画する
    func showCircleAroundLocation(location : CLLocationCoordinate2D , radius : Double , alpha : Float = 1 , fillColor : UIColor? = nil) {
        let center = location
        let radius_distance = CLLocationDistance(exactly: radius)
        if let rad = radius_distance {
            let circle = CustomMKCircle(center: center, radius: rad)
            circle.alpha = alpha
            circle.fillColor = fillColor == nil ? UIColor.clear : fillColor!
            self.circleOverlay = circle
            self.mapView.addOverlay(circle)
        }
    }
    
    //自分が中心の半径n[m]の丸が見えるようにズームする
    func zoomCircleAroundUser(radius : Double ) {
        let center = self.mapView.userLocation.coordinate
        self.zoomCircleAroundLocation(location: center, radius: radius)
    }
    
    //指定したロケーションの半径n[m]の丸が見えるようにズームする
    func zoomCircleAroundLocation(location : CLLocationCoordinate2D , radius : Double ) {
        let center = location
        let mapMargin = 1.3
        let rad_degree = CLLocationDegrees(exactly: radius * mapMargin)
        if let rad = rad_degree {
            let region = MKCoordinateRegion(center: center, latitudinalMeters: 2*rad, longitudinalMeters: 2*rad)
            LogDebug(region.debugDescription)
            let fittedRegion = self.mapView.regionThatFits(region)
            self.mapView.setRegion(fittedRegion, animated: true)
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
    
    func removeCircleOverlay() {
        if let overlay = circleOverlay {
            mapView.removeOverlay(overlay)
        }
    }
    
    func removeAllAnnotations() {
        self.mapView.removeAnnotations(self.mapView.annotations)
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

    //円をtimerでアニメートする
    func startCircleAnimation(location : CLLocationCoordinate2D , radius : Double) {
        if self.timer != nil {
            self.timer?.invalidate()
            self.timer = nil
        }
        
        let duration : Float = 2
        let frameRate : Int = 100
        let timeInterval = TimeInterval(duration / Float(frameRate) )
        
        var radius_array : [Double] = []
        for i in 0...frameRate {
            radius_array.append( radius * Double(i) /  Double(frameRate)  )
        }
        
        var counter = 0
        let timer  = Timer(timeInterval: timeInterval, repeats: true, block: {_ in
            if counter >= radius_array.count {
                counter = 0
            } else {
                let r = radius_array[counter]
                self.removeCircleOverlay()
                self.showCircleAroundLocation(location: location , radius: r , alpha :  0.6 * (1.0 - Float(counter) / Float(frameRate))  , fillColor : UIColor.mainRed() )
            }
            counter += 1
        })
        RunLoop.main.add(timer, forMode:RunLoop.Mode.common)
        self.timer = timer
    }
    
    func stopCircleAnimation() {
        self.timer?.invalidate()
    }
    
    //ロングタップした時にGatherHereを設置する処理
    func longTapGathereHereHandler(matchData: MatchDataModel? , gestureRecognizer: UILongPressGestureRecognizer) {
        // ロングタップ開始
        if gestureRecognizer.state == .began {
            self.removeGatherHere()
        }
            // ロングタップ終了（手を離した）
        else if gestureRecognizer.state == .ended {
            let tapPoint = gestureRecognizer.location(in: mapView)
            let center = mapView.convert(tapPoint, toCoordinateFrom: mapView)
            // 現在地と目的地のMKPlacemarkを生成(ここいる？)
            let fromPlacemark = MKPlacemark(coordinate:mapView.userLocation.coordinate, addressDictionary:nil)
            let toPlacemark   = MKPlacemark(coordinate:center, addressDictionary:nil)
            self.showRoute(from: fromPlacemark, to: toPlacemark)
            
            //test by kitahara ここでdelegteして場所をサーバに送る必要あり
        }
    }
    
    //ロングタップした時に検索範囲を変更する処理
    func longTapChangeDiscoveryCenter(gestureRecognizer: UILongPressGestureRecognizer , endHandler : (CLLocationCoordinate2D) -> ()) {
        // ロングタップ開始
        if gestureRecognizer.state == .began {
            self.removeCircleOverlay()
        }
            // ロングタップ終了（手を離した）
        else if gestureRecognizer.state == .ended {
            let tapPoint = gestureRecognizer.location(in: mapView)
            let center = mapView.convert(tapPoint, toCoordinateFrom: mapView)
            endHandler(center)
        }
    }
    
    func calculateDistanceMeter(x : CLLocationCoordinate2D , y : CLLocationCoordinate2D) -> Double {
        let loc_x = CLLocation(latitude: x.latitude, longitude: x.longitude)
        let loc_y = CLLocation(latitude: y.latitude, longitude: y.longitude)
        let distance_m = loc_x.distance(from: loc_y)
        return distance_m
    }
    
    //十分に近づいたことを判定する
    func isNear(x : CLLocationCoordinate2D , y : CLLocationCoordinate2D) -> Bool{
        let distance_m = calculateDistanceMeter(x: x, y: y)
        LogDebug("distance_m = \(distance_m)")
        if distance_m < NEAR_METER {
            return true
        } else {
            //test by kitahara
            return true
        }
    }
}
