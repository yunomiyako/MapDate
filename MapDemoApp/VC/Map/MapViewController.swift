//
//  MapViewController.swift
//  MapDemoApp
//
//  Created by kitaharamugirou on 2019/03/10.
//  Copyright © 2019 kitaharamugirou. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {

    // MARK: - Properties -
    lazy private var mapView:MapView = self.createMapView()
    private let mapUseCase = MapUseCase()
    
    // MARK: - Life cycle events -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(mapView)
        
        //近くの人のデータを集める
        let userLocation = mapView.getUserLocation()
        let peoples = mapUseCase.getNearPeople(latitude: Double(userLocation.latitude), longitude: Double(userLocation.longitude))
        mapView.pinLocation(peoples : peoples)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.layoutMapView()
    }
    
    // MARK: - Create subviews -
    private func createMapView() -> MapView {
        let rect = MapView()
        return rect;
    }
    
    // MARK: - Layout subviews -
    private func layoutMapView() {
        mapView.frame = self.view.frame
    }
    
    override func viewDidAppear(_ animated: Bool) {
        mapView.zoomUpUserLocation()
    }

}
