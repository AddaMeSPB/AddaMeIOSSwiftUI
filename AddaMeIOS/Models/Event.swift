//
//  Event.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 26.08.2020.
//

import SwiftUI
import CoreLocation

struct Event: Hashable, Codable, Identifiable {

    var id: String?
    var name: String
    var imageUrl: String?
    var duration: Int
    var categories: String
    var ownerId: CurrentUser?
    var conversationId: Conversation?
    var isActive: Bool
    var createdAt: Date?
    var updatedAt: Date?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Event, rhs: Event) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - EventResponse
struct EventResponse: Codable {
    let items: [Item]
    let metadata: Metadata
    
    // MARK: - Item

    struct Item: Codable, Identifiable, Hashable {
        
        let id, name, categories: String
        var owner: EventUser
        var conversation: Conversation
        let imageUrl: String?
        let duration: Int
        let isActive: Bool
        let createdAt: Date
        let updatedAt: Date
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
        
        static func == (lhs: EventResponse.Item, rhs: EventResponse.Item) -> Bool {
            lhs.id == rhs.id
        }
    }
}

// MARK: - Metadata
struct Metadata: Codable {
    let per, total, page: Int
}

struct EventUser: Codable, Identifiable {
    let id: String
    let avatarUrl: String?
    let firstName: String?
    let lastName: String?
    let phoneNumber: String
    let email: String?
    let contactIDs: [String]?
    let deviceIDs: [String]?
    let createdAt: Date
    let updatedAt: Date
}
