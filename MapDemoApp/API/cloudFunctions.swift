//
//  cloudFunctions.swift
//  MapDemoApp
//
//  Created by kitaharamugirou on 2019/04/08.
//  Copyright © 2019 kitaharamugirou. All rights reserved.
//

import Foundation
import FirebaseFunctions

class CloudFunctionsHelper {
    let functions = Functions.functions()
    
    func call<T: RequestProtocol>(request : T , completion : @escaping (T.Response) -> () , failure : @escaping () -> () = {}){
        functions.httpsCallable(request.functionName).call(request.parameters) { (result, error) in
            if let error = error as NSError? {
                LogDebug(error.localizedDescription)
                LogDebug("error code = \(error.code)")
                failure()
            } else {
                LogDebug("success enter")
                do {
                    guard let data = result?.data as? [String : Any] else {
                        LogDebug("isn't it data?")
                        failure()
                        return
                    }
                    
                    guard let jsonData = try? JSONSerialization.data(withJSONObject:data) else {
                        LogDebug("dataをjson化できなかった")
                        failure()
                        return
                    }
                    print(data)
                    let decoder = JSONDecoder()
                    //ここ注意 snake_case => snakeCase
                    //decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let res = try decoder.decode(T.Response.self , from: jsonData)
                    completion(res)
                } catch {
                    LogDebug("suceess catch")
                    failure()
                }
            }
        }
    }
}
