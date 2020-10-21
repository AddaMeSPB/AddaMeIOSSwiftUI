//
//  ChatDataHandler.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 28.09.2020.
//

import Foundation
import SwiftUI
import Combine
import Pyramid


class ChatDataHandler: ObservableObject {
    
    @Published var socket = SocketViewModel.shared
    
    @Published var show: Bool = false
    @Published var messages: [ChatMessageResponse.Item] = []

    @Published var isLoadingPage = false
    private var currentPage = 1
    private var canLoadMorePages = true

    let provider = Pyramid()
    var cancellable: AnyCancellable?
    let authenticator = Authenticator()
    
    var conversationsId: String = ""
    
    init() {}

    func send(text: String, conversation: ConversationResponse.Item) {
        guard let currentUSER: CurrentUser = KeychainService.loadCodable(for: .currentUser) else {
            return
        }
        
        let localMessage = ChatMessageResponse.Item(id: nil, conversationId: conversationsId, messageBody: text, sender: currentUSER, recipient: nil, messageType: .text, isRead: false, isDelivered: false, createdAt: nil, updatedAt: nil)
        
        guard let sendServerMsgJsonString = ChatOutGoingEvent.message(localMessage).jsonString else {
            print(#line, "json convert issue")
            return
        }
        
        self.socket.send(localMessage, sendServerMsgJsonString)
        
    }
        
}

extension ChatDataHandler {
    
    func fetchMoreMessagIfNeeded(currentItem item: ChatMessageResponse.Item?) {
        
        guard let item = item else {
            fetchMoreMessages()
            return
        }

        let threshouldIndex = messages.index(messages.endIndex, offsetBy: -7)
        if messages.firstIndex(where: { $0.id == item.id }) == threshouldIndex {
            fetchMoreMessages()
        }
    }
    
    func fetchMoreMessages() {
        //self.conversationsId = "5f801d537c71a7b7d66ef630"
        
        if conversationsId.isEmpty {
            print(self, #line, "cant featch Messages becz conversationsId is empty")
           return
        }
        
        guard !isLoadingPage && canLoadMorePages else { return }
        
        isLoadingPage = true
        
        let query = QueryItem(page: "page", pageNumber: "\(currentPage)", per: "per", perSize: "10")
        
        cancellable = provider.request(
            with: MessageAPI.list(query, conversationsId),
            scheduler: RunLoop.main,
            class: ChatMessageResponse.self
        )
        .handleEvents(receiveOutput: { [self] response in
            self.canLoadMorePages = self.messages.count < response.metadata.total
            self.isLoadingPage = false
            self.currentPage += 1
        })
        .map({ response in
            return self.messages + response.items
        })
        .sink(receiveCompletion: { completionResponse in
            switch completionResponse {
            case .failure(let error):
                print(#line, error)
            case .finished:
                break
            }
        }, receiveValue: { res in
            print(res)
            print(res.count)
            self.socket.messages = res.uniqElemets().sorted()
        })
                
    }
}
