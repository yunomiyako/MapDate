//
//  reqAndResForProf.swift
//  
//
//  Created by 萬年司 on 2019/04/24.
//aaaaaaaaaaaaaaaaaa
//

import Foundation
import Alamofire
struct RequestProfGetRequest : RequestProtocol {
    var parameters: Parameters?
    typealias Response = RequestProfGetResponse
    var functionName: String = "request_Prof_Get"

    init(uid : String) {
        self.parameters = [
            "uid" : uid 
        ]
    }
}

class RequestProfGetResponse : ResponseProtocol {
    var result : String
    var name : String?
    var age: String?
    var job:String?
    var intro:String?
    var is_man:Bool?
    var is_woman:Bool?
    
    init() {
        self.result = "fail"
        name = nil
        age = nil
        job = nil
        intro = nil
        is_man = nil
        is_woman = nil
    }
}

struct RequestProfPostRequest : RequestProtocol {
    var parameters: Parameters?
    typealias Response = RequestProfPostResponse
    var functionName: String = "request_Prof_Post"
    
    init(uid : String,name:String,age:String,job:String,intro:String,is_man:Bool,is_woman:Bool) {
        self.parameters = [
            "uid" : uid,
            "name" : name,
            "age": age,
            "job":job,
            "intro": intro,
            "is_man": is_man,
            "is_woman":is_woman
        ]
    }
}

class RequestProfPostResponse : ResponseProtocol {
    var result : String

    
    init() {
        self.result = "fail"
 
    }
}
