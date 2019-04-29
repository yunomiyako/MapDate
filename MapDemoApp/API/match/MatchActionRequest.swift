//
//  MatchActionRequest.swift
//  MapDemoApp
//
//  Created by kitaharamugirou on 2019/04/29.
//  Copyright © 2019 kitaharamugirou. All rights reserved.
//

import Foundation
import Alamofire
struct MatchActionRequest : RequestProtocol {
    var parameters: Parameters?
    typealias Response = CheckMatchStateResponse
    var functionName: String = "match_action"
    
    
    init(uid : String , transaction_id : String , action : MatchActionType ) {
        self.parameters = [
            "uid" : uid ,
            "transaction_id" : transaction_id ,
            "action" : action.getString()
        ]
    }
}

enum MatchActionType {
    case meet
    case quit
    
    func getString() -> String {
        switch self {
        case .meet:
            return "meet"
        case .quit :
            return "quit"
        }
    }
}
