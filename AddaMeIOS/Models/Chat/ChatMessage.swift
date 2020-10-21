//
//  ChatMessage.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 28.09.2020.
//

import Foundation

struct ChatMessage: Codable, Identifiable, Hashable {
    
    internal init(id: String? = nil, conversationId: String, messageBody: String, sender: CurrentUser, recipient: CurrentUser? = nil, messageType: MessageType, isRead: Bool, isDelivered: Bool, createdAt: Date? = nil, updatedAt: Date? = nil) {
        self.id = id
        self.conversationId = conversationId
        self.messageBody = messageBody
        self.sender = sender
        self.recipient = recipient
        self.messageType = messageType
        self.isRead = isRead
        self.isDelivered = isDelivered
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    var id: String?
    var conversationId, messageBody: String
    var sender: CurrentUser
    var recipient: CurrentUser?
    var messageType: MessageType
    var isRead, isDelivered: Bool

    var createdAt, updatedAt: Date?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(messageBody)
    }
    
    var messageResponse: ChatMessageResponse.Item {
        .init(id: id, conversationId: conversationId, messageBody: messageBody, sender: sender, recipient: recipient, messageType: messageType, isRead: isRead, isDelivered: isDelivered, createdAt: createdAt, updatedAt: updatedAt)
    }
    
    init(_ chatMessage: ChatMessageResponse.Item) {
        self.id = chatMessage.id
        self.conversationId = chatMessage.conversationId
        self.messageBody = chatMessage.messageBody
        self.sender = chatMessage.sender
        self.recipient = chatMessage.recipient
        self.messageType = chatMessage.messageType
        self.isRead = chatMessage.isRead
        self.isDelivered = chatMessage.isDelivered
        self.createdAt = chatMessage.createdAt
        self.updatedAt = chatMessage.updatedAt
    }
}

struct ChatMessageResponse: Codable {
    let items: [Item]
    let metadata: Metadata
    
    struct Item: Codable, Identifiable, Hashable, Comparable {
        internal init(id: String? = nil, conversationId: String, messageBody: String, sender: CurrentUser, recipient: CurrentUser? = nil, messageType: MessageType, isRead: Bool, isDelivered: Bool, createdAt: Date? = nil, updatedAt: Date? = nil) {
            self.id = id
            self.conversationId = conversationId
            self.messageBody = messageBody
            self.sender = sender
            self.recipient = recipient
            self.messageType = messageType
            self.isRead = isRead
            self.isDelivered = isDelivered
            self.createdAt = createdAt
            self.updatedAt = updatedAt
        }
        
        init(_ chatMessage: ChatMessage) {
            self.id = chatMessage.id
            self.conversationId = chatMessage.conversationId
            self.messageBody = chatMessage.messageBody
            self.sender = chatMessage.sender
            self.recipient = chatMessage.recipient
            self.messageType = chatMessage.messageType
            self.isRead = chatMessage.isRead
            self.isDelivered = chatMessage.isDelivered
            self.createdAt = chatMessage.createdAt
            self.updatedAt = chatMessage.updatedAt
        }
        
        var wSchatMessage: ChatMessage {
            .init(id: id, conversationId: conversationId, messageBody: messageBody, sender: sender, recipient: recipient, messageType: messageType, isRead: isRead, isDelivered: isDelivered, createdAt: createdAt, updatedAt: updatedAt)
        }
        
        var id: String?
        var conversationId, messageBody: String
        var sender: CurrentUser
        var recipient: CurrentUser?
        var messageType: MessageType
        var isRead, isDelivered: Bool
        var createdAt, updatedAt: Date?

        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }

        static func == (lhs: Item, rhs: Item) -> Bool {
            lhs.id == rhs.id
        }
        
        static func < (lhs: Item, rhs: Item) -> Bool {
            guard let lhsDate = lhs.createdAt, let rhsDate = rhs.createdAt else { return false }
            return lhsDate < rhsDate
        }
        
    }
}

enum MessageType: String, Codable {
    case text, image, audio, video
}

