//
//  MapFireStore.swift
//  MapDemoApp
//
//  Created by kitaharamugirou on 2019/03/17.
//  Copyright © 2019 kitaharamugirou. All rights reserved.
//

import Foundation
import FirebaseFirestore

class MapFireStorePath {
    func parent() -> String{
        return "map"
    }
    
    func partnerLocation(transactionId : String) -> String{
        return self.parent() + "/" + "location/" +  transactionId
    }
}

class MapFireStore {
    let firestore = Firestore.firestore()
    typealias Ops = ([String : Any]) -> ()
    var lastWriteTime : Date? = nil
    let pathlib = MapFireStorePath()
    
    func getLocation(transactionId : String , location_id : String , handler : @escaping (LocationLog) -> ()) {
        self.firestore.collection(pathlib.partnerLocation(transactionId: transactionId)).document(location_id).addSnapshotListener { (snapshot, error) in
            
            if let error = error {
                LogDebug("Error getting documents: \(error)")
            } else {
                guard let d = snapshot?.data() else {
                    LogDebug("document was nil")
                    return
                }
                let log = LocationLog(document: d)
                handler(log)
            }
            
        }
    }
    
    func setLocation(transactionId : String , location : LocationLog) {
        //書き込み時間制限
        LogDebug("write will start")
        if let lastTime = lastWriteTime {
            let time_diff = location.createdAt.timeIntervalSince1970 - lastTime.timeIntervalSince1970
            LogDebug("time_diff = " + time_diff.description)
            if time_diff < 30 {
                LogDebug("write skip")
                return
            }
        }
        
        let collection = self.firestore.collection(pathlib.partnerLocation(transactionId: transactionId))
        lastWriteTime = Date()
        collection.document(location.id).setData(
            [
                "id" : location.id ,
                "latitude": location.latitude ,
                "longitude" : location.longitude ,
                "createdAt" : location.createdAt ,
            ]
        )
        
    }
    

    //Snapshotリスナーをつける
    func addSnapshot(collection : CollectionReference , addOps : Ops? , modifyOps : Ops?, removeOps : Ops? ) {
        collection.addSnapshotListener { (query, error) in
            guard let value = query else {return}
            value.documentChanges.forEach{diff in
                switch(diff.type){
                case .added:
                    if let op = addOps {
                        op(diff.document.data())
                    }
                case .modified:
                    if let op = modifyOps {
                        op(diff.document.data())
                    }
                case .removed:
                    if let op = removeOps {
                        op(diff.document.data())
                    }
                }
            }
        }
    }
}
