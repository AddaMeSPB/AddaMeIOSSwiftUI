//
//  Attachment.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 19.11.2020.
//

import Foundation

struct Attachment: Codable {
  enum AttachmentType: String, Codable {
    case file, image, audio, video
  }

  internal init(id: String? = nil, type: AttachmentType, userId: String, imageUrlString: String? = nil, audioUrlString: String? = nil, videoUrlString: String? = nil, fileUrlString: String? = nil, createdAt: Date? = nil, updatedAt: Date? = nil) {
    self.id = id
    self.type = type
    self.userId = userId
    self.imageUrlString = imageUrlString
    self.audioUrlString = audioUrlString
    self.videoUrlString = videoUrlString
    self.fileUrlString = fileUrlString
    self.createdAt = createdAt
    self.updatedAt = updatedAt
  }
  
  var id: String?
  var type: AttachmentType
  var userId: String
  var imageUrlString: String?
  var audioUrlString: String?
  var videoUrlString: String?
  var fileUrlString: String?
  var createdAt, updatedAt: Date?
  
  static func < (lhs: Attachment, rhs: Attachment) -> Bool {
    guard let lhsDate = lhs.createdAt, let rhsDate = rhs.createdAt else { return false }
    return lhsDate > rhsDate
  }

}
