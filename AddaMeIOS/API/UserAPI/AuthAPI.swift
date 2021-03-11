//
//  UesrAPI.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 20.08.2020.
//

//import Foundation
//import Pyramid
//
//enum AuthAPI {
//    case login(login: AuthResponse)
//    case verification(verificationResponse: AuthResponse)
//}
//
//extension AuthAPI: APIConfiguration {
//
//    var pathPrefix: String {
//        return "auth/"
//    }
//    
//    var path: String {
//        return pathPrefix + {
//            switch self {
//            case .login: return "login"
//            case .verification: return "verify_sms"
//            }
//        }()
//    }
//    
//    var baseURL: URL { EnvironmentKeys.rootURL }
//    
//    var method: HTTPMethod {
//        switch self {
//        case .login, .verification: return .post
//        }
//    }
//    
//    var dataType: DataType {
//        switch self {
//        case .login(let AuthResponse):
//            return .requestWithEncodable(encodable: AnyEncodable(AuthResponse))
//        case .verification(let verificationResponse):
//            return .requestWithEncodable(encodable: AnyEncodable(verificationResponse))
//        }
//    }
//
//    var contentType: ContentType? {
//        switch self {
//        case .login, .verification:
//            return .applicationJson
//        }
//    }
//      
//}
