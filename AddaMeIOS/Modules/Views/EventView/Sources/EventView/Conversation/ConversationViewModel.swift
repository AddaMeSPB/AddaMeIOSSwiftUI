//
//  ConversationViewModel.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 07.10.2020.

import Foundation
import SwiftUI
import Combine
import ConversationClient
import FuncNetworking
import KeychainService
import AddaMeModels
import KeychainService
import WebsocketClient

public struct Response {
  public let urlResponse: HTTPURLResponse
  public let data: Data
  
  public var statusCode: Int { urlResponse.statusCode }
  public  var localizedStatusCodeDescription: String { HTTPURLResponse.localizedString(forStatusCode: statusCode) }
}

typealias VoidCompletion = (Result<Response, HTTPError>) -> Void

public class ConversationViewModel: ObservableObject {
  
  @AppStorage("isAuthorized")
  var isAuthorized: Bool = false
  
  @Published var show: Bool = false
  @Published var conversations = [ConversationResponse.Item]()
  
  var conversationsPublisher: AnyPublisher<[ConversationResponse.Item], Never> {
    conversationsSubject.eraseToAnyPublisher()
  }
  private let conversationsSubject = PassthroughSubject<[ConversationResponse.Item], Never>()
  
  @Published var conversation: ConversationResponse.Item = ConversationResponse.Item.defint
  @Published var startChat = false
  @Published var isLoadingPage = false
  
  private var currentPage = 1
  private var canLoadMorePages = true
  
  var cancellable: AnyCancellable?
  var anyCancellable: AnyCancellable? = nil
  
  let conversationClient: ConversationClient
  
  public init(
    conversationClient: ConversationClient
  ) {
    self.conversationClient = conversationClient
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
    
    let query = QueryItem(page: "\(currentPage)", per: "10")
    
    //    cancellable = provider.request(
    //      with: ConversationAPI.list(query),
    //      scheduler: RunLoop.main,
    //      class: ConversationResponse.self
    //    )
    
    cancellable = self.conversationClient
      .list(query, "")
      .handleEvents(receiveOutput: { [weak self] response in
        guard let self = self else { return }
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
      }, receiveValue: { [weak self] res in
        
        guard let self = self else { return }
        
        print(#line, self.conversations)
        let combineConversationResults = (res.items + self.conversations).filter({ $0.lastMessage != nil }).uniqElemets().sorted()
        self.conversations = combineConversationResults
        self.conversationsSubject.send(combineConversationResults)
      })
    
  }
  
  func find(conversationsId: String) {
    
    isLoadingPage = true
    
    //    cancellable = provider.request(
    //      with: ConversationAPI.find(conversationsId: conversationsId),
    //      scheduler: RunLoop.main,
    //      class: ConversationResponse.Item.self
    //    )
    
    cancellable = self.conversationClient
      .find(conversationsId, "find")
      .receive(on: RunLoop.main)
      .sink(receiveCompletion: { completionResponse in
        switch completionResponse {
        case .failure(let error):
          print(#line, error)
        case .finished:
          break
        }
      }, receiveValue: { [weak self] res in
        
        self?.conversation = res
        
      })
    
  }
  
  private func addUserToConversation(
    event: EventResponse.Item,
    result: @escaping VoidCompletion
  ) {
    guard let currentUSER: User = KeychainService.loadCodable(for: .user) else {
      return
    }
    
    let adduser = AddUser(conversationsId: conversation.id, usersId: currentUSER.id)
    
    //    provider.request(
    //      with: ConversationAPI.addUserToConversation(adduser),
    //      result: result
    //    )
    //
    conversationClient.addUserToConversation(adduser, "")
    
  }
  
  func moveChatRoomAfterAddMember(event: EventResponse.Item, completion: @escaping ((Bool) -> Void) ) {
    
    guard let currentUSER: User = KeychainService.loadCodable(for: .user), let members = conversation.members, let admins = conversation.admins else {
      completion(false)
      return
    }
    
    if admins.contains(where: { $0.id == currentUSER.id }) {
      completion(true)
      return
    }
    
    if members.contains(where: { $0.id == currentUSER.id }) {
      completion(true)
      return
    }
    
    self.addUserToConversation(event: event) { response in
      switch response {
      case .failure(let error):
        print(#line, self, error)
        completion(false)
      case .success(let res):
        print(#line, res)
        if res.statusCode == 201 { completion(true) }
      }
    }
    
  }
  
  
  func startOneToOneChat(_ createConversation: CreateConversation) {
    //    cancellable = provider.request(
    //      with: ConversationAPI.create(createConversation),
    //      scheduler: RunLoop.main,
    //      class: ConversationResponse.Item.self
    //    )
    
    cancellable = self.conversationClient
      .create(createConversation, "")
      .receive(on: RunLoop.main)
      .sink(receiveCompletion: { completionResponse in
        switch completionResponse {
        case .failure(let error):
          print(#line, error)
        case .finished:
          break
        }
      }, receiveValue: { [weak self] res in
        DispatchQueue.main.async {
          self?.conversation = res
          self?.startChat = true
        }
      })
  }
}

