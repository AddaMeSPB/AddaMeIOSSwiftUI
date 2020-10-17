//
//  RefreshTokenAPI.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 28.08.2020.
//

import Foundation
import Pyramid

struct RefreshTokenResponse: Codable {
    var accessToken: String
    var refreshToken: String
}

struct RefreshTokenInput: Codable {
    var refreshToken: String
}

enum RefreshTokenAPI {
    case refresh(token: RefreshTokenInput)
}

extension RefreshTokenAPI: APIConfiguration {
    var path: String {
        return pathPrefix + {
            switch self {
            case .refresh:
                return "/refreshToken"
            }
        }()
    }
    
    var baseURL: URL {
        return URL(string:"http://10.0.1.3:8080/v1")! //serverURL
    }
    
    var method: HTTPMethod {
        switch self {
        case .refresh: return .post
        }
    }
    
    var dataType: DataType {
        switch self {
        case .refresh(let rToken):
            return .requestWithEncodable(encodable: AnyEncodable(rToken))
        }
    }
    
    var authType: AuthType {
        return .bearer(token:
            Authenticator.shared.currentToken?.accessToken ?? ""
        )
    }
    
    var pathPrefix: String {
        return "auth/"
    }
    
    var contentType: ContentType? {
        switch self {
        case .refresh:
            return .applicationJson
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
}
