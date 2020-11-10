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
    @Published var messages: [ChatMessageResponse.Item] = [] {
        didSet {
            guard let conversationsID = conversationsId else {
                print(#line, "Conversation id missing")
                return
            }
            self.socket.messages[conversationsID] = self.messages
        }
    }

    @Published var isLoadingPage = false
    private var currentPage = 1
    private var canLoadMorePages = true

    let provider = Pyramid()
    var cancellable: AnyCancellable?
    let authenticator = Authenticator()
    
    var conversationsId: String?
    
    @Published var composedMessage: String = "Type..."
    
    var newMessageTextIsEmpty: Bool { composedMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
    
    var anyCancellable: AnyCancellable? = nil
    
    init() {
        anyCancellable = socket.objectWillChange
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
            self?.objectWillChange.send()
        }
    }

    func send() {
        
        if newMessageTextIsEmpty {
            print(#line, "message cant be empty or whitespacesAndNewlines")
            return
        }
        
        guard let currentUSER: CurrentUser = KeychainService.loadCodable(for: .currentUser), let conversationsID = conversationsId else {
            print(#line, "current user or conversation id missing")
            return
        }
        
        let localMessage = ChatMessageResponse.Item(id: ObjectId.shared.generate(), conversationId: conversationsID, messageBody: composedMessage, sender: currentUSER, recipient: nil, messageType: .text, isRead: false, isDelivered: false, createdAt: nil, updatedAt: nil)
        
        guard let sendServerMsgJsonString = ChatOutGoingEvent.message(localMessage).jsonString else {
            print(#line, "json convert issue")
            return
        }
        
        self.socket.send(localMessage, sendServerMsgJsonString)
    }
    
    func clearComposedMessage() {
        self.composedMessage = ""
    }
        
}

extension ChatDataHandler {
    
    func fetchMoreMessagIfNeeded(currentItem item: ChatMessageResponse.Item?) {
        
        guard let item = item else {
            fetchMoreMessages()
            return
        }

        let threshouldIndex = messages.index(messages.endIndex, offsetBy: -10)
        if messages.firstIndex(where: { $0.id == item.id }) == threshouldIndex {
            fetchMoreMessages()
        }
    }
    
    func fetchMoreMessages() {
        //self.conversationsId = "5f801d537c71a7b7d66ef630"
        
        guard let conversationsID = conversationsId else {
            print(#line, "Conversation id missing")
            return
        }
        
        guard !isLoadingPage && canLoadMorePages else { return }
        
        isLoadingPage = true
        
        let query = QueryItem(page: "page", pageNumber: "\(currentPage)", per: "per", perSize: "60")
        
        cancellable = provider.request(
            with: MessageAPI.list(query, conversationsID),
            scheduler: RunLoop.main,
            class: ChatMessageResponse.self
        )
        .handleEvents(receiveOutput: { [self] response in
            self.canLoadMorePages = self.messages.count < response.metadata.total
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
        }, receiveValue: { res in
            self.messages = (res.items + self.messages).uniqElemets().sorted()
        })
        
    }
}
