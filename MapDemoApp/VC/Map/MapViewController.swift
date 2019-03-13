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
    lazy private var topTextView : FloatingRectangleView = self.createTopTextView()
    
    
    private let mapUseCase = MapUseCase()
    
    // MARK: - Life cycle events -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(mapView)
        self.view.addSubview(bottomView)
        self.view.addSubview(topTextView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.mapView.showCircleAroundUser(radius : 2000)
        dispatch_after(1, block: {
            self.topTextView.setText(text: "5 people wait you nearby")
            self.topTextView.showUpAnimation()
        })
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.layoutMapView()
        self.layoutBottomView()
        self.layoutTopTextView()
    }
    
    // MARK: - Create subviews -
    private func createMapView() -> MapView {
        let rect = MapView()
        return rect;
    }
    
    private func createBottomView() -> MapBottomView {
        let view = MapBottomView()
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
        let height : CGFloat = 200
        let y = self.view.frame.height
        bottomView.frame = CGRect(x: 0, y: y - height, width: self.view.frame.width, height: height)
    }
    
    private func layoutTopTextView() {
        let height : CGFloat = 120
        topTextView.frame = CGRect(x: 0, y: 50 , width: self.view.frame.width, height: height)
    }

}
