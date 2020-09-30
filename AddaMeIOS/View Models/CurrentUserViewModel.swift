//
//  CurrentUserViewModel.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 28.09.2020.
//

import Foundation
import Combine

class CurrentUserViewModel: ObservableObject {
    @Published var currentUser: CurrentUser?
    @Published var isMe: Bool = false
    
    init() {
        isCurrentUser()
    }

    private func isCurrentUser() {
        guard let currentUSER: CurrentUser = KeychainService.loadCodable(for: .currentUser) else {
            isMe = false
            return
        }
        
        currentUser = currentUSER
        isMe = true
    }
}

let currentUser = CurrentUser(
    id: "5f452cdcd52115d14c96450b",
    avatarUrl: "https://s3.eu-central-1.amazonaws.com/tenreckios/5ed8ae7f593304fd03c2c889_1CB5D497-581C-4B0E-BA07-8E5116395927-1490-000000899DBD9714.png",
    firstName: "Alif",
    phoneNumber: "+79218821217",
    createdAt: demoCurrentDate,
    updatedAt: demoCurrentDate
)

let opponentUser = CurrentUser(
    id: "5f718d9638428728ef9430db",
    avatarUrl: "https://image.tmdb.org/t/p/original/pThyQovXQrw2m0s9x82twj48Jq4.jpg",
    firstName: "Tonmmoy",
    phoneNumber: "+79218821217",
    createdAt: demoCurrentDate,
    updatedAt: demoCurrentDate
)
