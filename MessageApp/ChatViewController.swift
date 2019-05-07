//
//  ViewController.swift
//  MessageApp
//
//  Created by Bradley Hoffman on 5/7/19.
//  Copyright © 2019 Create. All rights reserved.
//

import UIKit
import MessageKit

let sender = Sender(id: "any_unique_id", displayName: "Steven")
let messages : [MessageType] = []

class ChatViewController: MessagesViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self
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

extension ChatViewController: MessagesDisplayDelegate, MessagesLayoutDelegate {}

