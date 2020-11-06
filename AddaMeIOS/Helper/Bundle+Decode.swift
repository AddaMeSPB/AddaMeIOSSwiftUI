//
//  Bundle+Decode.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 06.11.2020.
//

import UIKit

extension Bundle {
    func decode<T: Decodable>(_ type: T.Type, from file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }

        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }

        let decoder = JSONDecoder()

        guard let loaded = try? decoder.decode(T.self, from: data) else {
            fatalError("Failed to decode \(file) from bundle.")
        }

        return loaded
    }
}

// will use featch demo data
//func load() {
//    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//        let sections = Bundle.main.decode([MenuSection].self, from: "menu.json")
//        self.sections = sections
//        self.representativeSample = [sections[0].items[0], sections[1].items[2], sections[2].items[2]]
//    }
//}

