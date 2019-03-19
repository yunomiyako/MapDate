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
    
    //近くにいる人の人数を取得する
    func getNearPeopleNumber(location : CLLocationCoordinate2D , radius : Double , completion : @escaping (Int) -> ()) {
        mapRep.getNearPeopleNumber() { response in
            let number = response.peopleNumber
            completion(number)
        }
    }
    
    //設定中の検索範囲を取得する
    func getSyncDiscoveryDistance() -> CGFloat{
        let value = userDefaultsRepository.get(forKey: "DiscoveryDistance") as? CGFloat ?? 3000
        return value
    }
    
    //設定として検索範囲を保存する
    func setSyncDiscoveryDistance(distance : CGFloat) {
        userDefaultsRepository.set(distance, forKey: "DiscoveryDistance")
    }
    
    //設定の年齢範囲
    func getSyncDiscoveryAge() -> [CGFloat]{
        return userDefaultsRepository.get(forKey: "DiscoveryAge") as? [CGFloat] ?? [20 , 30]
    }
    
    //年齢範囲を設定する
    func setSyncDiscoveryAge(age : [CGFloat]) {
        userDefaultsRepository.set(age, forKey: "DiscoveryAge")
    }
}
