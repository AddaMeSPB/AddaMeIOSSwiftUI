//
//  ConversationAPI.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 14.10.2020.
//

import Foundation
import Pyramid
import Combine

struct AddUser: Codable {
    let conversationsId: String
    let usersId: String
}

enum ConversationAPI {
    case list(_ query: QueryItem)
    case addUserToConversation(_ addUser: AddUser)
}

extension ConversationAPI: APIConfiguration {
    
    var pathPrefix: String {
        return "/conversations/"
    }
    
    var path: String {
        return pathPrefix + {
            switch self {
            case .addUserToConversation(let addUser):
                return "\(addUser.conversationsId)/users/\(addUser.usersId)"
            case .list: return ""
            }
        }()
    }
    
    var baseURL: URL { EnvironmentKeys.rootURL } // URL(string: "http://10.0.1.3:6060/v1")!
    
    var method: HTTPMethod {
        switch self {
        case .addUserToConversation: return .post
        case .list: return .get
        }
    }
    
    var dataType: DataType {
        switch self {
        case .addUserToConversation(let addUser):
            return .requestWithEncodable(encodable: AnyEncodable(addUser))
        case .list(let query):
            return .requestParameters(parameters: [
                query.page: query.pageNumber,
                query.per: query.perSize
            ])
        }
    }
    
    var authType: AuthType {
        return .bearer(token:
            Authenticator.shared.currentToken?.accessToken ?? ""
        )
    }
    
    var contentType: ContentType? {
        switch self {
        case .addUserToConversation, .list:
            return .applicationJson
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
}
