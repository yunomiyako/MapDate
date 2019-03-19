//
//  ChatUseCase.swift
//  MapDemoApp
//
//  Created by kitaharamugirou on 2019/03/10.
//  Copyright © 2019 kitaharamugirou. All rights reserved.
//

import Foundation
import MessageKit

class ChatUseCase {
    private let chatRep = ChatRepository()
    private let chatFireStore = ChatFireStore()
    
    func listenChatMessages(completion : @escaping ([ChatMessage]) -> ()) {
        //test by kitahara
        let transactionId = "test_transaction"
        chatFireStore.readMessage(transactionId: transactionId, handler: {messages in
            completion(messages.sorted{ $0.sentDate < $1.sentDate })
        })
    }
    
    func addChatMessage(text : String , sender : Sender ) {
        //test by kitahara
        
        let transactionId = "test_transaction"
        let uid = UUID().uuidString
        let message = ChatMessage(text: text, sender: sender, messageId: uid, date: Date())
        let vm = ChatMessageViewModel(message : message)
        chatFireStore.addChatMessage(transactionId: transactionId, message: vm)
    }

    
    
}
