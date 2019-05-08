//
//  MatchRepository.swift
//  MapDemoApp
//
//  Created by kitaharamugirou on 2019/03/19.
//  Copyright © 2019 kitaharamugirou. All rights reserved.
//

import Foundation
import Alamofire

class MatchRepository {
    
    //singleton
    let apiCliant = APIClient.shared
    private let cloudFunctionHelper = CloudFunctionsHelper()
    
    //評価する
    func rateMatch(uid : String , transaction_id : String , rate : Double , completion :  @escaping (MatchState) -> ()) {
        let request = RateMatchRequest(uid: uid, transaction_id: transaction_id, rate : rate)
        cloudFunctionHelper.call(request: request, completion: { res in
            completion(res.matchState())
        } , failure: {
            LogDebug("rateMatch error")
            completion(MatchState.initial)
        })
    }
    
    
    //ユーザの行動をサーバにpostする
    func matchAction(uid : String , transaction_id : String , action : MatchActionType , completion :  @escaping (MatchState) -> ()) {
        let request = MatchActionRequest(uid: uid, transaction_id: transaction_id, action: action)
        cloudFunctionHelper.call(request: request, completion: { res in
            completion(res.matchState())
        } , failure: {
            LogDebug("matchAction error")
            completion(MatchState.initial)
        })
    }
    
    //DBからmatchStateを確認する
    func checkMatchState(uid : String , completion :  @escaping (MatchState) -> ()) {
        let request = CheckMatchStateRequest(uid: uid)
        cloudFunctionHelper.call(request: request, completion: { res in
            completion(res.matchState())
        } , failure: {
            LogDebug("checkMatchState error")
            completion(MatchState.initial)
        })
    }
    
    //マッチを希望する
    func requestMatch(uid : String , location : LocationLog , radius : Double , age_range : [Int] , completion : @escaping (RequestMatchResponse) -> ()) {
        let request = RequestMatchRequest(uid: uid, latitude: location.latitude, longitude: location.longitude, radius: radius, age_range: age_range)
        cloudFunctionHelper.call(request: request, completion: { res in
            //test by kitahara こんなコードはバックエンドで解決すべき
            if res.partner_location_id == nil {
                completion(RequestMatchResponse())
                return
            }
            
            completion(res)
        } , failure: {
            completion(RequestMatchResponse())
        })
    }
    
    //募集中のマッチを探す
    func findRequestMatch(uid : String , location : LocationLog , radius : Double , age_range : [Int] , completion : @escaping (FindRequestMatchRequest.Response) -> ()) {
        let request = FindRequestMatchRequest(uid: uid, latitude: location.latitude, longitude: location.longitude, radius: radius, age_range: age_range)
        cloudFunctionHelper.call(request: request, completion: { res in
            completion(res)
        })
    }
    
    //マッチの募集を受け取る
    func receiveMatch(uid : String , partner_location_id : String , completion : @escaping (ReceiveMatchRequest.Response) -> () ) {
        let request = ReceiveMatchRequest(uid: uid , partner_location_id : partner_location_id)
        cloudFunctionHelper.call(request: request, completion: { res in
            completion(res)
        })
    }
    
    //マッチング中のデータを取得
    func restoreMatch(uid : String , completion : @escaping (RestoreMatchRequest.Response) -> ()) {
        let request = RestoreMatchRequest(uid: uid)
        cloudFunctionHelper.call(request: request, completion: { res in
            completion(res)
        })
    }
}
