//
//  GetNearPeopleNumber.swift
//  MapDemoApp
//
//  Created by kitaharamugirou on 2019/03/15.
//  Copyright © 2019 kitaharamugirou. All rights reserved.
//

import Foundation
import Alamofire
struct GetNearPeopleNumberRequest : RequestProtocol {
    typealias Response = GetNearPeopleNumberResponse
    var method =  Alamofire.HTTPMethod.get
    var functionName: String = "get_people_num_by_conditions"
    
    //パラメータ関係 このセットの仕方微妙・・・
    private var num : Int
    init(num : Int) {
        self.num = num
    }
    
    var parameters: Alamofire.Parameters? {
        return ["num" : self.num]
    }
}

class GetNearPeopleNumberResponse : ResponseProtocol {
    var peopleNumber : Int
}
