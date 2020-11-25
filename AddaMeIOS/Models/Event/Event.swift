//
//  Event.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 26.08.2020.
//

import SwiftUI
import CoreLocation
import MapKit

final class Event: NSObject, Codable, Identifiable {
  init(id: String? = nil, name: String, details: String? = nil, imageUrl: String? = nil, duration: Int, categories: String, isActive: Bool, addressName: String, type: GeoType = .Point, sponsored: Bool? = false, overlay: Bool? = false, coordinates: [Double], regionRadius: CLLocationDistance? = 1000, createdAt: Date? = nil, updatedAt: Date? = nil) {
    self.id = id
    self.name = name
    self.details = details
    self.imageUrl = imageUrl
    self.duration = duration
    self.categories = categories
    self.isActive = isActive
    self.addressName = addressName
    self.type = type
    self.sponsored = sponsored
    self.overlay = overlay
    self.coordinates = coordinates
    self.regionRadius = regionRadius
    self.createdAt = createdAt
    self.updatedAt = updatedAt
  }
  
  var id: String?
  var name: String
  var details: String?
  var imageUrl: String?
  var duration: Int
  var categories: String
  var isActive: Bool
  
  var addressName: String
  var type: GeoType = .Point
  var sponsored: Bool? = false
  var overlay: Bool? = false
  var coordinates: [Double]
  var regionRadius: CLLocationDistance? = 1000
  
  var createdAt: Date?
  var updatedAt: Date?
  
  static func == (lhs: Event, rhs: Event) -> Bool {
    lhs.id == rhs.id
  }
}

// MARK: - EventResponse
struct EventResponse: Codable {
  let items: [Item]
  let metadata: Metadata
  
  // MARK: - Item
  
  class Item: NSObject, Codable, Identifiable {
    
    required init(id: String, name: String, categories: String, imageUrl: String? = nil, duration: Int, isActive: Bool, addressName: String, details: String? = nil, type: String, sponsored: Bool, overlay: Bool, coordinates: [Double], regionRadius: CLLocationDistance? = 1000, createdAt: Date, updatedAt: Date) {
      self._id = id
      self.name = name
      self.categories = categories
      self.imageUrl = imageUrl
      self.duration = duration
      self.isActive = isActive
      self.addressName = addressName
      self.details = details
      self.type = type
      self.sponsored = sponsored
      self.overlay = overlay
      self.coordinates = coordinates
      self.regionRadius = regionRadius
      self.createdAt = createdAt
      self.updatedAt = updatedAt
    }
    
    static var defint: EventResponse.Item {
      .init(id: "", name: "", categories: "", duration: 99, isActive: false, addressName: "", type: "Point", sponsored: false, overlay: false, coordinates: [9.9, 8.0], createdAt: Date(), updatedAt: Date())
    }
    
    var _id, name, categories: String
    var imageUrl: String?
    var duration: Int
    var isActive: Bool
    var addressName: String
    var details: String?
    var type: String
    var sponsored: Bool
    var overlay: Bool
    var coordinates: [Double]
    var regionRadius: CLLocationDistance? = 1000
    
    var createdAt: Date
    var updatedAt: Date
  }
  
}

//extension EventResponse.Item: Equatable, Hashable, Comparable {
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(id)
//    }
//    
//    static func == (lhs: EventResponse.Item, rhs: EventResponse.Item) -> Bool {
//      (lhs.hashValue != 0) && (rhs.hashValue != 0)
//    }
//    
//    static func < (lhs: EventResponse.Item, rhs: EventResponse.Item) -> Bool {
//      return lhs.createdAt > rhs.createdAt
//    }
//}

// MARK: - Metadata
struct Metadata: Codable {
  let per, total, page: Int
}

extension EventResponse.Item: MKAnnotation  {
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
  
  var doubleToCoordinate: CLLocation {
    return CLLocation.init(latitude: coordinates[0], longitude: coordinates[1])
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
