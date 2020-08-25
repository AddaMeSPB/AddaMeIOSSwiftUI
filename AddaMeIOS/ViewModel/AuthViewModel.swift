//
//  AuthViewModel.swift
//  AddaMeIOS
//
//  Created by Alif on 4/8/20.
//

import Foundation
import Combine
import Pyramid

enum AddaError: Error {
    case guardFail(String)
}

extension AddaError {
    var reason: String {
        switch self {
        case .guardFail(let location):
            return "guard statment fail \(location)"
        }
    }
}

class AuthViewModel: ObservableObject {

    @Published var lAndVRes: LoginAndVerificationResponse?
    @Published var verificationCodeResponse = "" {
        didSet {
            lAndVRes?.code = verificationCodeResponse
            if verificationCodeResponse.count == 6 {
                verification()
            }
        }
    }

    let provider = Pyramid()
    var cancellationToken: AnyCancellable?
    
    init() {}

}

extension AuthViewModel {
    func login() {
        guard let login = lAndVRes else {
            return
        }
        
        cancellationToken = provider.request(
            with: UserAPI.login(login: login),
            scheduler: RunLoop.main,
            class: LoginAndVerificationResponse.self
        ).sink(receiveCompletion: { completionResponse in
            switch completionResponse {
            case .failure(let error):
                print(error.errorDescription)
            case .finished:
                break
            }
        }, receiveValue: { res in
            print(res)
            self.lAndVRes = res
        })
    }
    
    func verification() {
        guard let verificationResponse = lAndVRes else {
            return
        }

        cancellationToken = provider.request(
            with: UserAPI.verification(verificationResponse: verificationResponse),
            scheduler: RunLoop.main,
            class: LoginRes.self
        ).sink(receiveCompletion: { completionResponse in
            switch completionResponse {
            case .failure(let error):
                print(error.errorDescription)
            case .finished:
                break
            }
        }, receiveValue: { res in
            print(res)
            // move to other VC
            print("Your have login")
        })
    }
}
