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
    var ownerId: String?
    var createdAt: Date?
    var updatedAt: Date?
    
    
    struct Response {
        var id: String?
        var conversationsId: String?
        var name: String
        var imageUrl: String?
        var duration: Int
        var categories: String
        var geoLocations: [GeoLocation]
        var ownerId: String?
        var createdAt: Date
        var updatedAt: Date
    }
}

// MARK: - EventResponse
struct EventResponse: Codable {
    let items: [Item]
    let metadata: Metadata
    
    // MARK: - Item
    struct Item: Codable, Identifiable {
        let categories: String
        let id, ownerID, name: String
        let conversationsID, imageURL: String?
        let duration: Int
        let createdAt: Date
        let updatedAt: Date
    }

    // MARK: - Metadata
    struct Metadata: Codable {
        let per, total, page: Int
    }

}


