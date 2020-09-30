//
//  GeoLocation.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 20.09.2020.
//

import Foundation
import SwiftUI

struct GeoLocation: Hashable, Codable, Identifiable {
    var id: String?
    var addressName: String
    var type: GeoType
    var coordinates: [Double]
    var eventId: String
}

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

let geoLocation = GeoLocation(addressName: "", type: .Point, coordinates: [02.2, 33.44], eventId: "")
