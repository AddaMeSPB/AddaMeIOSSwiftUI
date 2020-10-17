//
//  Authenticator.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 26.08.2020.
//

import Foundation
import Combine
import Pyramid

class Authenticator: ObservableObject {
    static let shared = Authenticator()
    let provider = Pyramid()
    var cancellables = Set<AnyCancellable>()
    
    var currentToken: RefreshTokenResponse? {
        get {
            guard let rToken: RefreshTokenResponse = KeychainService.loadCodable(for: .token) else {
                return nil
            }
            return rToken
        } set {
            KeychainService.save(codable: newValue, for: .token)
        }
    }
    
    init() {}
    
    private var cancellation: AnyCancellable?
    
    func refreshToken<S: Subject>(using subject: S) where S.Output == RefreshTokenResponse {
        //self.currentToken = Token(isValid: true)
        //let referehTokenInput = RefreshTokenInput(refreshToken: currentToken!.refreshToken)
//        provider.request(
//            with: RefreshTokenAPI.refresh(token: referehTokenInput),
//            scheduler: RunLoop.main,
//            class: RefreshTokenResponse.self
//        )
//        .retry(3)
//        .sink(receiveCompletion: { completionResponse in
//            switch completionResponse {
//            case .failure(let error):
//                print(#line, error)
////                print(#line, error.errorDescription.contains("401"))
//            case .finished:
//                break
//            }
//        }, receiveValue: { res in
//            print(res)
//            KeychainService.save(codable: res, for: .token)
//            subject.send(self.currentToken!)
//        }).store(in: &cancellables)
        
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
    
    func tokenSubject() -> CurrentValueSubject<RefreshTokenResponse, Never> {
        return CurrentValueSubject(currentToken!)
    }
}
