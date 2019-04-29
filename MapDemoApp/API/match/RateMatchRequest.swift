//
//  RateMatchRequest.swift
//  MapDemoApp
//
//  Created by kitaharamugirou on 2019/04/29.
//  Copyright © 2019 kitaharamugirou. All rights reserved.
//

import Foundation
import Alamofire
struct RateMatchRequest : RequestProtocol {
    var parameters: Parameters?
    typealias Response = CheckMatchStateResponse
    var functionName: String = "match_action"
    
    
    init(uid : String , transaction_id : String , rate : Double ) {
        self.parameters = [
            "uid" : uid ,
            "transaction_id" : transaction_id ,
            "rate" : rate
        ]
    }
}
