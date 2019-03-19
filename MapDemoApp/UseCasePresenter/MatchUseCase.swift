//
//  MatchUseCase.swift
//  MapDemoApp
//
//  Created by kitaharamugirou on 2019/03/19.
//  Copyright © 2019 kitaharamugirou. All rights reserved.
//

import Foundation

class MatchUseCase {
    private let matchRep = MatchRepository()
    private let mapUseCase = MapUseCase()
    
    func requestMatch(uid : String , location: LocationLog , completion : @escaping (RequestMatchResponse) -> ()) {
        let radius = mapUseCase.getSyncDiscoveryDistance()
        let age_range = mapUseCase.getSyncDiscoveryAge()
        let age_range_int : [Int] = [Int(age_range[0]) , Int(age_range[1])]
        matchRep.requestMatch(uid: uid, location: location, radius: Double(radius), age_range : age_range_int , completion: completion)
    }
}
