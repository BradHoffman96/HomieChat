//
//  ViewController.swift
//  MessageApp
//
//  Created by Bradley Hoffman on 5/7/19.
//  Copyright © 2019 Create. All rights reserved.
//

import UIKit
import MessageKit
import MessageInputBar
import Messages

let sender = Sender(id: "any_unique_id", displayName: "Steven")
var messages : [Message] = []

//private var messageListener: ListenerRegistration?

class ChatViewController: MessagesViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self
    }
    
    func isLastSectionVisible() -> Bool {
        
        guard !messages.isEmpty else { return false }
        
        let lastIndexPath = IndexPath(item: 0, section: messages.count - 1)
        
        return messagesCollectionView.indexPathsForVisibleItems.contains(lastIndexPath)
    }
}

extension ChatViewController: MessagesDataSource {
    
    func currentSender() -> Sender {
        return Sender(id: "any_unique_id", displayName: "Steven")
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
}

extension ChatViewController: MessageInputBarDelegate {
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        
        var message = Message(sender: sender, messageId: UUID().uuidString, sentDate: Date.init(), kind: .text(text), content: text)
        messages.append(message)
        
        messagesCollectionView.performBatchUpdates({
            messagesCollectionView.insertSections([messages.count - 1])
            if messages.count >= 2 {
                messagesCollectionView.reloadSections([messages.count - 2])
            }
        }, completion: { [weak self] _ in
            if self?.isLastSectionVisible() == true {
                self?.messagesCollectionView.scrollToBottom(animated: true)
            }
        })
        
        inputBar.inputTextView.text = ""
    }
}

extension ChatViewController: MessagesDisplayDelegate, MessagesLayoutDelegate {}

