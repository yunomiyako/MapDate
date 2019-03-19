//
//  MatchRepository.swift
//  MapDemoApp
//
//  Created by kitaharamugirou on 2019/03/19.
//  Copyright © 2019 kitaharamugirou. All rights reserved.
//

import Foundation
import Alamofire

class MatchRepository {
    
    //singleton
    let apiCliant = APIClient.shared
    
    //マッチを希望する
    func requestMatch(uid : String , location : LocationLog , radius : Double , age_range : [Int] , completion : @escaping (RequestMatchResponse) -> ()) {
        let request = RequestMatch(uid: uid, latitude: location.latitude, longitude: location.longitude, radius: radius, age_range: age_range)
        apiCliant.call(request: request,
                       success:  completion,
                       failure: {
                        let failResponse = RequestMatchResponse()
                        completion(failResponse)
                        
        })
        
    }
    
    
}
