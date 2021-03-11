//
//  ConversationChatViewModel.swift
//  
//
//  Created by Saroar Khandoker on 10.03.2021.
//

import Foundation
import SwiftUI
import Combine
import FuncNetworking
import KeychainService
import AddaMeModels
import KeychainService
import WebsocketClient
import ConversationClient

public class ConversationChatViewModel: ObservableObject {
  
  @Published var conversations: [String: ConversationResponse.Item] = [:]
  @Published var messages: [String: [ChatMessageResponse.Item]] = [:]
  
  public var conversationViewModel: ConversationViewModel
  public var chatViewModel: ChatViewModel
  public var websocketViewModel: WebsocketViewModel
  
  var cancellable = Set<AnyCancellable>()
  
  public init(
    conversationViewModel: ConversationViewModel,
    chatViewModel: ChatViewModel,
    websocketViewModel: WebsocketViewModel
  ) {
    self.conversationViewModel = conversationViewModel
    self.chatViewModel = chatViewModel
    self.websocketViewModel = websocketViewModel
    
    self.loadingConversations()
    self.loadingMessages()
    
//    self.websocketViewModel.websocketClient
//        .messages()
//        .receive(on: DispatchQueue.main)
//        .sink { [weak self] msg in
//          guard let self = self else { return }
//          self.messages[msg.conversationId]?.insert(msg, at: 0)
//        }
//        .store(in: &cancellable)
//
//    self.websocketViewModel.websocketClient
//        .messages()
//        .receive(on: DispatchQueue.main)
//        .sink { [weak self] lastMessage in
//          guard let self = self else { return }
//          guard var conversationLastMessage = self.conversations[lastMessage.conversationId] else { return }
//
//            conversationLastMessage.lastMessage = lastMessage
//            self.conversations[lastMessage.conversationId] = conversationLastMessage
//
//        }
//        .store(in: &cancellable)
    
  }
  
  
  func loadingConversations() {
    self.conversationViewModel.conversationsPublisher
      .map { $0 }
      .receive(on: DispatchQueue.main)
      .sink { [weak self] results in
        guard let self = self else { return }
        
        results.forEach { conversation in
          self.conversations[conversation.id] = conversation
        }
      }
      .store(in: &cancellable)
  }
  
  func loadingMessages() {
  
    // find bug and fixed it 
    self.chatViewModel.messagesPublisher
      .map { $0 }
      .receive(on: DispatchQueue.main)
      .sink { [weak self] results in
        guard let self = self else { return }
        
        guard let conversationsID = self.chatViewModel.conversationsId else {
          print(#line, "Conversation id missing")
          return
        }
        
        self.messages[conversationsID] = results
        
      }
      .store(in: &cancellable)
  }
  
  
}
