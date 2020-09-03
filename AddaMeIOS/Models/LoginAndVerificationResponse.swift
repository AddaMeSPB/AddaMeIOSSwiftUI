//
//  LoginAndVerificationResponse.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 24.08.2020.
//

import Foundation

// MARK: - Login and Verification request/response
struct LoginAndVerificationResponse: Codable {
    internal init(
        phoneNumber: String,
        attemptId: String? = nil,
        code: String? = nil,
        isLoggedIn: Bool = false
    ) {
        self.phoneNumber = phoneNumber
        self.attemptId = attemptId
        self.code = code
        self.isLoggedIn = isLoggedIn
    }

    var phoneNumber: String
    var attemptId: String?
    var code: String?
    var isLoggedIn: Bool? = false
}

// MARK: - Login Response
struct LoginRes: Codable {
    let user: CurrentUser
    let access: Access
}

// MARK: - Access
struct Access: Codable {
    let accessToken, refreshToken: String
}

// MARK: - CurrentUser
struct CurrentUser: Codable, Equatable {
    internal init(id: String, avatarUrl: String? = nil, firstName: String? = nil, lastName: String? = nil, phoneNumber: String, email: String? = nil, calendarIds: [String]? = nil, contactIds: [String]? = nil, deviceIds: [String]? = nil, createdAt: String, updatedAt: String, deletedAt: String? = nil) {
        self.id = id
        self.avatarUrl = avatarUrl
        self.firstName = firstName
        self.lastName = lastName
        self.phoneNumber = phoneNumber
        self.email = email
        self.calendarIds = calendarIds
        self.contactIds = contactIds
        self.deviceIds = deviceIds
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.deletedAt = deletedAt
    }
    
    var id: String
    var avatarUrl: String?
    var firstName: String?
    var lastName: String?
    var phoneNumber: String
    var email: String?
    var calendarIds: [String]?
    var contactIds: [String]?
    var deviceIds: [String]?
    var createdAt: String
    var updatedAt: String
    var deletedAt: String?

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

    static func == (lhs: CurrentUser, rhs: CurrentUser) -> Bool {        return
            lhs.id == rhs.id &&
            lhs.avatarUrl == rhs.avatarUrl &&
            lhs.phoneNumber == rhs.phoneNumber &&
            lhs.firstName == rhs.firstName &&
            lhs.lastName == rhs.lastName &&
            lhs.email == rhs.email
    }

}
