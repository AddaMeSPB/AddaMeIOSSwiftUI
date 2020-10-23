//
//  ConversationViewModel.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 07.10.2020.
//

import Foundation
import SwiftUI
import Combine
import Pyramid

class ConversationViewModel: ObservableObject {
    
    @Published var socket = SocketViewModel.shared
    
    @Published var show: Bool = false
    @Published var conversations = [ConversationResponse.Item]() {
        didSet {
            conversations.forEach { conversation in
                self.socket.conversations[conversation.id] = conversation
            }
        }
    }
    @Published var isLoadingPage = false
    
    private var currentPage = 1
    private var canLoadMorePages = true
    
    let provider = Pyramid()
    var cancellable: AnyCancellable?
    let authenticator = Authenticator()

    var anyCancellable: AnyCancellable? = nil
    
    init() {
        fetchMoreConversations()
        anyCancellable = socket.objectWillChange.sink { [weak self] _ in
            self?.objectWillChange.send()
        }
    }
}

extension ConversationViewModel {
    
    func fetchMoreEventIfNeeded(currentItem item: ConversationResponse.Item?) {
        
        guard let item = item else { fetchMoreConversations(); return }

        let threshouldIndex = conversations.index(conversations.endIndex, offsetBy: -7)

        if conversations.firstIndex(where: { $0.id == item.id } ) == threshouldIndex {
            fetchMoreConversations()
        }
    }
    
    func fetchMoreConversations() {

        guard !isLoadingPage && canLoadMorePages else { return }

        isLoadingPage = true

        let query = QueryItem(page: "page", pageNumber: "\(currentPage)", per: "per", perSize: "10")

        cancellable = provider.request(
            with: ConversationAPI.list(query),
            scheduler: RunLoop.main,
            class: ConversationResponse.self
        )
        .handleEvents(receiveOutput: { [self] response in
            self.canLoadMorePages = self.conversations.count < response.metadata.total
            self.isLoadingPage = false
            self.currentPage += 1
        })
        .receive(on: RunLoop.main)
        .sink(receiveCompletion: { completionResponse in
            switch completionResponse {
            case .failure(let error):
                print(#line, error)
            case .finished:
                break
            }
        }, receiveValue: {  res in
            print(res.items.count)
            print(res.items)
           
            self.conversations = (res.items + self.conversations).filter({ $0.lastMessage != nil }).uniqElemets().sorted()
            
        })

    }
    
}

