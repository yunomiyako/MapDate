//
//  getNearPeople.swift
//  MapDemoApp
//
//  Created by kitaharamugirou on 2019/03/10.
//  Copyright © 2019 kitaharamugirou. All rights reserved.
//

import Foundation
import Alamofire
import FirebaseFunctions
class MapRepository {
    
    //singleton
    let apiCliant = APIClient.shared
    private let cloudFunctionHelper = CloudFunctionsHelper()
    
    //近くにいる人数を取得する
    func getNearPeopleNumber(completion : @escaping (GetNearPeopleNumberResponse) -> ()) {
        let request = GetNearPeopleNumberRequest(num: 34)
        cloudFunctionHelper.call(request: request, completion: { res in
            completion(res)
        })
    }
    
    //リクエストマッチを行う
    func requestMatch() {
        
    }
}
