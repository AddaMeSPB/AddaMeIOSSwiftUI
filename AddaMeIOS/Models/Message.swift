//
//  Message.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 05.09.2020.
//

import Foundation

struct Message {
    let id: String
    
    let conversationsId: String
    let channelId: String
    
    let senderId: String
    let recipientId: String
    
    let content: String
    let messageType: String
    
    let created_at: String?
    let updated_at: String?
}

enum MessageType: String {
    case text, image, audio, video
}
