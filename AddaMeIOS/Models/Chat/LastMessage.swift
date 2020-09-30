//
//  LastMessage.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 28.09.2020.
//

import Foundation

struct LastMessage: Codable, Identifiable, Hashable {
    var id, senderID: String
    var phoneNumber: String
    var firstName, lastName: String?
    var avatar, messageBody: String
    var totalUnreadMessages: Int
    var timestamp: Int

    enum CodingKeys: String, CodingKey {
        case senderID = "sender_id"
        case phoneNumber = "phone_number"
        case firstName = "first_name"
        case lastName = "last_name"
        case messageBody = "message_body"
        case totalUnreadMessages = "total_unread_messages"
        case id, avatar, timestamp
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(phoneNumber)
    }
}
