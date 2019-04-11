//
//  RestoreMatchRequest.swift
//  MapDemoApp
//
//  Created by kitaharamugirou on 2019/04/11.
//  Copyright © 2019 kitaharamugirou. All rights reserved.
//

import Foundation
import Alamofire
struct RestoreMatchRequest : RequestProtocol {
    var parameters: Parameters?
    typealias Response = RequestMatchResponse
    var functionName: String = "restore_match"
    
    init(uid : String ) {
        self.parameters = [
            "uid" : uid
        ]
    }
}
