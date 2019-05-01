//
//  ProfRepository.swift
//  MapDemoApp
//
//  Created by 萬年司 on 2019/04/25.
//  Copyright © 2019 kitaharamugirou. All rights reserved.
//aaaaaaaaaaaaaa

import Foundation
import Alamofire

class ProfRepository {

    private let cloudFunctionHelper = CloudFunctionsHelper()
    
    
    func requestGetProf(uid: String, completion : @escaping (RequestProfGetResponse) -> ()){
        
        let request = RequestProfGetRequest(uid : uid)
        cloudFunctionHelper.call(request: request, completion: { res in
            if res.name == nil {
                completion(RequestProfGetResponse())
                return
            }
            
            completion(res)
        } , failure: {
            completion(RequestProfGetResponse())
        })
        
    }
    
    func requestPostProf(uid: String,name:String,age:String,job:String,intro:String,is_man:Bool,is_woman:Bool, completion : @escaping (RequestProfPostResponse) -> ()){
        
        let request = RequestProfPostRequest(uid : uid, name: name, age: age, job: job,intro:intro,is_man:is_man,is_woman:is_woman)
        cloudFunctionHelper.call(request: request, completion: { res in
            if res.result == "fail" {
                completion(RequestProfPostResponse())
                return
            }
            
            completion(res)
        } , failure: {
            completion(RequestProfPostResponse())
        })
        
    }
}
