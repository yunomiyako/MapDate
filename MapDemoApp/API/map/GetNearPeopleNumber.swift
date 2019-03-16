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
    var path: String = "/people_number"
    var method =  Alamofire.HTTPMethod.get
}

class GetNearPeopleNumberResponse : ResponseProtocol {
    var peopleNumber : Int
}
