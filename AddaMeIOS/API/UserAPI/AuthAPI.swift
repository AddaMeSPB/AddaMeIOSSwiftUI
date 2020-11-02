//
//  UesrAPI.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 20.08.2020.
//

import Foundation
import Pyramid

enum AuthAPI {
    case login(login: LoginAndVerificationResponse)
    case verification(verificationResponse: LoginAndVerificationResponse)
}

extension AuthAPI: APIConfiguration {
    var pathPrefix: String {
        return "auth/"
    }
    
    var path: String {
        return pathPrefix + {
            switch self {
            case .login: return "login"
            case .verification: return "verify_sms"
            }
        }()
    }
    
    var baseURL: URL { EnvironmentKeys.rootURL }
    
    var method: HTTPMethod {
        switch self {
        case .login, .verification: return .post
        }
    }
    
    var dataType: DataType {
        switch self {
        case .login(let loginAndVerificationResponse):
            return .requestWithEncodable(encodable: AnyEncodable(loginAndVerificationResponse))
        case .verification(let verificationResponse):
            return .requestWithEncodable(encodable: AnyEncodable(verificationResponse))
        }
    }
    
    var authType: AuthType {
        return .none
    }
    
    var contentType: ContentType? {
        switch self {
        case .login, .verification:
            return .applicationJson
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
}
