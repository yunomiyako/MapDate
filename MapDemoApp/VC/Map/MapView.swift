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
    private var locationManager : CLLocationManager?
    
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
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutMapView()
    }
    
    // MARK: - Create subviews -
    private func createMapView() -> MKMapView {
        let view = MKMapView()
        view.showsUserLocation = true
        view.mapType = MKMapType.standard
        view.isZoomEnabled = true
        view.isScrollEnabled = true
        view.userTrackingMode = MKUserTrackingMode.followWithHeading
        return view
    }
    
    // MARK: - Layout subviews -
    private func layoutMapView() {
        mapView.frame = self.frame
    }
    
    func zoomUpUserLocation() {
        mapView.setCenter(mapView.userLocation.coordinate, animated: true)
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else {
            return
        }
        
        let location:CLLocationCoordinate2D
            = CLLocationCoordinate2DMake(newLocation.coordinate.latitude, newLocation.coordinate.longitude)
        let latitude = "".appendingFormat("%.4f", location.latitude)
        let longitude = "".appendingFormat("%.4f", location.longitude)
        print(latitude + " : " + longitude)
        
        // update annotation
        mapView.removeAnnotations(mapView.annotations)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = newLocation.coordinate
        mapView.addAnnotation(annotation)
        mapView.selectAnnotation(annotation, animated: true)
        
        // Showing annotation zooms the map automatically.
        mapView.showAnnotations(mapView.annotations, animated: true)
        
    }
}
