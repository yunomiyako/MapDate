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
    
    func fetchChatMessages(completion : @escaping ([ChatMessage]) -> ()) {
        chatRep.fetchMessages(completion: completion)
    }

    
}
