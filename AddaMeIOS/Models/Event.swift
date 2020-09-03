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
    var geoId: String?
    var ownerID: String
    
//    fileprivate var imageName: String
//    fileprivate var coordinates: Coordinates
//    var category: Category
//
//    var locationCoordinate: CLLocationCoordinate2D {
//        CLLocationCoordinate2D(
//            latitude: coordinates.latitude,
//            longitude: coordinates.longitude)
//    }
//
//    enum Category: String, CaseIterable, Codable, Hashable {
//        case featured = "Featured"
//        case lakes = "Lakes"
//        case rivers = "Rivers"
//    }
}

//extension Event {
//    var image: Image {
//        ImageStore.shared.image(name: imageName)
//    }
//}

//struct Coordinates: Hashable, Codable {
//    var latitude: Double
//    var longitude: Double
//}

