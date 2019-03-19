//
//  ChatFireStore.swift
//  MapDemoApp
//
//  Created by kitaharamugirou on 2019/03/16.
//  Copyright © 2019 kitaharamugirou. All rights reserved.
//

import FirebaseFirestore
import Foundation

class ChatFireStorePath {
    func parent() -> String{
        return "chat"
    }
    
    func room(transactionId : String) -> String{
        return self.parent() + "/" + "rooms/" +  transactionId
    }
}

class ChatFireStore {
    let firestore = Firestore.firestore()
    let pathlib = ChatFireStorePath()
    
    func addChatMessage(transactionId : String , message : ChatMessageViewModel ) {
        
        let data : [String : Any] = [
         "id" : message.sender.id ,
         "name" : message.sender.name ,
         "messageId" : message.messageId ,
         "sentDate": message.sentDate ,
         "kind" : message.kind ,
         "message" : message.message
         ]
        firestore.collection(pathlib.room(transactionId: transactionId)).addDocument(data: data)
    }
    
    func readMessage(transactionId : String , handler : @escaping ([ChatMessage]) -> ()) {
        firestore.collection(pathlib.room(transactionId: transactionId)).addSnapshotListener { (query, error) in
            if let value = query {
                let newValues = value.documentChanges.filter{change in
                    return change.type == DocumentChangeType.added
                }
                let newMessages = newValues.map{x in x.document.data()}
                LogDebug("newMessages count = \(newMessages.count)")
                let newMessagesViewModel = newMessages.map{x in
                    ChatMessageViewModel(data : x)}
                let newChatMessages = newMessagesViewModel.map{x in
                    ChatMessage(vm: x)
                }
                handler(newChatMessages)
            }
        }
    }
}
