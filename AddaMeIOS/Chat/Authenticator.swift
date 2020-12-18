//
//  Authenticator.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 26.08.2020.
//

import Foundation
import Combine
import Pyramid
import SwiftUI

class Authenticator: ObservableObject {

  static let shared = Authenticator()
  let provider = Pyramid()
  var cancellables = Set<AnyCancellable>()
  @AppStorage(AppUserDefaults.Key.isAuthorized.rawValue) var isAuthorized: Bool = false
  
  @AppStorage("tokenExpiredError") var tokenExpiredError: Bool = false
  
  var currentToken: Access? {
    get {
      guard
        let token: Access = KeychainService.loadCodable(for: .token),
        isAuthorized == true else {
        print(#line, "not Authorized Token are missing")
        return nil
      }
      
      return token
      
    } set {
      KeychainService.save(codable: newValue, for: .token)
    }
  }
  
  init() {}
  
  deinit {
    print(#line, "wow dinit called from", self)
  }
  
  private var cancellation: AnyCancellable?
  
  func refreshToken<S: Subject>(using subject: S) where S.Output == RefreshTokenResponse {
    //self.currentToken = Token(isValid: true)
//    let referehTokenInput = RefreshTokenInput(refreshToken: currentToken!.refreshToken)
//    provider.request(
//        with: RefreshTokenAPI.refresh(token: referehTokenInput),
//        scheduler: RunLoop.main,
//        class: RefreshTokenResponse.self
//    )
//    .retry(3)
//    .sink(receiveCompletion: { completionResponse in
//        switch completionResponse {
//        case .failure(let error):
//            print(#line, error)
////                print(#line, error.errorDescription.contains("401"))
//        case .finished:
//            break
//        }
//    }, receiveValue: { res in
//        print(res)
//        KeychainService.save(codable: res, for: .token)
//        subject.send(self.currentToken!)
//    }).store(in: &cancellables)
    
    //        let headers = [
    //            "authorization": "Bearer \(currentToken?.accessToken)",
    //            "Content-Type": "application/json"
    //        ]
    //
    //        let parameters: [String: Any] = [
    //            "refresh_token": currentToken?.refreshToken,
    //        ]
    //
    //        let jsonDecoder: JSONDecoder = .ISO8601JSONDecoder
    //        let url: URL = URL(string: "http://10.0.1.3:8080/v1/auth/refreshToken")!
    //        var request = URLRequest(url: url)
    //        request.httpMethod = "POST"
    //        request.allHTTPHeaderFields = headers
    //
    //        do {
    //            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
    //        } catch let error {
    //            print(error.localizedDescription)
    //        }
    //
    //        URLSession.shared.dataTaskPublisher(for: request)
    //            .sink { com in
    //                print(com)
    //            } receiveValue: { data in
    //                print(#line, data)
    //
    //                do {
    //                    let rtResponse = try JSONDecoder().decode(RefreshTokenResponse.self, from: data.data)
    //
    //
    //                    KeychainService.save(codable: rtResponse, for: .token)
    //
    //                    subject.send(self.currentToken!)
    //                } catch  {
    //                    print(#line, error)
    //                }
    //
    //            }.store(in: &cancellables)
  }
  
  func tokenSubject() -> CurrentValueSubject<Access, Never> {
    return CurrentValueSubject(currentToken!)
  }
  
  func request<D: Decodable, T: Scheduler>(
    with api: APIConfiguration,
    urlSession: URLSession = URLSession.shared,
    jsonDecoder: JSONDecoder = .ISO8601JSONDecoder,
    scheduler: T,
    class type: D.Type,
    result: @escaping VoidResultCompletion
  ) {
    
    cancellation = provider.request(
          with: api,
          scheduler: RunLoop.main,
          class: D.self
    )
    .retry(3)
    .receive(on: RunLoop.main)
    .sink(receiveCompletion: { completionResponse in
        switch completionResponse {
        case .failure(let error):
            print(#line, error)
          
          // if error have 401 then run refresh token 
          
          result(.failure(error))
          return
        case .finished:
            break
        }
    }, receiveValue: { res in
      result(.success(res))
    })
  }
  
  private func refreshToken() {
    // code goes here
  }
}

public typealias VoidResultCompletion = (Result<Decodable, ErrorManager>) -> Void
