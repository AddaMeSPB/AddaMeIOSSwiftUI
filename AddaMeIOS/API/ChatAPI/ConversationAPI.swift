//
//  ConversationAPI.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 14.10.2020.
//

//import Foundation
//import Pyramid
//import Combine
//
//struct AddUser: Codable {
//    let conversationsId: String
//    let usersId: String
//}
//
//enum ConversationAPI {
//    case list(_ query: QueryItem)
//    case addUserToConversation(_ addUser: AddUser)
//    case create(_ createConversation: CreateConversation)
//    case find(conversationsId: String)
//}
//
//extension ConversationAPI: APIConfiguration, RequiresAuth {
//    
//    var pathPrefix: String {
//        return "/conversations"
//    }
//    
//    var path: String {
//        return pathPrefix + {
//            switch self {
//            case .create: return String.empty
//            case .addUserToConversation(let addUser):
//                return "/\(addUser.conversationsId)/users/\(addUser.usersId)"
//            case .list: return String.empty
//            case .find(let conversationsId): return "/\(conversationsId)"
//            }
//        }()
//    }
//    
//    var baseURL: URL { EnvironmentKeys.rootURL } // URL(string: "http://10.0.1.3:6060/v1")!
//    
//    var method: HTTPMethod {
//        switch self {
//        case .create, .addUserToConversation: return .post
//        case .list, .find: return .get
//        }
//    }
//    
//    var dataType: DataType {
//        switch self {
//        case .create(let createConversation):
//        return .requestWithEncodable(encodable: AnyEncodable(createConversation))
//        case .addUserToConversation(let addUser):
//            return .requestWithEncodable(encodable: AnyEncodable(addUser))
//        case .list(let query):
//            return .requestParameters(parameters: [
//                query.page: query.pageNumber,
//                query.per: query.perSize
//            ])
//        case .find: return .requestPlain
//        }
//    }
//
//    var contentType: ContentType? {
//        switch self {
//        case .create, .addUserToConversation, .list, .find:
//            return .applicationJson
//        }
//    }
//    
//}
