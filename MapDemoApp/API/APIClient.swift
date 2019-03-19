//
//  APIClient.swift
//  MapDemoApp
//
//  Created by kitaharamugirou on 2019/03/15.
//  Copyright © 2019 kitaharamugirou. All rights reserved.
//

import Foundation
import Alamofire

class APIClient {
    static var shared = APIClient()
    private init() {}
    
    func call<T: RequestProtocol>(request: T, success: @escaping (T.Response) -> Void, failure: @escaping () -> Void) {
        let baseUrl = request.baseUrl
        let path = request.path
        let requestUrl = baseUrl + path
        let method = request.method
        let encoding = request.encoding
        let parameters = request.parameters
        let headers = request.headers
        
        Alamofire.request(requestUrl,
                          method: method,
                          parameters: parameters,
                          encoding: encoding,
                          headers: headers
            )
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(_):
                    do {
                        guard let data = response.data else { return }
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let result = try decoder.decode(T.Response.self, from: data)
                        success(result)
                    } catch {
                        print("suceess catch")
                        failure()
                    }
                case .failure(_):
                    print("failure")
                    failure()
                }
        }
    }
}
