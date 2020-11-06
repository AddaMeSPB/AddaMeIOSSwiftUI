//
//  LoginAndVerificationResponse.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 24.08.2020.
//

import Foundation

// MARK: - Login and Verification request/response
struct LoginAndVerificationResponse: Codable {
    internal init(
        phoneNumber: String,
        attemptId: String? = nil,
        code: String? = nil,
        isLoggedIn: Bool = false
    ) {
        self.phoneNumber = phoneNumber
        self.attemptId = attemptId
        self.code = code
        self.isLoggedIn = isLoggedIn
    }
  
    var phoneNumber: String
    var attemptId: String?
    var code: String?
    var isLoggedIn: Bool? = false
}

// MARK: - Login Response
struct LoginRes: Codable {
    let status: String
    let user: CurrentUser
    let access: Access
}

// MARK: - Access
struct Access: Codable {
    let accessToken, refreshToken: String
}


