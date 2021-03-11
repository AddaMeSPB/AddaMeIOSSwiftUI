//
//  ChatDetails.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 05.09.2020.
//

import Combine
import SwiftUI
import AddaMeModels
import SwiftUIExtension

struct ChatRoomView: View {
  
  @Environment(\.colorScheme) var colorScheme
  @Environment(\.presentationMode) var presentationMode
  @State var isMicButtonHide = false
  
  @State var conversationChatViewModel: ConversationChatViewModel
  @State var conversation: ConversationResponse.Item
  @State var isFromContactView: Bool
  
  public init(
    conversationChatViewModel: ConversationChatViewModel,
    conversation: ConversationResponse.Item,
    isFromContactView: Bool
  ) {
    self._conversationChatViewModel = State(initialValue: conversationChatViewModel)
    self._conversation = State(initialValue: conversation)
    self._isFromContactView = State(initialValue: isFromContactView)
  }
  
  private func onApperAction() {
    self.conversationChatViewModel.chatViewModel.conversationsId = conversation.id
    self.conversationChatViewModel.chatViewModel.fetchMoreMessages()
  }
  
  var body: some View {
    VStack {
      ZStack {
        List {
// [ChatMessageResponse.Item.init(ChatMessage.init(conversationId: "", messageBody: "Hello", sender: User.init(id: "", phoneNumber: "+79218821219", createdAt: Date(), updatedAt: Date()), messageType: .text, isRead: true, isDelivered: true))]
// self.chatData.socket.messages[conversation.id] ?? [] // chatDemoData

          ForEach( self.conversationChatViewModel.messages[conversation.id] ?? [] ) { message in
            LazyView(ChatRow(chatMessageResponse: message))
              .padding([.top, .bottom], 5)
              .padding([.leading, .trailing], -10)
              .onAppear {
                self.conversationChatViewModel.chatViewModel.fetchMoreMessagIfNeeded(currentItem: message)
              }
              .scaleEffect(x: 1, y: -1, anchor: .center)
              .hideRowSeparator()
              .background(Color(.systemBackground))
              .foregroundColor(Color(.systemBackground))
          }
          
          if self.conversationChatViewModel.chatViewModel.isLoadingPage {
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
        .environmentObject(conversationChatViewModel.chatViewModel)
    }
    .overlay(
      DismissButton(isFromContactView),
      alignment: .topLeading
    )
    .ignoresSafeArea(.keyboard, edges: .bottom)
    .animation(.default)
  }
  
}

//struct ChatDetailsView_Previews: PreviewProvider {
//  static var previews: some View {
//    ChatRoomView(conversation: conversationData.last!, isFromContactView: true)
//      .environmentObject(ChatViewModel())
//  }
//}

struct DismissButton: View {
  @Environment(\.presentationMode) var presentationMode
  
  var isFromContactView: Bool
  
  init(_ isFromContactView: Bool) {
    self.isFromContactView = isFromContactView
  }
  
  var body: some View {
    HStack {
      if isFromContactView {
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
