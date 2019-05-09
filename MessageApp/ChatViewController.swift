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

class ChatViewController: MessagesViewController, MessageCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messageCellDelegate = self
    }
    
    func isLastSectionVisible() -> Bool {
        
        guard !messages.isEmpty else { return false }
        
        let lastIndexPath = IndexPath(item: 0, section: messages.count - 1)
        
        return messagesCollectionView.indexPathsForVisibleItems.contains(lastIndexPath)
    }
}

extension ChatViewController: MessagesDataSource {
    
    func currentSender() -> Sender {
        return Sender(id: "any_unique_id", displayName: "Steven Kinky")
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        let firstName = message.sender.displayName.components(separatedBy: " ").first
        let lastName = message.sender.displayName.components(separatedBy: " ").last
        let initials = "\(firstName?.first ?? "A")\(lastName?.first ?? "A")"
        print(initials)
        
        let avatar = Avatar(image: nil, initials: initials)
        avatarView.set(avatar: avatar)
    }
}

extension ChatViewController: MessageInputBarDelegate {
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        
        let message = Message(sender: sender, messageId: UUID().uuidString, sentDate: Date.init(), kind: .text(text), content: text)
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

extension ChatViewController: MessagesDisplayDelegate, MessagesLayoutDelegate {
    
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        return NSAttributedString(string: message.sender.displayName, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1)])
    }
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 16.0
    }
    
    func avatarPosition(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> AvatarPosition {
        return AvatarPosition.init(vertical: AvatarPosition.Vertical.messageTop)
    }
}

