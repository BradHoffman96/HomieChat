//
//  Message.swift
//  MessageApp
//
//  Created by Bradley Hoffman on 5/7/19.
//  Copyright © 2019 Create. All rights reserved.
//

import MessageKit

struct Message : MessageType {
    
    var sender: Sender
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
    var content: String
}
