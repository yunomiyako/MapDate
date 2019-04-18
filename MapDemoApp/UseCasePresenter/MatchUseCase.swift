//
//  MatchUseCase.swift
//  MapDemoApp
//
//  Created by kitaharamugirou on 2019/03/19.
//  Copyright © 2019 kitaharamugirou. All rights reserved.
//

import Foundation

class MatchUseCase {
    private let matchRep = MatchRepository()
    private let mapUseCase = MapUseCase()
    private let firebaseUseCase = FirebaseUseCase()
    private let userDefaultsRepository = UserDefaultsRepository.sharedInstance
    
    
    //マッチリクエストを送る
    func requestMatch(location: LocationLog , completion : @escaping (RequestMatchResponse) -> ()) {
        let user = firebaseUseCase.getCurrentUser()
        guard let uid = user.uid else {return}
        
        let radius = mapUseCase.getSyncDiscoveryDistance()
        let age_range = mapUseCase.getSyncDiscoveryAge()
        let age_range_int : [Int] = [Int(age_range[0]) , Int(age_range[1])]
        matchRep.requestMatch(uid: uid, location: location, radius: Double(radius), age_range : age_range_int , completion: completion)
    }
    
    //募集中のマッチを探す
    func findRequestMatch(location : LocationLog , completion : @escaping (FindRequestMatchRequest.Response) -> ()) {
        let user = firebaseUseCase.getCurrentUser()
        guard let uid = user.uid else {return}
        let radius = mapUseCase.getSyncDiscoveryDistance()
        let age_range = mapUseCase.getSyncDiscoveryAge()
        let age_range_int : [Int] = [Int(age_range[0]) , Int(age_range[1])]
        matchRep.findRequestMatch(uid: uid, location: location, radius: Double(radius), age_range: age_range_int, completion: completion)
    }
    
    //マッチの募集を受け取る
    func receiveMatch(partner_location_id : String , completion : @escaping (ReceiveMatchRequest.Response) -> () ) {
        let user = firebaseUseCase.getCurrentUser()
        guard let uid = user.uid else {return}
        matchRep.receiveMatch(uid: uid, partner_location_id: partner_location_id, completion: completion)
    }
    
    //現在マッチしているマッチング情報を取得
    func restoreMatch(completion : @escaping (RestoreMatchRequest.Response) -> ()) {
        let user = firebaseUseCase.getCurrentUser()
        guard let uid = user.uid else {return}
        matchRep.restoreMatch(uid: uid, completion: completion)
    }
    
    //マップ状態を設定する
    func setSyncMatchState(state : MatchState) {
        let str = state.str()
        userDefaultsRepository.set(str, forKey: "MatchState")
    }
    
    func getSyncMatchState() -> MatchState {
        let str = userDefaultsRepository.get(forKey: "MatchState") as? String ?? "initial"
        let state = MatchState.createStateFromStr(str: str)
        return state
    }
}
