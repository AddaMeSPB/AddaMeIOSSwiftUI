//
//  Codable+Extension.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 28.09.2020.
//

import Foundation

extension Encodable {
    var jsonData: Data? {
        let encoder = JSONEncoder()
        do {
            return try encoder.encode(self)
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    var jsonString: String? {
        guard let data = self.jsonData else { return nil }
        return String(data: data, encoding: .utf8)
    }
}

extension Decodable {
    static func from(json: String, using encoding: String.Encoding = .utf8) -> Self? {
        guard let data = json.data(using: encoding) else { return nil }
        return Self.from(data: data)
    }
    
    static func from(data: Data) -> Self? {
        do {
            return try JSONDecoder().decode(Self.self, from: data)
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    static func decode(json: String, using usingForWebRtcingEncoding: String.Encoding = .utf8) -> Self? {
        guard let data = json.data(using: usingForWebRtcingEncoding) else { return nil }
        return Self.decode(data: data)
    }
    
    static func decode(data usingForWebRtcingData: Data) -> Self? {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        do {
            return try decoder.decode(Self.self, from: usingForWebRtcingData)
        } catch {
            print(#line, error)
            return nil
        }
    }
}
