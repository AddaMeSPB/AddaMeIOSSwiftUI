//
//  AuthViewModel.swift
//  AddaMeIOS
//
//  Created by Alif on 4/8/20.
//

import Foundation
import Combine
import SwiftUI
import PhoneNumberKit
import FuncNetworking
import AuthClient
import AddaMeModels
import KeychainService

public class AuthViewModel: ObservableObject {
  
  public struct Alert: Identifiable {
    public var title: String
    public var id: String { self.title }
  }
  
  @AppStorage(AppUserDefaults.Key.isAuthorized.rawValue) var isAuthorized: Bool = false
  @AppStorage(AppUserDefaults.Key.isUserFristNameUpdated.rawValue)
  public var isUserFristNameUpdated: Bool = false
  
  @Published var authResponse = AuthResponse.draff
  @Published var verificationResponse = "" {
    didSet {
      //guard self.verificationResponse.count > 6 else { return }
      authResponse.code = verificationResponse
      
      if verificationResponse.count == 6 {
//        self.verificationResponse = String(verificationResponse.prefix(6))
        verificationRequestSend()
      }
    }
  }
  
  @Published var isRegisterRequestInFlight = false
  @Published var inputWrongVarificationCode = false
  @Published var errorAlert: Alert?
  @Published var phoneNumber: String = ""
  @Published var isValidPhoneNumber: Bool = false
  @Published var showingTermsSheet = false
  @Published var showingPrivacySheet = false
  
  let phoneNumberKit = PhoneNumberKit()
  
  var isAttemptIdIsNil: Bool {
    return authResponse.attemptId == nil
  }
    
  var cancellationToken: AnyCancellable?
  var cancellables: Set<AnyCancellable> = []

  let authClient: AuthClient
  
  public init(authClient: AuthClient) {
    self.authClient = authClient
  }
  
}

extension AuthViewModel {
  func goButtonTapped(_ phoneField: PhoneNumberTextFieldView?) {
    do {
      phoneField?.getCurrentText()
      let parseNumber = try self.phoneNumberKit.parse(self.phoneNumber)
      _ = self.phoneNumberKit.format(parseNumber, toType: .e164)
      
      self.authResponse = AuthResponse(phoneNumber: phoneNumber)
      
      loginRequestSend()
    } catch {
      print("Error validating phone number")
    }
  }
}


extension AuthViewModel {
  
  func loginRequestSend() {

    isRegisterRequestInFlight = true

    guard !authResponse.phoneNumber.isEmpty else {
        return
    }
    
    authClient.login(authResponse)
    .receive(on: RunLoop.main)
    .sink(receiveCompletion: { [weak self] completionResponse in
      switch completionResponse {
      case .failure(let error):
        self?.isRegisterRequestInFlight = false
        print(#line, error)
        self?.errorAlert = Alert(title: "Something went wrong. Please try again.")
      case .finished:
        self?.isRegisterRequestInFlight = false
        break
      }
    }, receiveValue: { [weak self] res in
      print(res)
      self?.isRegisterRequestInFlight = false
      self?.authResponse = res
    })
    .store(in: &cancellables)
  }
  
  func verificationRequestSend() {
    
    isRegisterRequestInFlight = true
    
    guard !authResponse.phoneNumber.isEmpty else {
        return
    }
    
    authClient.varification(authResponse)
    .receive(on: DispatchQueue.main)
    .sink(receiveCompletion: { [unowned self] completionResponse in
      switch completionResponse {
      case .failure(let error):
        print(#line, error)
        inputWrongVarificationCode = true
        isRegisterRequestInFlight = false
        self.errorAlert = Alert(title: "Invalid Code. Please try with valid code again.")
        inputWrongVarificationCode = false
      case .finished:
        isRegisterRequestInFlight = false
        break
      }
    }, receiveValue: { [unowned self] res in
      print(res)
      print("Your have login")
      isAuthorized = true
      saveCurrentUserAndToken(res)
      isRegisterRequestInFlight = false
      
      isUserFristNameUpdated = res.user.firstName == nil ? false : true
    })
    .store(in: &cancellables)
  }
  
  private func saveCurrentUserAndToken(_ res: LoginRes) {
    KeychainService.save(codable: res.user, for: .user)
    KeychainService.save(codable: res.access, for: .token)
  }
  
}
