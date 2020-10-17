//
//  Conversation.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 05.09.2020.
//

import Foundation

struct Conversation: Codable, Hashable, Identifiable {

    let id, title: String
    let members: [CurrentUser]?
    let admins: [CurrentUser]?
    let lastMessage: ChatMessageResponse.Item?
    let createdAt: Date
    let updatedAt: Date

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Conversation, rhs: Conversation) -> Bool {
        lhs.id == rhs.id
    }
}

struct ConversationResponse: Codable {
    
    let items: [Item]
    let metadata: Metadata

    struct Item: Codable, Hashable, Identifiable {
        internal init(id: String, title: String, members: [CurrentUser], admins: [CurrentUser], lastMessage: ChatMessageResponse.Item?, createdAt: Date, updatedAt: Date) {
            self.id = id
            self.title = title
            self.members = members
            self.admins = admins
            self.lastMessage = lastMessage
            self.createdAt = createdAt
            self.updatedAt = updatedAt
        }
        
        init(_ conversation: Conversation) {
            self.id = conversation.id
            self.title = conversation.title
            self.members = conversation.members
            self.admins = conversation.admins
            self.lastMessage = conversation.lastMessage
            self.createdAt = conversation.createdAt
            self.updatedAt = conversation.updatedAt
        }
        
        var wSconversation: Conversation {
            .init(id: id, title: title, members: nil, admins: nil, lastMessage: nil, createdAt: Date(), updatedAt: Date())
        }
        
        let id, title: String
        let members: [CurrentUser]?
        let admins: [CurrentUser]?
        let lastMessage: ChatMessageResponse.Item?
        
        let createdAt, updatedAt: Date

        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }

        static func == (lhs: Item, rhs: Item) -> Bool {
            lhs.id == rhs.id
        }
    }
    
}

