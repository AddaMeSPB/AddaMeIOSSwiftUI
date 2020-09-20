//
//  Event.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 26.08.2020.
//

import SwiftUI
import CoreLocation

struct Event: Hashable, Codable, Identifiable {
    var id: String?
    var conversationsId: String?
    var name: String
    var imageUrl: String?
    var duration: Int
    var categories: String
    var ownerID: String?
    var createdAt: String?
    var updatedAt: String?
    
    
    struct Response {
        var id: String?
        var conversationsId: String?
        var name: String
        var imageUrl: String?
        var duration: Int
        var categories: String
        var geoLocations: [GeoLocation]
        var ownerID: String?
        var createdAt: String?
        var updatedAt: String?
    }
}
