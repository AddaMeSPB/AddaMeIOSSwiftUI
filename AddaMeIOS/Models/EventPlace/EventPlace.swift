////
////  GeoLocation.swift
////  AddaMeIOS
////
////  Created by Saroar Khandoker on 20.09.2020.
////
//
//import Foundation
//import MapKit
//
//final class EventPlace: NSObject, Encodable , Decodable, Identifiable {
//  
//  var id: String?
//  var eventId: String
//  var addressName: String
//  var image: String?
//  var details: String?
//  var type: GeoType = .Point
//  var sponsored: Bool? = false
//  var overlay: Bool? = false
//  var coordinates: [Double]
//  var regionRadius: CLLocationDistance? = 1000
//  var createdAt, updatedAt: Date?
//  
//  init(id: String? = nil, eventId: String, addressName: String, coordinates: [Double], image: String? = "person.fill", sponsored: Bool = false, overlay: Bool = false, details: String? = nil, type: GeoType = .Point) {
//    self.id = id
//    self.eventId = eventId
//    self.addressName = addressName
//    self.coordinates = coordinates
//    self.image = image
//    self.sponsored = sponsored
//    self.overlay = overlay
//    self.details = details
//    self.type = type
//  }
//  
//  static var defualtInit: Self {
//    .init(id: ObjectId.shared.generate(), eventId: ObjectId.shared.generate(), addressName: String.empty, coordinates: [+60.02055149, +30.38782751], image: "person.fill", sponsored: true, overlay: true, details: String.empty)
//  }
//    
//  static func == (lhs: EventPlace, rhs: EventPlace) -> Bool {
//    lhs.id == rhs.id
//  }
//  
//  static func < (lhs: EventPlace, rhs: EventPlace) -> Bool {
//    guard let lhsDate = lhs.createdAt, let rhsDate = rhs.createdAt else { return false }
//    return lhsDate < rhsDate
//  }
//  
//}
//
//
//
//struct EventPlaceResponse: Hashable, Codable, Identifiable {
//  let id, eventId, addressName, type: String
//  let image, details: String?
//  let sponsored, overlay: Bool?
//  let coordinates: [Double]
//}
//
