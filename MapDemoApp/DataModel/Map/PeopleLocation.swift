//
//  PeopleLocation.swift
//  MapDemoApp
//
//  Created by kitaharamugirou on 2019/03/10.
//  Copyright © 2019 kitaharamugirou. All rights reserved.
//

import Foundation
import MapKit
class PeopleLocation : Codable {
    var id : String
    var latitude : Double
    var longtitude : Double
    
    func getCLLocationCoordinate2D() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longtitude)
    }
}
