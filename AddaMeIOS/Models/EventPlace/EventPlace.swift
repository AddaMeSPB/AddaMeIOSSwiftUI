//
//  GeoLocation.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 20.09.2020.
//

import Foundation
import MapKit

final class EventPlace: NSObject, Encodable , Decodable, Identifiable {
  
  var id: String?
  var eventId: String
  var addressName: String
  var image: String?
  var details: String?
  var type: GeoType = .Point
  var sponsored: Bool? = false
  var overlay: Bool? = false
  var coordinates: [Double]
  var regionRadius: CLLocationDistance? = 1000
  var createdAt, updatedAt: Date?
  
  init(id: String? = nil, eventId: String, addressName: String, coordinates: [Double], image: String? = "person.fill", sponsored: Bool = false, overlay: Bool = false, details: String? = nil, type: GeoType = .Point) {
    self.id = id
    self.eventId = eventId
    self.addressName = addressName
    self.coordinates = coordinates
    self.image = image
    self.sponsored = sponsored
    self.overlay = overlay
    self.details = details
    self.type = type
  }
  
  static var defualtInit: Self {
    .init(id: ObjectId.shared.generate(), eventId: ObjectId.shared.generate(), addressName: "", coordinates: [+60.02055149, +30.38782751], image: "person.fill", sponsored: true, overlay: true, details: "")
  }
    
  static func == (lhs: EventPlace, rhs: EventPlace) -> Bool {
    lhs.id == rhs.id
  }
  
  static func < (lhs: EventPlace, rhs: EventPlace) -> Bool {
    guard let lhsDate = lhs.createdAt, let rhsDate = rhs.createdAt else { return false }
    return lhsDate < rhsDate
  }
  
}

extension EventPlace: MKAnnotation  {
  var coordinate: CLLocationCoordinate2D { location.coordinate }
  var title: String? { addressName }
  var location: CLLocation {
    CLLocation(latitude: coordinates[0], longitude: coordinates[1])
  }
  
  var region: MKCoordinateRegion {
    MKCoordinateRegion(
      center: location.coordinate,
      latitudinalMeters: regionRadius ?? 1000,
      longitudinalMeters: regionRadius ?? 1000
    )
  }
  
  var coordinateMongo: CLLocationCoordinate2D {
    return CLLocationCoordinate2D(latitude: self.coordinate.longitude, longitude: self.coordinate.latitude)
  }
  
  var coordinatesMongoDouble: [Double] {
    return [coordinates[1], coordinates[0]]
  }
  
  func distance(_ currentCLLocation: CLLocation) {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      currentCLLocation.distance(from: self.location)
    }
  }
  
}

extension CLLocation {
  var double: [Double] {
    return [self.coordinate.latitude, self.coordinate.longitude]
  }
}

struct EventPlaceResponse: Hashable, Codable, Identifiable {
  let id, eventId, addressName, type: String
  let image, details: String?
  let sponsored, overlay: Bool?
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
