//
//  GeoLocation.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 20.09.2020.
//

import Foundation
import SwiftUI

struct GeoLocation: Hashable, Codable, Identifiable, Comparable {
  var id: String?
  var addressName: String
  var type: GeoType
  var coordinates: [Double]
  var eventId: String
  var createdAt, updatedAt: Date?
  
  static func == (lhs: GeoLocation, rhs: GeoLocation) -> Bool {
    lhs.id == rhs.id
  }
  
  static func < (lhs: GeoLocation, rhs: GeoLocation) -> Bool {
    guard let lhsDate = lhs.createdAt, let rhsDate = rhs.createdAt else { return false }
    return lhsDate < rhsDate
  }
  
  func checkPoint() -> CheckPoint {
    return CheckPoint(geo: self)
  }
}

//struct GeoLocation: Codable {
//    let addressName: AddressName
//    let id: String
//    let event: Event
//    let deletedAt: JSONNull?
//    let updatedAt: Date
//    let type: TypeEnum
//    let coordinates: [Double]
//    let createdAt: Date
//}


struct GeoLocationResponse: Hashable, Codable, Identifiable {
  let id, addressName, type, eventId: String
  let coordinates: [Double]
}


enum GeoType: String {
  case Point
  case LineString
  case Polygon
  case MultiPoint
  case MultiLineString
  case MultiPolygon
  case GeometryCollection
}

extension GeoType: Encodable {}
extension GeoType: Decodable {}
