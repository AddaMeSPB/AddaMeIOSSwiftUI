//
//  SocketViewModel.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 20.10.2020.
//

import SwiftUI
import Combine

class SocketViewModel: ObservableObject {
    
    let objectWillChange = PassthroughSubject<ChatMessageResponse.Item, Never>()
    
    @Published var conversations = [String: ConversationResponse.Item]()
    
    @Published var messages: [String: [ChatMessageResponse.Item]] = [:]
    
    private let urlSession = URLSession(configuration: .default)
    private var socket: URLSessionWebSocketTask!
    private var url = URL(string: "ws://10.0.1.3:6060/v1/chat")!
    
    public static var shared = SocketViewModel()
    
    init() {
        self.handshake()
    }
    
    deinit {
        print(#line, "deinit disconnect socket")
        disconnect()
    }
    
    func disconnect() {
        socket.cancel(with: .normalClosure, reason: nil)
    }
    
    func stop() {
        socket.cancel(with: .goingAway, reason: nil)
    }
    
    func send(_ localMessage: ChatMessageResponse.Item, _ sendServerMsgJsonString: String) {
        
        self.socket.send(.string(sendServerMsgJsonString)) { error in
            if let error = error {
                print("Error sending message", error)
            }
            
            DispatchQueue.main.async {
                withAnimation(.spring()) {
                    if self.messages[localMessage.conversationId] != nil {
                        self.objectWillChange.send(localMessage)
                        //self.messages[localMessage.conversationId]!.append(localMessage)
                    }
                    //self.messages.append(localMessage)
                }
            }
        }
        
    }
}

extension SocketViewModel {
    
    private func handshake() {
        guard let token = Authenticator.shared.currentToken else {
            print(#line, "")
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue(
            "Bearer \(token.accessToken)",
            forHTTPHeaderField: "Authorization"
        )
 
        self.socket = urlSession.webSocketTask(with: request)
        self.listen()
        self.socket.resume()
        self.onConnect()
    }
    
    private func onConnect() {
        guard let currentUSER: CurrentUser = KeychainService.loadCodable(for: .currentUser) else {
            return
        }
        
        let onconnect = ChatOutGoingEvent.connect(currentUSER).jsonString
        
        socket.send(.string(onconnect!)) { error in
            if let error = error {
                print(#line, "Error sending message", error)
            }
        }
    }
    
    private func listen() {
        self.socket.receive { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            
            case .success(let message):
                switch message {
                case .data(let data):
                    print(#line, data)
                case .string(let str):
                    print(#line, str)
                    guard let data = str.data(using: .utf8) else { return }
                    self.handle(data)
                @unknown default:
                  break
                }
            case .failure(let error):
                print(#line, error)
                self.socket.cancel(with: .goingAway, reason: nil)
                self.handshake()
                return
            }
        
            self.listen()
        }
    }
    
    private func handle(_ data: Data) {
        let chatOutGoingEvent = ChatOutGoingEvent.decode(data: data)
        
        switch chatOutGoingEvent {
        case .connect(_):
            break
        case .disconnect(_):
            break
        case .conversation(let conversation):
            print(#line, conversation)
            self.handleConversationResponse(conversation)
        case .message(let message):
            print(#line, message)
            self.handleMessageResponse(message)
        case .notice(let msg):
            print(#line, msg)
        case .error(let error):
            print(#line, error)
        case .none:
            print(#line, "decode error")
        }
    }
    
    private func handleConversationResponse(_ lastMessage: ChatMessageResponse.Item) {
        
        DispatchQueue.main.async {
            withAnimation(.spring()) {
                guard var conversationLastMessage = self.conversations[lastMessage.conversationId] else { return }
                
                conversationLastMessage.lastMessage = lastMessage
                
                //self.conversations.updateValue(conversationLastMessage, forKey: lastMessage.conversationId)
                self.conversations[lastMessage.conversationId] = conversationLastMessage
            }
        }
    }
    
    private func handleMessageResponse(_ message: ChatMessageResponse.Item) {
        DispatchQueue.main.async {
            withAnimation(.spring()) {
                
                if self.messages[message.conversationId] != nil {
                    self.objectWillChange.send(message)
                    self.messages[message.conversationId]!.append(message)
                }
            }
        }
    }
    
}
