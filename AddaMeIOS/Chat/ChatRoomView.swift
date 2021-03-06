//
//  ChatDetails.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 05.09.2020.
//

import Combine
import SwiftUI

struct ChatRoomView: View {
  
  @Environment(\.colorScheme) var colorScheme
  @Environment(\.presentationMode) var presentationMode
  
  @StateObject private var chatData = ChatDataHandler()
  
  @State var conversation: ConversationResponse.Item!
  @State var isMicButtonHide = false
  
  private func onApperAction() {
    self.chatData.conversationsId = conversation.id
    self.chatData.fetchMoreMessages()
  }
  
  @State var fromContactsOrEvents: Bool
  
  var body: some View {
    VStack {
      ZStack {
        List {
          // self.chatData.socket.messages[conversation.id] ?? [] // chatDemoData
          ForEach( self.chatData.socket.messages[conversation.id] ?? [] ) { message in
            LazyView(ChatRow(chatMessageResponse: message))
              .padding([.top, .bottom], 5)
              .padding([.leading, .trailing], -10)
              .onAppear {
                self.chatData.fetchMoreMessagIfNeeded(currentItem: message)
              }
              .scaleEffect(x: 1, y: -1, anchor: .center)
              .hideRowSeparator()
              .background(Color(.systemBackground))
              .foregroundColor(Color(.systemBackground))
          }
          
          
          if self.chatData.isLoadingPage {
            ProgressView()
          }
        }
        .scaleEffect(x: 1, y: -1, anchor: .center)
        .offset(x: 0, y: 2)
        .padding(10)
        .onAppear(perform: {
          onApperAction()
        })
        .navigationBarTitle("\(conversation.title)", displayMode: .inline)
        .background(Color(.systemBackground))
        .resignKeyboardOnDragGesture()
      
      }
      Spacer()
      ChatBottomView()
        .environmentObject(chatData)
    }
    .overlay(
      DismissButton(fromContactsOrEvents),
      alignment: .topLeading
    )
    .ignoresSafeArea(.keyboard, edges: .bottom)
    .animation(.default)
  }
  
}

struct ChatDetailsView_Previews: PreviewProvider {
  static var previews: some View {
    ChatRoomView(conversation: conversationData.last!, fromContactsOrEvents: true)
      .environmentObject(ChatDataHandler())
  }
}

struct DismissButton: View {
  @Environment(\.presentationMode) var presentationMode
  
  var fromContactsOrEvents: Bool
  
  init(_ fromContactsOrEvents: Bool) {
    self.fromContactsOrEvents = fromContactsOrEvents
  }
  
  var body: some View {
    HStack {
      if fromContactsOrEvents {
        Button(action: {
          presentationMode.wrappedValue.dismiss()
        }, label: {
          Image(systemName: "xmark.circle").font(.title)
        })
        .padding(.top, -10)
        .padding()
      }
    }
  }
}
