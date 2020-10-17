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
    
    @Published var show: Bool = false
    var didChange = PassthroughSubject<Void, Never>()
    
    @Published var messages: [ChatMessageResponse.Item] = []

    @Published var isLoadingPage = false
    private var currentPage = 1
    private var canLoadMorePages = true
    
    @EnvironmentObject var currentUserVM: CurrentUserViewModel

    let provider = Pyramid()
    var cancellable: AnyCancellable?
    let authenticator = Authenticator()
    
    private let urlSession = URLSession(configuration: .default)
    private var webSocketTask: URLSessionWebSocketTask?
    private let baseURL = URL(string: "ws://10.0.1.3:6060/v1/chat")!
    
    var conversationsId: String = ""
    
    init() {}
    
    private func connect(onMessageReceived: @escaping (Result<URLSessionWebSocketTask.Message, Error>) -> Void) {
        stop()

        guard let token = Authenticator.shared.currentToken else {
            print(#line, "")
            return
        }
        
        var request = URLRequest(url: baseURL)
        request.addValue(
            "Bearer \(token.accessToken)",
            forHTTPHeaderField: "Authorization"
        )
 
        webSocketTask = urlSession.webSocketTask(with: request)
        webSocketTask?.resume()
        fetchMoreMessages()
        sendPing()
        receiveMessage(completionHandler: onMessageReceived)
    }
    
    deinit {
        disconnect()
    }
    
    func disconnect() {
        webSocketTask?.cancel(with: .normalClosure, reason: nil)
    }
    
    func stop() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
    }
    
    private func sendPing() {
        webSocketTask?.sendPing { (error) in
            if let error = error {
                print("Sending PING failed: \(error)")
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 10) { [weak self] in
                self?.sendPing()
            }
        }
    }
    
    private func receiveMessage(completionHandler: @escaping (Result<URLSessionWebSocketTask.Message, Error>) -> Void) {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .failure(let error):
                print(#line, "Error in receiving message: \(error)")
            case .success(let text):
                switch text {
                case .data(let data):
                    print(#line, data)
                
                case .string(let text):
                    print(#line, text)
                    guard let message = ChatMessage.decode(json: text) else {
                        return
                    }
                    
                    DispatchQueue.main.async {
                        withAnimation(.spring()) {
                            print(#line, message)
                            self?.messages.append(message.messageResponse)
                        }
                    }
                
                default:
                    break
                }

                completionHandler(result)
                self?.receiveMessage(completionHandler: completionHandler)
            }
        }
    }
    
    func send(text: String, conversation: ConversationResponse.Item) {
        guard let currentUSER: CurrentUser = KeychainService.loadCodable(for: .currentUser) else {
            return
        }
        
        let message = ChatMessageResponse.Item(id: nil, conversationId: conversationsId, messageBody: text, sender: currentUSER, recipient: nil, messageType: .text, isRead: false, isDelivered: false, createdAt: nil, updatedAt: nil)
        
        let onMessageJsonString = ChatOutGoingEvent.message(message.wSchatMessage).jsonString
        
        webSocketTask?.send(.string(onMessageJsonString!)) { error in
            if let error = error {
                print("Error sending message", error)
            }
            
            DispatchQueue.main.async {
                withAnimation(.spring()) {
                    self.messages.append(message)
                }
            }
        }
        
    }
    
    func onConnect(_ conversation: ConversationResponse.Item) {
        
        
        let onconnect = ChatOutGoingEvent.connect(conversation.wSconversation).jsonString
        
        webSocketTask?.send(.string(onconnect!)) { error in
            if let error = error {
                print(#line, "Error sending message", error)
            }
        }
    }
    
    func onDisconnect(_ conversation: ConversationResponse.Item) {
        
        let onconnect = ChatOutGoingEvent.disconnect(conversation.wSconversation).jsonString
        
        webSocketTask?.send(.string(onconnect!)) { error in
            if let error = error {
                print(#line, "Error sending message", error)
                self.disconnect()
            }
        }
        
        
    }
    
    // MARK: - Connection
    
    func connect() {
        connect { (result) in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print("Error in receiving message: \(error)")
                case .success(let text):
                    switch text {
                    case .string(let text):
                        print(#line, text)
//                        DispatchQueue.main.async {
//                            withAnimation(.spring()) {
//                                self.messages.append(message)
//                            }
//                        }

                    default:
                        break
                    }
                }
            }
            
        }
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
            print(self, #line, "conversationsId is empty")
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
            self.messages = res
        })
                
    }
}
