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
}
class ChatMessageViewModel : Codable{
    var sender: SenderViewModel
    var messageId: String
    var sentDate: Double
    var kind: String
    var message : String
}

