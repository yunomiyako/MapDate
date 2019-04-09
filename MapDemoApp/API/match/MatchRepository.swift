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
    private let cloudFunctionHelper = CloudFunctionsHelper()
    
    //マッチを希望する
    func requestMatch(uid : String , location : LocationLog , radius : Double , age_range : [Int] , completion : @escaping (RequestMatchResponse) -> ()) {
        let request = RequestMatchRequest(uid: uid, latitude: location.latitude, longitude: location.longitude, radius: radius, age_range: age_range)
        cloudFunctionHelper.call(request: request, completion: { res in
            completion(res)
        } , failure: {
            completion(RequestMatchResponse())
        })
    }
}
