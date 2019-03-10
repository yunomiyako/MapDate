//
//  ChatMessage.swift
//  MapDemoApp
//
//  Created by kitaharamugirou on 2019/03/10.
//  Copyright © 2019 kitaharamugirou. All rights reserved.
//

import Foundation
import MessageKit
class ChatMessage : MessageType{
    var sender: Sender
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
    
    private init(kind: MessageKind, sender: Sender, messageId: String, date: Date) {
        self.kind = kind
        self.sender = sender
        self.messageId = messageId
        self.sentDate = date
    }
    
    convenience init(vm : ChatMessageViewModel) {
        let type = vm.kind
        if type == "text" {
            let sender = Sender(id: vm.sender.id, displayName: vm.sender.name)
            let date = convertTimeStampToDate(timestamp: vm.sentDate)
            self.init(text: vm.message, sender: sender, messageId: vm.messageId, date: date)
            return
        }
        
        self.init(text: "", sender: Sender(id: "", displayName: ""), messageId: "", date: Date())
    }
    
    convenience init(custom: Any?, sender: Sender, messageId: String, date: Date) {
        self.init(kind: .custom(custom), sender: sender, messageId: messageId, date: date)
    }
    
    convenience init(text: String, sender: Sender, messageId: String, date: Date) {
        self.init(kind: .text(text), sender: sender, messageId: messageId, date: date)
    }
    
    convenience init(attributedText: NSAttributedString, sender: Sender, messageId: String, date: Date) {
        self.init(kind: .attributedText(attributedText), sender: sender, messageId: messageId, date: date)
    }
    
    convenience init(image: UIImage, sender: Sender, messageId: String, date: Date) {
        let mediaItem = ImageMediaItem(image: image)
        self.init(kind: .photo(mediaItem), sender: sender, messageId: messageId, date: date)
    }
    
    convenience init(thumbnail: UIImage, sender: Sender, messageId: String, date: Date) {
        let mediaItem = ImageMediaItem(image: thumbnail)
        self.init(kind: .video(mediaItem), sender: sender, messageId: messageId, date: date)
    }
    
    convenience init(emoji: String, sender: Sender, messageId: String, date: Date) {
        self.init(kind: .emoji(emoji), sender: sender, messageId: messageId, date: date)
    }
}


//チャットメッセージのViewModel
private struct ImageMediaItem: MediaItem {
    
    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize
    
    init(image: UIImage) {
        self.image = image
        self.size = CGSize(width: 240, height: 240)
        self.placeholderImage = UIImage()
    }
}
