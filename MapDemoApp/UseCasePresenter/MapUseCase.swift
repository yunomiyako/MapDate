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
    private let userDefaultsRepository = UserDefaultsRepository.sharedInstance
    
    func getNearPeopleNumber(location : CLLocationCoordinate2D , radius : Double , completion : @escaping (Int) -> ()) {
        mapRep.getNearPeopleNumber() { response in
            let number = response.peopleNumber
            completion(number)
        }
    }
    
    func getSyncDiscoveryDistance() -> CGFloat{
        let value = userDefaultsRepository.get(forKey: "DiscoveryDistance") as? CGFloat ?? 3000
        LogDebug("getSyncDiscoveryDistance = " + value.description)
        return value
    }
    
    func setSyncDiscoveryDistance(distance : CGFloat) {
        LogDebug("setSyncDiscoveryDistance = " + distance.description)
        userDefaultsRepository.set(distance, forKey: "DiscoveryDistance")
    }
    
    func getSyncDiscoveryAge() -> [CGFloat]{
        return userDefaultsRepository.get(forKey: "DiscoveryAge") as? [CGFloat] ?? [20 , 30]
    }
    
    func setSyncDiscoveryAge(age : [CGFloat]) {
        userDefaultsRepository.set(age, forKey: "DiscoveryAge")
    }
    
    
}
