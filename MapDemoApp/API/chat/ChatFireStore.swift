//
//  ChatFireStore.swift
//  MapDemoApp
//
//  Created by kitaharamugirou on 2019/03/16.
//  Copyright © 2019 kitaharamugirou. All rights reserved.
//

import FirebaseFirestore

import Foundation
class ChatFireStore {
    let collectionName = "chat"
    let firestore = Firestore.firestore()
    let collection : CollectionReference
    typealias Ops = ([String : Any]) -> ()
    
    init() {
        self.collection = self.firestore.collection(collectionName)
    }
    
    func addChatMessage(message : ChatMessageViewModel) {
        self.addDocument(data: [
            "id" : message.sender.id ,
            "name" : message.sender.name ,
            "messageId" : message.messageId ,
            "sentDate": message.sentDate ,
            "kind" : message.kind ,
            "message" : message.message
            ])
    }
    
    func readMessage(message_list : [ChatMessage] ) {
        addSnapshot(addOps: {data in
            if let vm = ChatMessageViewModel.readData(data: data) {
                let message = ChatMessage(vm: vm)
                //message_list.append(message)
                //この苦労して作ったメッセージはどうすればいいんだ・・・
            }
        }, modifyOps: nil, removeOps: nil)
    }
    
    /*Generalな関数はスーパークラスに投げたいけどswiftでの書き方がわからない*/
    //documentを追加する
    func addDocument(data : [String : Any]) {
        collection.addDocument(data: data)
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
