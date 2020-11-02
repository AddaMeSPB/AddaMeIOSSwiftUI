//
//  GeoLocationAPI.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 20.09.2020.
//

import Foundation
import Pyramid
import Combine

enum GeoLocationAPI {
    case create(_ event: GeoLocation)
}

extension GeoLocationAPI: APIConfiguration {
    var path: String {
        return pathPrefix + {
            switch self {
            case .create: return "/geolocations"
            }
        }()
    }
    
    var baseURL: URL { EnvironmentKeys.rootURL }
    
    var method: HTTPMethod {
        switch self {
        case .create: return .post
        }
    }
    
    var dataType: DataType {
        switch self {
        case .create(let geolocation):
            return .requestWithEncodable(encodable: AnyEncodable(geolocation))
        }
    }
    
    var authType: AuthType {
        return .bearer(token:
            Authenticator.shared.currentToken?.accessToken ?? ""
        )
    }
    
    var pathPrefix: String {
        return ""
    }
    
    var contentType: ContentType? {
        switch self {
        case .create:
            return .applicationJson
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
}
