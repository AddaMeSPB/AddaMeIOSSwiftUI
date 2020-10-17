//
//  ChatOutGoingEvent.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 29.09.2020.
//

import Foundation

private let jsonEncoder: JSONEncoder = {
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .iso8601
    return encoder
}()

enum ChatOutGoingEvent: Encodable, Decodable {
    
    case message(ChatMessage)
    case connect(Conversation)
    case disconnect(Conversation)
    case notice(String)
    case error(String)
    
    private enum CodingKeys: String, CodingKey {
        case type, conversation, message
    }
    
    enum CodingError: Error {
        case unknownValue
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)
        
        switch type {
        case "message":
            let message = try container.decode(ChatMessage.self, forKey: .message)
            self = .message(message)
        case "connect":
            let connect =  try container.decode(Conversation.self, forKey: .conversation)
            self = .connect(connect)
        case "disconnect":
            let disconnect = try container.decode(Conversation.self, forKey: .conversation)
            self = .disconnect(disconnect)
        case "notice":
            let notice = try container.decode(String.self, forKey: .message)
            self = .notice(notice)
        case "error":
            let error = try container.decode(String.self, forKey: .message)
            self = .error(error)
        default:
            throw CodingError.unknownValue
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var kvc = encoder.container(keyedBy: String.self)
        
        switch self {
        case .connect(let identity):
            try kvc.encode("connect", forKey: "type")
            try kvc.encode(identity, forKey: "conversation")
        case .disconnect(let identity):
            try kvc.encode("disconnect", forKey: "type")
            try kvc.encode(identity, forKey: "conversation")
        case .message(let message):
            try kvc.encode("message", forKey: "type")
            try kvc.encode(message, forKey: "message")
        case .notice(let message):
            try kvc.encode("notice", forKey: "type")
            try kvc.encode(message, forKey: "message")
        case .error(let error):
            try kvc.encode("error", forKey: "type")
            try kvc.encode(error, forKey: "message")
        }
    }
    
}

extension ChatOutGoingEvent {
    var jsonString: String? {
        guard let jsonData = try? jsonEncoder.encode(self) else {
            return nil
        }
        
        guard let jsonString = String(data: jsonData, encoding: .utf8) else {
            return nil
        }
        
        return jsonString
    }
}
