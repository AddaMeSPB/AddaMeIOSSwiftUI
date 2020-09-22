//
//  EventAPI.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 28.08.2020.
//

import Foundation
import Pyramid
import Combine



enum EventAPI {
    case events(_ query: QueryItem)
    case create(_ event: Event)
}

//extension RequiresAuth {
////    var header: [String: String] { get }
////    return .bearer(token:
////        Authenticator.shared.currentToken?.accessToken ?? ""
////    )
//    var header: [String: String] {
//        ["Authorization": "Bearer \(Authenticator.shared.currentToken?.accessToken ?? "")"]
//    }
//}

import Foundation

struct QueryItem: Codable {
    var name: String
    var value: String = "1"
}

extension EventAPI: APIConfiguration {
    
    var path: String {
        return pathPrefix + {
            switch self {
            case .create: return ""
            case .events:
                return ""
            }
        }()
    }
    
    var baseURL: URL {
        return URL(string:"http://10.0.1.3:8080/v1")! //serverURL
    }
    
    var method: HTTPMethod {
        switch self {
        case .create: return .post
        case .events: return .get
        }
    }
    
    var dataType: DataType {
        switch self {
        case .create(let event):
            return .requestWithEncodable(encodable: AnyEncodable(event))
        case .events(let query):
            return .requestParameters(parameters: [query.name: query.value])
        }
    }
    
    var authType: AuthType {
        return .bearer(token:
            Authenticator.shared.currentToken?.accessToken ?? ""
        )
    }
    
    var pathPrefix: String {
        return "/events"
    }
    
    var contentType: ContentType? {
        switch self {
        case .create, .events:
            return .applicationJson
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
}
