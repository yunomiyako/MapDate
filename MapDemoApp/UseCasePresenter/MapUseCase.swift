//
//  MapUseCase.swift
//  MapDemoApp
//
//  Created by kitaharamugirou on 2019/03/10.
//  Copyright © 2019 kitaharamugirou. All rights reserved.
//

import Foundation
import MapKit
class MapUseCase {
    private let mapRep = MapRepository()
    
    func getNearPeopleNumber(location : CLLocationCoordinate2D , radius : Double , completion : @escaping (Int) -> ()) {
        mapRep.getNearPeopleNumber() { response in
            let number = response.peopleNumber
            completion(number)
        }
    }
}
