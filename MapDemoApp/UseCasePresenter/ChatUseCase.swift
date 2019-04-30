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
    
    func listenChatMessages(matchData : MatchDataModel , completion : @escaping ([ChatMessage]) -> ()) {
        let transactionId = matchData.transaction_id
        chatFireStore.readMessage(transactionId: transactionId, handler: {messages in
            completion(messages.sorted{ $0.sentDate < $1.sentDate })
        })
    }
    
    func addChatMessage(matchData : MatchDataModel ,text : String , sender : Sender ) {
        let transactionId = matchData.transaction_id
        let uid = UUID().uuidString
        let message = ChatMessage(text: text, sender: sender, messageId: uid, date: Date())
        let vm = ChatMessageViewModel(message : message)
        chatFireStore.addChatMessage(transactionId: transactionId, message: vm)
    }

    
    
}
