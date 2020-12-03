//
//  MessageListView.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 05.09.2020.
//

import SwiftUI

struct ConversationList: View {
  
  @StateObject var conversationViewModel = ConversationViewModel()
  @EnvironmentObject var appState: AppState
  @Environment(\.colorScheme) var colorScheme
  
  @State var distanationTag = false
  @State var moveToContacts = false
  
  @ViewBuilder var body : some View {
    NavigationView {
      List {
        ForEach(conversationViewModel.socket.conversations.map { $1 }.sorted(), id: \.self) { conversation in
          NavigationLink(
            destination: ChatRoomView(conversation: conversation, fromContactsOrEvents: false)
              .environmentObject(appState)
              .onAppear(perform: {
                appState.tabBarIsHidden = true
              })
              .onDisappear(perform: {
                appState.tabBarIsHidden = false
              })
          ) {
            
            ConversationRow(conversation: conversation)
              .environmentObject(appState)
              .onAppear {
                conversationViewModel.fetchMoreEventIfNeeded(
                  currentItem: conversation
                )
              }
            
          }
        }
        
        if conversationViewModel.isLoadingPage {
          ProgressView()
        }
        
      }
      .onAppear {
        self.conversationViewModel.fetchMoreConversations()
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
      }.background(
          NavigationLink(
            destination: ContactsView()
                  .edgesIgnoringSafeArea(.bottom)
                  .onAppear(perform: {
                      appState.tabBarIsHidden = true
                      self.moveToContacts = false
                  })
                  .onDisappear(perform: {
                      appState.tabBarIsHidden = false
                  }),
              isActive: $moveToContacts
          ) {
              EmptyView()
          }
          .navigationBarTitle("Contacts")
      )
  }
  
}


struct ConversationList_Previews: PreviewProvider {
  static var previews: some View {
    ConversationList()
      .environmentObject(AppState())
      .environmentObject(ConversationViewModel())
  }
}

