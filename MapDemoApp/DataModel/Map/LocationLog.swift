//
//  PeopleLocation.swift
//  MapDemoApp
//
//  Created by kitaharamugirou on 2019/03/10.
//  Copyright © 2019 kitaharamugirou. All rights reserved.
//

import Foundation
import MapKit

//FireStoreと通信する時の位置情報ログ
struct LocationLog {
    let id : String //user_location_id
    let latitude: Double
    let longitude: Double
    let createdAt: Date
    
    init(coordinate : CLLocationCoordinate2D , id : String) {
        self.id = id
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
        self.createdAt = Date()
    }
    
    init(document: [String: Any]) {
        id = document["id"] as? String ?? ""
        latitude = document["latitude"] as? Double ?? 0
        longitude = document["longitude"] as? Double ?? 0
        createdAt = document["createdAt"] as? Date ?? Date()
    }
    
    func getCLLocationCoordinate2D() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
}
