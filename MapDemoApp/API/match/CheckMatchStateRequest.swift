//
//  CheckMatchStateRequest.swift
//  MapDemoApp
//
//  Created by kitaharamugirou on 2019/04/24.
//  Copyright © 2019 kitaharamugirou. All rights reserved.
//

import Foundation
import Alamofire
struct CheckMatchStateRequest : RequestProtocol {
    var parameters: Parameters?
    typealias Response = CheckMatchStateResponse
    var functionName: String = "check_match_state"
    
    init(uid : String ) {
        self.parameters = [
            "uid" : uid
        ]
    }
}

class CheckMatchStateResponse : ResponseProtocol {
    var state : String
    
    func matchState() -> MatchState {
        if self.state == "initial" {
            return MatchState.initial
        } else if self.state == "searching" {
            return MatchState.initial //test by kitahara
        } else if self.state == "matched" {
            return MatchState.matched
        } else if self.state == "rating" {
            return MatchState.rating
        } else {
            LogDebug("未知の値 = " + self.state)
            return MatchState.initial
        }
    }
}
