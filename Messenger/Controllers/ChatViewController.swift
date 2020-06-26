//
//  ChatViewController.swift
//  Messenger
//
//  Created by Maxim Granchenko on 24.06.2020.
//  Copyright © 2020 Maxim Granchenko. All rights reserved.
//

import UIKit
import MessageKit

struct Message: MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}

struct Sender: SenderType {
    var photoURL: String
    var senderId: String
    var displayName: String
}

class ChatViewController: MessagesViewController {
    
    private var message = [Message]()
    private let sender = Sender(photoURL: "", senderId: "1", displayName: "Joe Smith")

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        message.append(Message(sender: sender, messageId: "1", sentDate: Date(), kind: .text("Hello world!")))
        message.append(Message(sender: sender, messageId: "1", sentDate: Date(), kind: .text("Hello world!, Hello world!, Hello world!, Hello world!")))
        
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
    }
    
    
}

extension ChatViewController: MessageCellDelegate, MessagesDataSource, MessagesDisplayDelegate, MessagesLayoutDelegate {
    func currentSender() -> SenderType {
        return sender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return message[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return message.count
    }
}
