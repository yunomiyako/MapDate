//
//  FindRequestMatchRequest.swift
//  MapDemoApp
//
//  Created by kitaharamugirou on 2019/04/09.
//  Copyright © 2019 kitaharamugirou. All rights reserved.
//

import Foundation
import Alamofire
struct FindRequestMatchRequest : RequestProtocol {
    var parameters: Parameters?
    typealias Response = FindRequestMatchResponse
    var functionName: String = "find_request_match"
    
    init(uid : String , latitude: Double , longitude: Double , radius : Double , age_range : [Int]) {
        self.parameters = [
            "uid" : uid ,
            "latitude" : latitude ,
            "longitude" : longitude ,
            "radius" : radius ,
            "age_min" : age_range[0] ,
            "age_max" : age_range[1] ,
            "want_man" : true , //test by kitahara
            "want_woman" : true
        ]
    }
}

class FindRequestMatchResponse : ResponseProtocol {
    var partnersUsers : [ MatchRequestUserModel ]
    
}

class MatchRequestUserModel : Decodable {
    var partner_location_id : String
    var name : String?
    var headImageUrl : String?
    var rate : Double?
    var intro : String?
}
