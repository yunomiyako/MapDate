//
//  ChatMessage.swift
//  MapDemoApp
//
//  Created by kitaharamugirou on 2019/03/10.
//  Copyright © 2019 kitaharamugirou. All rights reserved.
//

import Foundation
import MessageKit

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
    
    convenience init(message : ChatMessage) {
        let id = message.sender.id
        let name = message.sender.displayName
        let messageId = message.messageId
        let sentDate = CommonUtils.convertDateToTimeStamp(date: message.sentDate)
        let kind = message.kind
        if case let MessageKind.text(text) = kind {
            self.init(id: id, name: name, messageId: messageId, sentDate: sentDate, kind:"text" , message: text)
            return 
        }
        
        self.init(data: [:])
    }
    
    convenience init(data : [String : Any]) {
        let id = data["id"] as? String ?? ""
        let name = data["name"] as? String ?? ""
        let messageId = data["messageId"] as? String ?? ""
        let sentDate = data["sentDate"] as? Double ?? 0
        let kind = data["kind"] as? String ?? ""
        let message = data["message"] as? String ?? ""
        self.init(id: id, name: name, messageId: messageId, sentDate: sentDate, kind: kind, message: message)
    }
    
    init(id : String , name : String , messageId : String , sentDate: Double , kind : String , message : String) {
        self.sender = SenderViewModel(id: id, name: name)
        self.messageId = messageId
        self.sentDate = sentDate
        self.kind = kind
        self.message = message
    }
}

