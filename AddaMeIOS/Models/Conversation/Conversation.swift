//
//  Conversation.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 05.09.2020.
//

import Foundation


struct CreateConversation: Codable {
  let title: String
  let type: ConversationType
  let opponentPhoneNumber: String
}

enum ConversationType: String, Codable {
  case oneToOne, group
}

struct Conversation: Codable, Hashable, Identifiable {
  
  let id, title: String
  var type: ConversationType
  let members: [CurrentUser]?
  let admins: [CurrentUser]?
  var lastMessage: ChatMessageResponse.Item?
  
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
  
  struct Item: Codable, Hashable, Identifiable, Comparable {
     init(id: String, title: String, type: ConversationType, members: [CurrentUser], admins: [CurrentUser], lastMessage: ChatMessageResponse.Item?, createdAt: Date, updatedAt: Date) {
      self.id = id
      self.title = title
      self.type = type
      self.members = members
      self.admins = admins
      self.lastMessage = lastMessage
      self.createdAt = createdAt
      self.updatedAt = updatedAt
    }
    
    static var defint: Self {
      .init(id: ObjectId.shared.generate(), title: "defualt", type: .group, members: [], admins: [], lastMessage: nil, createdAt: Date(), updatedAt: Date())
    }
    
    init(_ conversation: Conversation) {
      self.id = conversation.id
      self.title = conversation.title
      self.type = conversation.type
      self.members = conversation.members
      self.admins = conversation.admins
      
      self.lastMessage = conversation.lastMessage
      self.createdAt = conversation.createdAt
      self.updatedAt = conversation.updatedAt
    }
    
    var wSconversation: Conversation {
      .init(id: id, title: title, type: type, members: nil, admins: nil, lastMessage: nil, createdAt: Date(), updatedAt: Date())
    }
    
    let id, title: String
    var type: ConversationType
    let members: [CurrentUser]?
    let admins: [CurrentUser]?
    var lastMessage: ChatMessageResponse.Item?
    
    let createdAt, updatedAt: Date
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(id)
    }
    
    static func == (lhs: Item, rhs: Item) -> Bool {
      lhs.id == rhs.id
    }
    
    static func < (lhs: Item, rhs: Item) -> Bool {
      guard let lhsLstMsg = lhs.lastMessage,   let rhsLstMsg = rhs.lastMessage,
            let lhsDate = lhsLstMsg.updatedAt, let rhsDate = rhsLstMsg.updatedAt
      else { return false }
      return lhsDate > rhsDate
    }
    
  }
  
}


extension ConversationResponse.Item {
    
    func canJoinConversation() -> Bool {
        guard let currentUSER: CurrentUser = KeychainService.loadCodable(for: .currentUser) else {
            return false
        }

        return self.admins!.contains(where: { $0.id == currentUSER.id }) ||
            self.members!.contains(where: { $0.id == currentUSER.id })

    }
  
}
