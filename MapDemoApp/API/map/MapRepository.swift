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
    let functions = Functions.functions()
    
    //近くにいる人数を取得する
    func getNearPeopleNumber(completion : @escaping (GetNearPeopleNumberResponse) -> ()) {
        LogDebug("getNearPeopleNumber called")
        let functionName = "get_people_num_by_conditions"
        let params = ["num" : 23]
        functions.httpsCallable(functionName).call(params) { (result, error) in
            LogDebug("result = \(result.debugDescription)")
            LogDebug("getNearPeopleNumber completion enter")
            if let error = error as NSError? {
                LogDebug("error enter")
                LogDebug(error.debugDescription)
                if error.domain == FunctionsErrorDomain {
                    let code = FunctionsErrorCode(rawValue: error.code)
                    let message = error.localizedDescription
                    let details = error.userInfo[FunctionsErrorDetailsKey]
                    LogDebug("error \(message)")
                    //test by kitahara error handling
                }
            } else {
                LogDebug("success enter")
                do {
                    guard let data = result?.data as? [String : Any] else {
                        LogDebug("isn't it data?")
                        return
                    }
                    
                    let num = data["people_number"] as? Int
                    let num_str = data["people_number"] as? String
                    LogDebug("num = \(num)")
                    LogDebug("num_str = \(num_str)")
                    
                    //GetNearPeopleNumberResponse
                
                    guard let jsonData = try? JSONSerialization.data(withJSONObject:data) else {
                        LogDebug("dataをjson化できなかった")
                        return
                    }
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
//                    //test by kitahara decode
                    let res = try decoder.decode(GetNearPeopleNumberRequest.Response.self, from: jsonData)
                    LogDebug("result = \(res.peopleNumber)")
                    completion(res)
                } catch {
                    LogDebug("suceess catch")
                    //failure()
                }
            }
        }
        
//        apiCliant.call(request: request,
//                       success:  completion,
//                       failure: {
//                        LogDebug("getNearPeopleNumber failed")
//        })
    }


}
