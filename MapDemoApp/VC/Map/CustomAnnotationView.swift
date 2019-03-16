//
//  CustomAnnotationView.swift
//  MapDemoApp
//
//  Created by kitaharamugirou on 2019/03/14.
//  Copyright © 2019 kitaharamugirou. All rights reserved.
//

import Foundation
// 1
import MapKit

// 2
class CustomAnnotation: NSObject, MKAnnotation
{
    // 3
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var image : UIImage?
    var id : String
    
    // 4
    init(coor: CLLocationCoordinate2D , image : UIImage? , id : String)
    {
        self.id = id
        self.coordinate = coor
        
        if image == nil {
            self.image = UIImage(named: "default_profile_image.png")
        } else {
            self.image = image!
        }
    }
}
