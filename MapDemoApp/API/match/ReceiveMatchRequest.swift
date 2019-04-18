//
//  ReceiveMatchRequest.swift
//  MapDemoApp
//
//  Created by kitaharamugirou on 2019/04/09.
//  Copyright © 2019 kitaharamugirou. All rights reserved.
//

import Foundation
import Alamofire
struct ReceiveMatchRequest : RequestProtocol {
    var parameters: Parameters?
    typealias Response = RequestMatchResponse
    var functionName: String = "receive_match"
    
    init(uid : String , partner_location_id : String) {
        self.parameters = [
            "uid" : uid ,
            "partner_location_id" : partner_location_id
        ]
    }
}
