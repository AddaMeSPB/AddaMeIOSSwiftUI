//
//  CurrentUser.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 28.09.2020.
//

import Foundation

// MARK: - CurrentUser
struct CurrentUser: Codable, Equatable, Hashable, Identifiable {
  
  internal init(id: String, phoneNumber: String, avatarUrl: String? = nil, firstName: String? = nil, lastName: String? = nil, email: String? = nil, contactIDs: [String]? = nil, deviceIDs: [String]? = nil, attachments: [Attachment]? = nil, createdAt: Date, updatedAt: Date) {
    self.id = id
    self.phoneNumber = phoneNumber
    self.avatarUrl = avatarUrl
    self.firstName = firstName
    self.lastName = lastName
    self.email = email
    self.contactIDs = contactIDs
    self.deviceIDs = deviceIDs
    self.attachments = attachments
    self.createdAt = createdAt
    self.updatedAt = updatedAt
  }
  
  static var dInit: Self {
    .init(id: UUID().uuidString, phoneNumber: "+79212121211", avatarUrl: nil, firstName: nil, lastName: nil, email: nil, contactIDs: nil, deviceIDs: nil, attachments: nil, createdAt: Date(), updatedAt: Date())
  }
  
  var id, phoneNumber: String
  var avatarUrl, firstName, lastName, email: String?
  var contactIDs, deviceIDs: [String]?
  var attachments: [Attachment]?
  var createdAt, updatedAt: Date
  
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
  
  func lastAvatarURLString() -> String?  {
    guard let atchmts = self.attachments  else {
      return nil
    }
    print(#line, atchmts)
    return atchmts.filter { $0.type == .image }.last?.imageUrlString
  }
  
  var imageURL: URL {
    let defaultImageURL: URL = AssetExtractor.createLocalUrl(forImageNamed: "Avatar")!
    
    print(#line, lastAvatarURLString() == nil ? defaultImageURL : URL(string: lastAvatarURLString()!)!)
    
    return lastAvatarURLString() == nil ? defaultImageURL : URL(string: lastAvatarURLString()!)!
    
  }

}
