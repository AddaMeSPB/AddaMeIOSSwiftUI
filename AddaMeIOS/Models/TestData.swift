//
//  Data.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 26.08.2020.
//

import UIKit
import SwiftUI
import CoreLocation

struct EventStaticData: Codable {
    let items: [Item]
    let metadata: Metadata
    
    // MARK: - Item
    struct Item: Codable, Identifiable {
        let categories: String
        let id, ownerId, name: String
        let conversationsId, imageURL: String?
        let duration: Int
        let createdAt: String
        let updatedAt: String
        let deletedAt: String?
    }

    // MARK: - Metadata
    struct Metadata: Codable {
        let per, total, page: Int
    }

}



let eventData: EventResponse = load("eventResponseData.json")

func load<T: Decodable>(_ filename: String) -> T {
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}
