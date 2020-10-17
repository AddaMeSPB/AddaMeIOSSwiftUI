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

