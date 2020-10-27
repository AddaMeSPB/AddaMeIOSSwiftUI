//
//  Data.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 26.08.2020.
//

import Foundation
import UIKit
import SwiftUI
import CoreLocation

let eventData: [EventResponse.Item] = load("eventResponseData.json")
let chatData: [ChatMessageResponse.Item] = load("chatResponseData.json")
let conversationData: [ConversationResponse.Item] = load("conversationResponseData.json")

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
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}
