//
//  RequestMatch.swift
//  MapDemoApp
//
//  Created by kitaharamugirou on 2019/03/19.
//  Copyright © 2019 kitaharamugirou. All rights reserved.
//

import Foundation
import Alamofire
struct RequestMatchRequest : RequestProtocol {
    var parameters: Parameters?
    typealias Response = RequestMatchResponse
    var method =  Alamofire.HTTPMethod.post
    var functionName: String = "request_match"
    
    init(uid : String , latitude: Double , longitude: Double , radius : Double , age_range : [Int]) {
        self.parameters = [
            "uid" : uid ,
            "latitude" : latitude ,
            "longitude" : longitude ,
            "radius" : radius ,
            "age_min" : age_range[0] ,
            "age_max" : age_range[1]
        ]
    }
}

class RequestMatchResponse : ResponseProtocol {
    var result : String
    var your_location_id : String?
    var partner_location_id : String?
    var transaction_id : String?
    
    init() {
        self.result = "fail"
        self.your_location_id = nil
        self.partner_location_id = nil
        self.transaction_id = nil
    }
}
