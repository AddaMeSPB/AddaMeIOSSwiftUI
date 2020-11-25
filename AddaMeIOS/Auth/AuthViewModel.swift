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
  
  @Published var lAndVRes = LoginAndVerificationResponse(phoneNumber: String.empty)
  @Published var verificationCodeResponse = String.empty {
    didSet {
      lAndVRes.code = verificationCodeResponse
      if verificationCodeResponse.count == 6 {
        verification()
      }
    }
  }
  
  @Published var isLoadingPage = false
  @Published var inputWrongVarificationCode = false
  @Published var isAuthorized: Bool = {
    UserDefaults.standard.bool(forKey: "isAuthorized")
  }()
  
  let provider = Pyramid()
  var cancellationToken: AnyCancellable?
  
  var anyCancellable: AnyCancellable? = nil
  
  init() {}

}

extension AuthViewModel {
  func login() {

    isLoadingPage = true

    guard !lAndVRes.phoneNumber.isEmpty else {
        return
    }

    cancellationToken = provider.request(
      with: AuthAPI.login(login: lAndVRes),
      scheduler: RunLoop.main,
      class: LoginAndVerificationResponse.self
    ).sink(receiveCompletion: { [weak self] completionResponse in
      switch completionResponse {
      case .failure(let error):
        self?.isLoadingPage = false
        print(#line, error.errorDescription)
      case .finished:
        self?.isLoadingPage = false
        break
      }
    }, receiveValue: { [weak self] res in
      print(res)
      self?.isLoadingPage = false
      self?.lAndVRes = res
    })
  }
  
  func verification() {
    isLoadingPage = true
    
    guard !lAndVRes.phoneNumber.isEmpty else {
        return
    }
    
    cancellationToken = provider.request(
      with: AuthAPI.verification(verificationResponse: lAndVRes),
      scheduler: RunLoop.main,
      class: LoginRes.self
    ).sink(receiveCompletion: { [weak self] completionResponse in
      switch completionResponse {
      case .failure(let error):
        print(#line, error.errorDescription)
        self?.inputWrongVarificationCode = true
        self?.isLoadingPage = false
      case .finished:
        self?.isLoadingPage = false
        break
      }
    }, receiveValue: { [weak self] res in
      print(res)
      // move to other VC
      // save token
      print("Your have login")
      AppUserDefaults.saveCurrentUserAndToken(res)
      AppUserDefaults.save(true, forKey: .isAuthorized)
      
      self?.isAuthorized = true
      self?.isLoadingPage = false
      
    }) // add more logic loading
  }
}

