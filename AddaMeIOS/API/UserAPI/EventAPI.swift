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
    case events
}

extension EventAPI: APIConfiguration {
    var path: String {
        return pathPrefix + {
            switch self {
            case .events:
                return "/events"
            }
        }()
    }
    
    var baseURL: URL {
        return URL(string:"http://10.0.1.3:8080/v1")! //serverURL
    }
    
    var method: HTTPMethod {
        switch self {
        case .events: return .get
        }
    }
    
    var dataType: DataType {
        switch self {
        case .events: return .requestPlain
        }
    }
    
    var authType: AuthType {
        return .bearer(token:
            Authenticator.shared.currentToken?.accessToken ?? ""
        )
    }
    
    var pathPrefix: String {
        return ""
    }
    
    var contentType: ContentType? {
        switch self {
        case .events:
            return .applicationJson
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
}
