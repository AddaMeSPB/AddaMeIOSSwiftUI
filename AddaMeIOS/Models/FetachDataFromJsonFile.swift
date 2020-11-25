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

let demoContacts: [Contact] = load("contacts.json")
let eventData: [EventResponse.Item] = load("eventResponseData.json")
let chatDemoData: [ChatMessageResponse.Item] = load("chatResponseData.json")
let conversationData: [ConversationResponse.Item] = load("conversationResponseData.json")

// will use featch demo data
//func load<T: Decodable>() -> T  {
//  let sections = Bundle.main.decode([T].self, from: "menu.json")
//  self.sections = sections
//  self.representativeSample = [sections[0].items[0], sections[1].items[2], sections[2].items[2]]
//}

func load<T: Decodable>(_ filename: String) -> T {
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("\(#line) Couldn't find \(filename) in main bundle.")
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
      fatalError("\(#line) Couldn't load \(filename) from main bundle:\n\(error)")
    }
    
    do {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("\(#line) Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}
