//
//  ContactAPI.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 13.11.2020.
//

import Foundation
import Pyramid
import Combine

enum ContactAPI {
  case create(contacts: [Contact])
}

extension ContactAPI: APIConfiguration {
  var baseURL: URL { EnvironmentKeys.rootURL }// { URL(string: "http://10.0.1.3:3030/v1")! } //{ EnvironmentKeys.rootURL }
  
  var pathPrefix: String {
      return "/contacts"
  }
  
  var path: String {
      return pathPrefix + {
          switch self {
          case .create: return ""
          }
      }()
  }
  
  
  var method: HTTPMethod {
      switch self {
      case .create: return .post
      }
  }
  
  var dataType: DataType {
      switch self {
      case .create(let contacts):
          return .requestWithEncodable(encodable: AnyEncodable(contacts))
      }
  }
  
  var authType: AuthType {
      return .bearer(token:
          Authenticator.shared.currentToken?.accessToken ?? ""
      )
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
