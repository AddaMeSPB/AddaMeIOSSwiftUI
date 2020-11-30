//
//  DeviceAPI.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 29.11.2020.
//

import Foundation
import Pyramid
import Combine

enum DeviceAPI {
  case createOrUpdate(_ device: Device)
}

extension DeviceAPI: APIConfiguration {
  var pathPrefix: String {
      return "/devices"
  }
  
  var path: String {
      return pathPrefix + {
          switch self {
          case .createOrUpdate:
              return ""
          }
      }()
  }
  
  var baseURL: URL { EnvironmentKeys.rootURL }
  
  
  var method: HTTPMethod {
      switch self {
      case .createOrUpdate: return .post
      }
  }
  
  var dataType: DataType {
      switch self {
      case .createOrUpdate(let device):
        return .requestWithEncodable(encodable: AnyEncodable(device))
      }
  }
  
  var authType: AuthType {
      return .bearer(token:
          Authenticator.shared.currentToken?.accessToken ?? String.empty
      )
  }
  
  var contentType: ContentType? {
      switch self {
      case .createOrUpdate:
          return .applicationJson
      }
  }
  
  var headers: [String : String]? {
      return nil
  }
}

struct Device: Codable {
  var id: String?
  var ownerId: String
  var name: String
  var model: String?
  var osVersion: String?
  var token: String
  var voipToken: String
  var createAt, updatedAt: String?
}
