//
//  UserViewModel.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 17.10.2020.
//

import Foundation
import Combine
import Pyramid

class UserViewModel: ObservableObject {

    @Published var user: CurrentUser?
    
    let provider = Pyramid()
    var cancellationToken: AnyCancellable?
    
    init() { self.me() }
}

extension UserViewModel {
    
    func me() {
        guard let my: CurrentUser = KeychainService.loadCodable(for: .currentUser) else {
            return
        }
        
        cancellationToken = provider.request(
            with: UserAPI.me(my.id),
            scheduler: RunLoop.main,
            class: CurrentUser.self
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

//            KeychainService.save(codable: res.user, for: .currentUser)
//            KeychainService.save(codable: res.access, for: .token)
//            self.lAndVRes?.isLoggedIn = true
            self.user = res
        })
    }
}

