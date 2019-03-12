//
//  MapKit extension.swift
//  MapDemoApp
//
//  Created by kitaharamugirou on 2019/03/12.
//  Copyright © 2019 kitaharamugirou. All rights reserved.
//

import Foundation
import MapKit

extension CLLocationCoordinate2D {
    var debugDescription : String {
        get {
            return "(\(self.latitude.description) , \(self.longitude.description))"
        }
    }
}

extension MKCoordinateSpan {
    var debugDescription : String {
        get {
            return "(\(self.latitudeDelta.description) , \(self.longitudeDelta.description))"
        }
    }
}

extension MKCoordinateRegion {
    var debugDescription : String {
        get {
            return "center : \(self.center.debugDescription) , span : \(self.span.debugDescription) "
        }
    }
}
