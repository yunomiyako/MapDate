//
//  File.swift
//  MapDemoApp
//
//  Created by kitaharamugirou on 2019/05/08.
//  Copyright © 2019 kitaharamugirou. All rights reserved.
//

import Foundation
import MapKit
class LocationExchange {
    
    fileprivate var mapFireStore = MapFireStore()
    var lastWriteTime : Date? = nil
    
    //自分の位置情報をfirestoreに送る
    func sendLocation(matchData : MatchDataModel , coordinate : CLLocationCoordinate2D , shareLocation : Bool) {
        let transactionId = matchData.transaction_id
        let location_id = matchData.your_location_id
        let log = LocationLog(coordinate: coordinate, id: location_id)
        if shareLocation {
            //書き込み時間制限
            if let lastTime = lastWriteTime {
                let time_diff = log.createdAt.timeIntervalSince1970 - lastTime.timeIntervalSince1970
                if time_diff < 5 {
                    return
                }
            }
            
            lastWriteTime = Date()
            mapFireStore.setLocation(transactionId: transactionId, location: log)
        } else {
            lastWriteTime = nil
            mapFireStore.deleteLocation(transactionId: transactionId , location_id : location_id)
        }
    }
    
    func sendGatherHereLocation(matchData : MatchDataModel? , coordinate : CLLocationCoordinate2D) {
        guard let _matchData = matchData else {return}
        let transactionId = _matchData.transaction_id
        let log = LocationLog(coordinate: coordinate, id: "gather here")
        mapFireStore.sendGatherHereLocation(transactionId: transactionId, location: log)
    }
    
    
    //相手の位置情報をfirestoreから受け取る
    func receivePartnerLocation(matchData : MatchDataModel , handler : @escaping (LocationLog) -> ()) {
        let transactionId = matchData.transaction_id
        let partner_location_id = matchData.partner_location_id
        mapFireStore.getLocation(transactionId: transactionId, location_id: partner_location_id, handler: {log in
            handler(log)
        })
    }
    
    //相手の位置情報をfirestoreから受け取る
    func receiveGatherHereLocation(matchData : MatchDataModel , handler : @escaping (LocationLog) -> ()) {
        let transactionId = matchData.transaction_id
        mapFireStore.getGatherHereLocation(transactionId: transactionId, handler: {log in
            handler(log)
        })
    }
}
