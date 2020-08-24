//
//  AuthViewModel.swift
//  AddaMeIOS
//
//  Created by Alif on 4/8/20.
//

import Foundation
import Combine
import AddaNetworking

class AuthViewModel: ObservableObject {

    @Published var lAndVRes: LoginAndVerificationResponse? // 1
    var cancellationToken: AnyCancellable? // 2

    let provider = AddaNetworking()
    var loginAndVerSubscriber: AnyPublisher<LoginAndVerificationResponse, Error>?

    init() {}

}

extension AuthViewModel {
    func login() {
        guard let login = lAndVRes else { return }
        // bug :()
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
        })
    }
}
