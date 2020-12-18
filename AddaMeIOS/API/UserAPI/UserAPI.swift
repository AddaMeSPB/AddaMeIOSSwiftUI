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
  case update(_ user: CurrentUser)
}

extension UserAPI: APIConfiguration, RequiresAuth {
    var pathPrefix: String {
        return "users"
    }
    
    var path: String {
        return pathPrefix + {
            switch self {
            case .me(let usersId): return "/\(usersId)"
            case .update: return ""
            }
        }()
    }
    
    var baseURL: URL { EnvironmentKeys.rootURL }
    
    var method: HTTPMethod {
        switch self {
        case .me: return .get
        case .update: return .put
        }
    }
    
    var dataType: DataType {
        switch self {
        case .me:
          return .requestPlain
        case .update(let user):
          return .requestWithEncodable(encodable: AnyEncodable(user))
        }
    }
    
    var contentType: ContentType? {
        switch self {
        case .me, .update:
            return .applicationJson
        }
    }
    
}

