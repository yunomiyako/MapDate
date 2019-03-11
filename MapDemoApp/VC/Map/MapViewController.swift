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
    
    
    private let mapUseCase = MapUseCase()
    
    // MARK: - Life cycle events -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(mapView)
        self.view.addSubview(bottomView)
        self.view.bringSubviewToFront(bottomView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.layoutMapView()
        self.layoutBottomView()
    }
    
    // MARK: - Create subviews -
    private func createMapView() -> MapView {
        let rect = MapView()
        return rect;
    }
    
    // MARK: - Create subviews -
    private func createBottomView() -> MapBottomView {
        let view = MapBottomView()
        return view
    }
    
    // MARK: - Layout subviews -
    private func layoutMapView() {
        mapView.frame = self.view.frame
    }
    
    private func layoutBottomView() {
        constrain(bottomView) { view in
            view.bottom == view.superview!.bottom
            view.left == view.superview!.left
            view.right == view.superview!.right
            view.height == 200
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        mapView.zoomUpUserLocation()
    }

}
