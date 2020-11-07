//
//  EventPlace.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 06.11.2020.
//

import Foundation
import MapKit

//struct GeoLocation: Hashable, Codable, Identifiable, Comparable {
//  var id: String?
//  var addressName: String
//  var type: GeoType
//  var coordinates: [Double]
//  var eventId: String
//  var createdAt, updatedAt: Date?
//
//  static func == (lhs: GeoLocation, rhs: GeoLocation) -> Bool {
//    lhs.id == rhs.id
//  }
//
//  static func < (lhs: GeoLocation, rhs: GeoLocation) -> Bool {
//    guard let lhsDate = lhs.createdAt, let rhsDate = rhs.createdAt else { return false }
//    return lhsDate < rhsDate
//  }
//
//  func checkPoint() -> CheckPoint {
//    return CheckPoint(geo: self)
//  }
//}

final class EventPlace: NSObject, Encodable , Decodable, Identifiable {
  
  var id: String?
  var addressName: String
  var image: String
  var details: String
  var sponsored: Bool? = false
  var overlay: Bool? = false
  var coordinates: [Double]
  var regionRadius: CLLocationDistance = 1000
  
  init(id: String? = nil, addressName: String, coordinates: [Double], image: String, sponsored: Bool = false, overlay: Bool = false, details: String) {
          self.addressName = addressName
          self.coordinates = coordinates
          self.image = image
          self.sponsored = sponsored
          self.overlay = overlay
          self.details = details
      }
  
  static var defualtInit: Self {
    .init(id: ObjectId.shared.generate(), addressName: "", coordinates: [90, -180], image: "person.fill", sponsored: true, overlay: true, details: "")
  }
}

extension EventPlace: MKAnnotation {
  var coordinate: CLLocationCoordinate2D { location.coordinate }
  var title: String? { addressName }
  var location: CLLocation {
      CLLocation(latitude: coordinates[0], longitude: coordinates[1])
  }
  
  var region: MKCoordinateRegion {
    MKCoordinateRegion(
      center: location.coordinate,
      latitudinalMeters: regionRadius,
      longitudinalMeters: regionRadius
    )
  }
}

extension CLLocation {
  var double: [Double] {
    return [self.coordinate.latitude, self.coordinate.longitude]
  }
}
