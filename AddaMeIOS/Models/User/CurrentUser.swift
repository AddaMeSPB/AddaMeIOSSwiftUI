//
//  CurrentUser.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 28.09.2020.
//

import Foundation

// MARK: - CurrentUser
struct CurrentUser: Codable, Equatable, Hashable, Identifiable {
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
    
    var id, phoneNumber: String
    var avatarUrl, firstName, lastName, email: String?
    var contactIDs, deviceIDs: [String]?
    var createdAt, updatedAt: Date
  
  static var dInit: Self {
    .init(id: UUID().uuidString, avatarUrl: nil, firstName: nil, lastName: nil, phoneNumber: "+79212121211", email: nil, contactIDs: nil, deviceIDs: nil, createdAt: Date(), updatedAt: Date())
  }

    var fullName: String {
        var fullName = String.empty
        if let firstN = firstName {
            fullName += "\(firstN) "
        }

        if let lastN = lastName {
            fullName += "\(lastN)"
        }

        if fullName.isEmpty {
            return hideLast4DigitFromPhoneNumber()
        }
        
        return fullName
    }
    
    func hideLast4DigitFromPhoneNumber() -> String {
        guard let currentUSER: CurrentUser = KeychainService.loadCodable(for: .currentUser) else {
            return "SwiftUI preview missing CurrentUser"
        }
        
        let lastFourCharacters = String(self.phoneNumber.suffix(4))
        let phoneNumberWithLastFourHiddenCharcters = self.phoneNumber.replace(target: lastFourCharacters, withString:"****")
        
        return currentUSER.id == self.id ? self.phoneNumber : phoneNumberWithLastFourHiddenCharcters
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
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
