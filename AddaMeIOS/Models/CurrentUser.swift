//
//  CurrentUser.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 28.09.2020.
//

import Foundation

// MARK: - CurrentUser
struct CurrentUser: Codable, Equatable {
    internal init(id: String, avatarUrl: String? = nil, firstName: String? = nil, lastName: String? = nil, phoneNumber: String, email: String? = nil, contactIDs: [String]? = nil, deviceIDs: [String]? = nil, createdAt: Date, updatedAt: Date) {
        self.id = id
        self.avatarUrl = avatarUrl
        self.firstName = firstName
        self.lastName = lastName
        self.phoneNumber = phoneNumber
        self.email = email
        self.contactIDs = contactIDs
        self.deviceIDs = deviceIDs
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    var id: String
    var avatarUrl: String?
    var firstName: String?
    var lastName: String?
    var phoneNumber: String
    var email: String?
    var contactIDs: [String]?
    var deviceIDs: [String]?
    var createdAt: Date
    var updatedAt: Date
//
//    enum CodingKeys: String, CodingKey {
//        case id, email
//        case firstName = "first_name"
//        case lastName = "last_name"
//        case phoneNumber = "phone_number"
//        case contactIDs = "contact_ids"
//        case deviceIDs = "device_ids"
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
//    }
//
    var fullName: String {
        var fullName = ""
        if let firstN = firstName {
            fullName += "\(firstN) "
        }

        if let lastN = lastName {
            fullName += "\(lastN)"
        }

        return fullName
    }

    static func == (lhs: CurrentUser, rhs: CurrentUser) -> Bool {
        return
            lhs.id == rhs.id &&
            lhs.avatarUrl == rhs.avatarUrl &&
            lhs.phoneNumber == rhs.phoneNumber &&
            lhs.firstName == rhs.firstName &&
            lhs.lastName == rhs.lastName &&
            lhs.email == rhs.email
    }

}
