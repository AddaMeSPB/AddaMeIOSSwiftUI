//
//  MessageAPI.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 02.10.2020.
//

//import Foundation
//import Pyramid
//import Combine
//
//enum MessageAPI {
//    case list(_ query: QueryItem, _ conversationId: String)
//}
//
//extension MessageAPI: APIConfiguration, RequiresAuth {
//    
//    var pathPrefix: String {
//        return "/messages"
//    }
//    
//    var path: String {
//        return pathPrefix + {
//            switch self {
//            case .list(_, let conversationsId):
//                return "/by/conversations/\(conversationsId)"
//            }
//        }()
//    }
//    
//    var baseURL: URL { EnvironmentKeys.rootURL }
//    
//    var method: HTTPMethod {
//        switch self {
//        case .list: return .get
//        }
//    }
//    
//    var dataType: DataType {
//        switch self {
//        case .list(let query, _):
//            return .requestParameters(parameters: [
//                query.page: query.pageNumber,
//                query.per: query.perSize
//            ])
//        }
//    }
//
//    var contentType: ContentType? {
//        switch self {
//        case .list:
//            return .applicationJson
//        }
//    }
//
//}
