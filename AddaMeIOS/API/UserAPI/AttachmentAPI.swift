//
//  AttachmentAPI.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 19.11.2020.
//

//import Foundation
//import Pyramid
//
//enum AttachmentAPI {
//    case create(_ attachment: Attachment)
//}
//
//extension AttachmentAPI: APIConfiguration, RequiresAuth {
//    var pathPrefix: String {
//        return "attachments"
//    }
//    
//    var path: String {
//        return pathPrefix + {
//            switch self {
//            case .create: return ""
//            }
//        }()
//    }
//    
//    var baseURL: URL { EnvironmentKeys.rootURL }
//    
//    var method: HTTPMethod {
//        switch self {
//        case .create: return .post
//        }
//    }
//    
//    var dataType: DataType {
//        switch self {
//        case .create(let attachment):
//          return .requestWithEncodable(encodable: AnyEncodable(attachment))
//        }
//    }
//    
//    var contentType: ContentType? {
//        switch self {
//        case .create:
//            return .applicationJson
//        }
//    }
//    
//    var headers: [String : String]? {
//        return nil
//    }
//    
//}
//
