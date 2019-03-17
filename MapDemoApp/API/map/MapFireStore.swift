//
//  MapFireStore.swift
//  MapDemoApp
//
//  Created by kitaharamugirou on 2019/03/17.
//  Copyright © 2019 kitaharamugirou. All rights reserved.
//

import Foundation
import FirebaseFirestore

class MapFireStore {

    let collectionName = "Map"
    let firestore = Firestore.firestore()
    let collection : CollectionReference
    typealias Ops = ([String : Any]) -> ()
    
    var lastWriteTime : Date? = nil
    
    init() {
        self.collection = self.firestore.collection(collectionName)
    }
    
    func getLocation(transactionId : String , handler : @escaping (LocationLog) -> ()) {
        self.collection.document(transactionId).addSnapshotListener { (snapshot, error) in
            
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
            
            if time_diff < 60 * 5 {
                LogDebug("write skip")
                return
            }
        }
        
        self.addDocument(documentName : transactionId , data:[
            "id" : location.id ,
            "latitude": location.latitude ,
            "longitude" : location.longitude ,
            "createdAt" : location.createdAt ,
        ])
    }
    
    /*Generalな関数はスーパークラスに投げたいけどswiftでの書き方がわからない*/
    //documentを追加する
    func addDocument(data : [String : Any]) {
        collection.addDocument(data: data)
    }
    
    func addDocument(documentName : String , data : [String : Any]) {
        collection.document(documentName).setData(data)
    }
    
    //Snapshotリスナーをつける
    func addSnapshot(addOps : Ops? , modifyOps : Ops?, removeOps : Ops? ) {
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
