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
  
  var body : some View {
    NavigationView {
      List {
        ForEach(conversationViewModel.socket.conversations.map { $1 }.sorted(), id: \.self) { conversation in
          NavigationLink(
            destination: ChatRoomView(conversation: conversation)
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
        ToolbarItem(placement: .navigationBarTrailing ) {
          Button(action: {
            self.moveToContacts = true
          }) {
            Image(systemName: "plus").resizable().frame(width: 20, height: 20)
          }
          .background (
            NavigationLink(
              destination: ContactsView().environmentObject(appState),
              isActive: self.$moveToContacts) {
              EmptyView()
            }
            .navigationTitle("Chats")
          )
        }
      }
      .background(Color(.systemBackground))
    }
    
  }
  
}


struct ConversationList_Previews: PreviewProvider {
  static var previews: some View {
    ConversationList()
      .environmentObject(AppState())
      .environmentObject(ConversationViewModel())
  }
}

