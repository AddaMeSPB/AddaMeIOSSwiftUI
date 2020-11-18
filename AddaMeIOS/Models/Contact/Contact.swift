//
//  Contact.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 02.09.2020.
//

import Foundation

struct Contact: Codable, Identifiable {

    var id: String?
    var identifier: String
    var phoneNumber: String
    var fullName: String?
    var avatar: String?
    var isRegister: Bool?
    var userId: String?

    var response: Res {
        .init(self)
    }

    init(id: String? = nil,
         identifier: String,
         userId: String? = nil,
         phoneNumber: String,
         fullName: String? = nil,
         avatar: String? = nil,
         isRegister: Bool = false
    ) {
        self.id = id
        self.identifier = identifier
        self.userId = userId
        self.phoneNumber = phoneNumber
        self.fullName = fullName
        self.avatar = avatar
        self.isRegister = isRegister
    }

    struct Res: Codable {
        var id: String?
        var identifier: String
        var phoneNumber: String
        var fullName: String?
        var avatar: String?
        var isRegister: Bool?
        var userId: String

        init(_ contact: Contact) {
            self.id = contact.id
            self.identifier = contact.identifier
            self.userId = contact.userId ?? String.empty
            self.phoneNumber = contact.phoneNumber
            self.fullName = contact.fullName
            self.avatar = contact.avatar
            self.isRegister = contact.isRegister!
            self.userId = contact.userId!
        }

    }

}

extension Contact: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(phoneNumber)
        hasher.combine(avatar)
    }

    static func == (lhs: Contact, rhs: Contact) -> Bool {
        return lhs.phoneNumber == rhs.phoneNumber && lhs.avatar == rhs.avatar
    }
}

extension Contact.Res: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(phoneNumber)
        hasher.combine(avatar)
    }

    static func == (lhs: Contact.Res, rhs: Contact.Res) -> Bool {
        return lhs.phoneNumber == rhs.phoneNumber && lhs.avatar == rhs.avatar
    }
}


struct CreateContact: Codable {
  var items: [Contact]
}
