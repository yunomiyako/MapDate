//
//  RequestProtocol.swift
//  MapDemoApp
//
//  Created by kitaharamugirou on 2019/03/15.
//  Copyright © 2019 kitaharamugirou. All rights reserved.
//

import Foundation
import Alamofire

protocol ResponseProtocol: Decodable {}

protocol RequestProtocol {
    associatedtype Response: ResponseProtocol
    var baseUrl: String { get }
    var path: String { get }
    var functionName : String {get}
    var method: Alamofire.HTTPMethod { get }
    var parameters: Alamofire.Parameters? { get }
    var encoding: Alamofire.ParameterEncoding { get }
    var headers: Alamofire.HTTPHeaders? { get }
}

extension RequestProtocol {
    var baseUrl: String {
        //test by kitahara
        return "http://localhost:3000"
    }
    var encoding: Alamofire.ParameterEncoding {
        return JSONEncoding.default
    }
    var parameters: Alamofire.Parameters? {
        return nil
    }
    var headers: Alamofire.HTTPHeaders? {
        return nil
    }
    var path : String {
        return ""
    }
    var functionName : String {
        return ""
    }
}
