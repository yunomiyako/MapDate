//
//  ChatViewController.swift
//  MapDemoApp
//
//  Created by kitaharamugirou on 2019/03/10.
//  Copyright © 2019 kitaharamugirou. All rights reserved.
//

import UIKit
import MessageKit

class ChatViewController: MessagesViewController {
    // Some global variables for the sake of the example. Using globals is not recommended!
    private let sender = Sender(id: "any_unique_id", displayName: "Steven")
    private var messages: [MessageType] = []
    private let chatUseCase = ChatUseCase()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        chatUseCase.listenChatMessages() { messages in
            self.messages =  messages
            self.messagesCollectionView.reloadData()
        }
    }
    
}

extension ChatViewController: MessagesDataSource {
    func currentSender() -> Sender {
        return self.sender
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return self.messages.count
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return self.messages[indexPath.section]
    }
}

extension ChatViewController: MessagesDisplayDelegate, MessagesLayoutDelegate {}
