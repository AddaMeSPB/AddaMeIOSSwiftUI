//
//  UserAPI.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 17.10.2020.
//

import Foundation
import Pyramid

enum UserAPI {
    case me(_ usersId: String)
}

extension UserAPI: APIConfiguration {
    var pathPrefix: String {
        return "users"
    }
    
    var path: String {
        return pathPrefix + {
            switch self {
            case .me(let usersId): return "/\(usersId)"
            }
        }()
    }
    
    var baseURL: URL {
        #if DEBUG
            return URL(string:"http://10.0.1.3:8080/v1")!
        #else
            return URL(string:"https://justcal.me/v1")!
        #endif
    }
    
    var method: HTTPMethod {
        switch self {
        case .me: return .get
        }
    }
    
    var dataType: DataType {
        switch self {
        case .me(let usersId):
            return .requestParameters(
                parameters: ["usersId": usersId]
            )
        }
    }
    
    var authType: AuthType {
        return .bearer(token:
            Authenticator.shared.currentToken?.accessToken ?? ""
        )
    }
    
    var contentType: ContentType? {
        switch self {
        case .me:
            return .applicationJson
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
}

