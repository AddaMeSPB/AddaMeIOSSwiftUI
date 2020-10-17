//
//  MessageAPI.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 02.10.2020.
//

import Foundation
import Pyramid
import Combine

enum MessageAPI {
    case list(_ query: QueryItem, _ conversationId: String)
}

extension MessageAPI: APIConfiguration {
    
    var pathPrefix: String {
        return "/messages"
    }
    
    var path: String {
        return pathPrefix + {
            switch self {
            case .list(_, let conversationsId):
                return "/by/conversations/\(conversationsId)"
            }
        }()
    }
    
    var baseURL: URL {
        return URL(string:"http://10.0.1.3:6060/v1")!
    }
    
    var method: HTTPMethod {
        switch self {
        case .list: return .get
        }
    }
    
    var dataType: DataType {
        switch self {
        case .list(let query, _):
            return .requestParameters(parameters: [
                query.page: query.pageNumber,
                query.per: query.pageNumber
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
        case .list:
            return .applicationJson
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
}
