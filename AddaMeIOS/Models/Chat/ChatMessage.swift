//
//  ChatMessage.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 28.09.2020.
//

import Foundation

struct ChatMessage: Codable, Identifiable, Hashable {
    var id: String?
    var conversationId: String
    var sender: CurrentUser
    var recipient: CurrentUser?
    var messageBody: String
    var messageType: MessageType
    
//    enum CodingKeys: String, CodingKey {
//        case id, sender
//        case messageType = "message_type"
//        case conversationID = "conversation_id"
//        case messageBody = "message_body"
//        case updatedAt = "updated_at"
//        case createdAt = "created_at"
//    }
//    
    var createdAt: Date?
    var updatedAt: Date?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(messageBody)
    }
}

enum MessageType: String, Codable {
    case text, image, audio, video
}
