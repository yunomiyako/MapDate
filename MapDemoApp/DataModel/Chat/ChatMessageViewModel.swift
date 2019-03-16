//
//  ChatMessage.swift
//  MapDemoApp
//
//  Created by kitaharamugirou on 2019/03/10.
//  Copyright © 2019 kitaharamugirou. All rights reserved.
//

import Foundation
class SenderViewModel : Codable {
    var id : String
    var name : String
    
    init(id : String , name : String) {
        self.id = id
        self.name = name
    }
}

class ChatMessageViewModel : Codable{
    var sender: SenderViewModel
    var messageId: String
    var sentDate: Double
    var kind: String
    var message : String
    
    init(id : String , name : String , messageId : String , sentDate: Double , kind : String , message : String) {
        self.sender = SenderViewModel(id: id, name: name)
        self.messageId = messageId
        self.sentDate = sentDate
        self.kind = kind
        self.message = message
    }
    
    static func readData(data : [String : Any]) -> ChatMessageViewModel? {
        guard let id = data["id"] as? String else {return nil}
        guard let name = data["name"] as? String else {return nil}
        guard let messageId = data["messageId"] as? String else {return nil}
        guard let sentDate = data["sentDate"] as? Double else {return nil}
        guard let kind = data["kind"] as? String else {return nil}
        guard let message = data["message"] as? String else {return nil}
        
        return ChatMessageViewModel(id: id, name: name, messageId: messageId, sentDate: sentDate, kind: kind, message: message)
    }
}

