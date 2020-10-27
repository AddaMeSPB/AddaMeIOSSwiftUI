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

    @Published var isLoadingPage = false
    
    let provider = Pyramid()
    var cancellationToken: AnyCancellable?
    
    init() {}

}

extension AuthViewModel {
    func login() {
        
        isLoadingPage = true
        
        guard let login = lAndVRes else {
            return
        }
        
        cancellationToken = provider.request(
            with: AuthAPI.login(login: login),
            scheduler: RunLoop.main,
            class: LoginAndVerificationResponse.self
        ).sink(receiveCompletion: { completionResponse in
            switch completionResponse {
            case .failure(let error):
                print(error)
            case .finished:
                break
            }
        }, receiveValue: { res in
            print(res)
            self.isLoadingPage = false
            self.lAndVRes = res
        })
    }
    
    func verification() {
        isLoadingPage = true
        
        guard let verificationResponse = lAndVRes else {
            return
        }

        cancellationToken = provider.request(
            with: AuthAPI.verification(verificationResponse: verificationResponse),
            scheduler: RunLoop.main,
            class: LoginRes.self
        ).sink(receiveCompletion: { completionResponse in
            switch completionResponse {
            case .failure(let error):
                print(error)
            case .finished:
                break
            }
        }, receiveValue: { res in
            print(res)
            // move to other VC
            // save token
            print("Your have login")
            KeychainService.save(codable: res.user, for: .currentUser)
            KeychainService.save(codable: res.access, for: .token)
            self.lAndVRes?.isLoggedIn = true
            self.isLoadingPage = false
        }) // add more logic loading 
    }
}


//ProgressView("Loading...")
//    .frame(minWidth: 100, idealWidth: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealHeight: 50, maxHeight: 70, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
//    .progressViewStyle(CircularProgressViewStyle(tint: Color.blue))
//    .font(Font.system(.title2, design: .monospaced).weight(.bold))

