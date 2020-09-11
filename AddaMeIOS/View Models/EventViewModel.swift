//
//  EventViewModel.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 28.08.2020.
//

import Foundation
import Combine
import Pyramid

class EventViewModel: ObservableObject {

    @Published var events = [Event]()
    @Published var event: Event?
    
    let provider = Pyramid()
    var cancellationToken: AnyCancellable?
    let authenticator = Authenticator()
    
    init() {
        fetchEvents()
    }

}


extension EventViewModel {
    func fetchEvents() {
        cancellationToken = provider.request(
            with: EventAPI.events,
            scheduler: RunLoop.main,
            class: [Event].self
        )
        .tryCatch { error -> AnyPublisher<[Event], ErrorManager> in
            if error.errorDescription.contains("401") {
                print("code goes here")
                //self.authenticator.refreshToken(using: tokenSubject)
            }

            return self.provider.request(
                with: EventAPI.events,
                scheduler: RunLoop.main,
                class: [Event].self
            )
        }
        .sink(receiveCompletion: { completionResponse in
            switch completionResponse {
            case .failure(let error):
                print(#line, error)
//                print(#line, error.errorDescription.contains("401"))

            case .finished:
                break
            }
        }, receiveValue: { res in
            print(res)
            self.events = res
        })
        // KeychainService.logout()
    }

}
