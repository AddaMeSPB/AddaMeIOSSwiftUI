//
//  RefreshTokenAPI.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 28.08.2020.
//

//import Foundation
//import Pyramid
//import Combine
//
//struct AuthTokenResponse: Codable {
//    var accessToken: String
//    var refreshToken: String
//}
//
//struct RefreshTokenInput: Codable {
//    var refreshToken: String
//}
//
//enum RefreshTokenAPI {
//    case refresh(token: RefreshTokenInput)
//}
//
//extension RefreshTokenAPI: APIConfiguration, RequiresAuth {
//    var path: String {
//        return pathPrefix + {
//            switch self {
//            case .refresh:
//                return "/refreshToken"
//            }
//        }()
//    }
//    
//    var baseURL: URL { EnvironmentKeys.rootURL }
//    
//    var method: HTTPMethod {
//        switch self {
//        case .refresh: return .post
//        }
//    }
//    
//    var dataType: DataType {
//        switch self {
//        case .refresh(let rToken):
//            return .requestWithEncodable(encodable: AnyEncodable(rToken))
//        }
//    }
//    
//    var pathPrefix: String {
//        return "auth/"
//    }
//    
//    var contentType: ContentType? {
//        switch self {
//        case .refresh:
//            return .applicationJson
//        }
//    }
//
//}
//
//extension APIConfiguration {
//  
//  func fetchRefreshToken() -> Bool {
//    Authenticator.shared.refreshToken()
//    return true
//  }
//}
