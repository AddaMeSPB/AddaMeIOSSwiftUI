//
//  ChatDataHandle.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 28.09.2020.
//

import Foundation
import SwiftUI
import Combine

class ChatDataHandle: ObservableObject {
    @Published var show : Bool = false
    var didChange = PassthroughSubject<Void, Never>()
    
    @Published var messages: [ChatMessage] = []
    @Published var lastMessages: [LastMessage] = demoLastMessages    
    @EnvironmentObject var currentUserVM: CurrentUserViewModel
    
    private let urlSession = URLSession(configuration: .default)
    private var webSocketTask: URLSessionWebSocketTask?
    private let baseURL = URL(string: "ws://192.168.1.8:6060/chat")!
    
    private func connect(onMessageReceived: @escaping (Result<URLSessionWebSocketTask.Message, Error>) -> Void) {
        stop()
        webSocketTask = urlSession.webSocketTask(with: baseURL)
        webSocketTask?.resume()
        
        onConnect()
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
                            self?.messages.append(message)
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
    
    func send(text: String) {
        guard let currentUSER: CurrentUser = KeychainService.loadCodable(for: .currentUser) else {
            return
        }
        
        let message = ChatMessage(id: UUID().uuidString, conversationId: "5f493975467caaf438b3980e", sender: currentUSER, recipient: nil, messageBody: text, messageType: .text, createdAt: nil, updatedAt: nil)
        let onMessageJsonString = ChatOutGoingEvent.message(message).jsonString
        
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
    
    func onConnect() {
        guard let currentUSER: CurrentUser = KeychainService.loadCodable(for: .currentUser) else {
            return
        }
        
        let onconnect = ChatOutGoingEvent.connect(currentUSER).jsonString
        
        webSocketTask?.send(.string(onconnect!)) { error in
            if let error = error {
                print(#line, "Error sending message", error)
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
