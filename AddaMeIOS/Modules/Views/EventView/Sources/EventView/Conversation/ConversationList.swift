//
//  MessageListView.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 05.09.2020.
//

import SwiftUI
import ConversationClient

public struct ConversationList: View {
  
//  @StateObject var contactStore: ContactStore = ContactStore()
  @ObservedObject var conversationChatViewModel: ConversationChatViewModel
//  @EnvironmentObject var appState: AppState
  @Environment(\.colorScheme) var colorScheme
  
  @State var distanationTag = false
  @State var moveToContacts = false
  
  public init(
    conversationChatViewModel: ConversationChatViewModel
  ) {
    self.conversationChatViewModel = conversationChatViewModel
  }
  
  @ViewBuilder public var body : some View {
    NavigationView {
      List {
        ForEach(conversationChatViewModel.conversations.map { $1 }.sorted() , id: \.self) { conversation in //websocketViewModel.conversations.map { $1 }.sorted()
          NavigationLink(
            destination: ChatRoomView(
              conversationChatViewModel: conversationChatViewModel,
              conversation: conversation,
              isFromContactView: false
            )
//              .environmentObject(appState)
//              .onAppear(perform: {
//                appState.tabBarIsHidden = true
//              })
//              .onDisappear(perform: {
//                appState.tabBarIsHidden = false
//              })
          ) {
            
            ConversationRow(conversation: conversation)
//              .environmentObject(appState)
              .onAppear {
                conversationChatViewModel.conversationViewModel.fetchMoreEventIfNeeded(
                  currentItem: conversation
                )
              }

          }
        }
        
        if conversationChatViewModel.conversationViewModel.isLoadingPage {
          ProgressView()
        }
        
      }
      .onAppear {
        self.conversationChatViewModel.conversationViewModel.fetchMoreConversations()
      }
      .navigationTitle("Chats")
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing ) { contactList }
      }
      .background(Color(.systemBackground))
    }
    .navigationViewStyle(StackNavigationViewStyle())
  }
  
  private var contactList: some View {
      Button(action: {
        self.moveToContacts = true
      }) {
          Image(systemName: "plus.circle")
            .font(.title)
            .foregroundColor(Color("bg"))
      }
//      .background(
//          NavigationLink(
//            destination: ContactsView()
////                  .environmentObject(contactStore)
//                  .edgesIgnoringSafeArea(.bottom)
//                  .onAppear(perform: {
//                      appState.tabBarIsHidden = true
//                      self.moveToContacts = false
//                  })
//                  .onDisappear(perform: {
//                      appState.tabBarIsHidden = false
//                  }),
//              isActive: $moveToContacts
//          ) {
//              EmptyView()
//          }
//          .navigationBarTitle("Contacts")
//      )
  }
  
}


struct ConversationList_Previews: PreviewProvider {
  
  static var chatvm: ChatViewModel {
    .init(chatClient: .happyPath)
  }
  
  static var cvm: ConversationViewModel {
    .init(conversationClient: .happyPath)
  }
  
  static var wvm: WebsocketViewModel {
    .init(websocketClient: .happyPath)
  }
  
  static var ccvm: ConversationChatViewModel {
    .init(
      conversationViewModel: cvm,
      chatViewModel: chatvm,
      websocketViewModel: wvm
    )
  }
  
  static var previews: some View {
    
    ConversationList(conversationChatViewModel: ccvm)
//      .environmentObject(AppState())
//      .environmentObject(ConversationViewModel())
  }
}

