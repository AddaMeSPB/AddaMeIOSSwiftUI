//
//  EventAPI.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 28.08.2020.
//

import Foundation
import Pyramid
import Combine

enum EventAPI {
    case events(_ query: EventQueryItem)
    case create(_ event: Event)
    case myEvents(_ query: QueryItem )
}

extension RequiresAuth {

  var headers: [String: String]? {
    return nil
//    ["Authorization": "Bearer \(Authenticator.shared.currentToken?.accessToken ?? String.empty)"]
  }
  
  var authType: AuthType {
    return .bearer(
      token: Authenticator.shared.currentToken?.accessToken ?? String.empty
    )
  }
}

///planets?page=2&per=5
struct QueryItem: Codable {
    var page: String
    var pageNumber: String
    var per: String
    var perSize: String
}

struct EventQueryItem: Codable {
  var page: String
  var pageNumber: String
  var per: String
  var perSize: String
  var lat: String
  var long: String
  var distance: String
  var latValue: String
  var longValue: String
  var distanceValue: String
  
}

extension EventAPI: APIConfiguration, RequiresAuth { // APIOperation

    var baseURL: URL { EnvironmentKeys.rootURL }
    
    var pathPrefix: String {
        return "/events"
    }

    var path: String {
        return pathPrefix + {
            switch self {
            case .create: return String.empty
            case .events: return String.empty
            case .myEvents: return "/my"
            }
        }()
    }
    
    var method: HTTPMethod {
        switch self {
        case .create: return .post
        case .events, .myEvents: return .get
        }
    }
    
    var dataType: DataType {
        switch self {
        case .create(let event):
            return .requestWithEncodable(encodable: AnyEncodable(event))
        case .events(let eventQuery):
             return .requestParameters(parameters: [
              eventQuery.page: eventQuery.pageNumber,
              eventQuery.per: eventQuery.perSize,
              eventQuery.lat: eventQuery.latValue,
              eventQuery.long: eventQuery.longValue,
              eventQuery.distance: eventQuery.distanceValue,
             ])
        case .myEvents(let query):
            return .requestParameters(parameters: [
                query.page: query.pageNumber,
                query.per: query.perSize
            ])
        }
    }

    var contentType: ContentType? {
        switch self {
        case .create, .events, .myEvents:
            return .applicationJson
        }
    }
    
}
