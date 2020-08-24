//
//  LoginAndVerificationResponse.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 24.08.2020.
//

import Foundation

struct LoginAndVerificationResponse: Codable {
    internal init(phoneNumber: String, attemptId: String? = nil, code: String? = nil) {
        self.phoneNumber = phoneNumber
        self.attemptId = attemptId
        self.code = code
    }

    let phoneNumber: String
    let attemptId: String?
    let code: String?
}
