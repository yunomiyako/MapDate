//
//  ChatUseCase.swift
//  MapDemoApp
//
//  Created by kitaharamugirou on 2019/03/10.
//  Copyright © 2019 kitaharamugirou. All rights reserved.
//

import Foundation

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
    
    func addChatMessage(message : ChatMessage) {
        //test by kitahara
        let transactionId = "test_transaction"
        let vm = ChatMessageViewModel(message : message)
        chatFireStore.addChatMessage(transactionId: transactionId, message: vm)
    }

    
    
}
