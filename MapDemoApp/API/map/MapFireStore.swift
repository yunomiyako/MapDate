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
    let pathlib = MapFireStorePath()
    let gatherHereDocumentPath = "gatherHere"
    
    func getGatherHereLocation(transactionId : String , handler : @escaping (LocationLog) -> ()) {
        self.initializeDocument(transactionId: transactionId, location_id: gatherHereDocumentPath)
        self.firestore.collection(pathlib.partnerLocation(transactionId: transactionId)).document(gatherHereDocumentPath).addSnapshotListener { (snapshot, error) in
            
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
    
    private func initializeDocument(transactionId : String , location_id : String) {
        let isAccessible = self.firestore.collection(pathlib.partnerLocation(transactionId: transactionId)).document(location_id).isAccessibilityElement
        if !isAccessible {
            self.firestore.collection(pathlib.partnerLocation(transactionId: transactionId)).document(location_id).setData([:])
        }
    }
    
    func getLocation(transactionId : String , location_id : String , handler : @escaping (LocationLog) -> ()) {
        
        self.initializeDocument(transactionId: transactionId, location_id: location_id)
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
    
    func sendGatherHereLocation(transactionId : String , location : LocationLog) {
        let collection = self.firestore.collection(pathlib.partnerLocation(transactionId: transactionId))
        collection.document(gatherHereDocumentPath).setData(
            [
                "id" : location.id ,
                "latitude": location.latitude ,
                "longitude" : location.longitude ,
                "createdAt" : location.createdAt ,
                ]
        )
    }
    
    func deleteLocation(transactionId : String , location_id : String) {
        let collection = self.firestore.collection(pathlib.partnerLocation(transactionId: transactionId))
        collection.document(location_id).delete()
    }
    
    func setLocation(transactionId : String , location : LocationLog) {
        LogDebug("write location")
        let collection = self.firestore.collection(pathlib.partnerLocation(transactionId: transactionId))
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
