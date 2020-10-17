//
//  ChatDetails.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 05.09.2020.
//

import Combine
import SwiftUI

struct ChatRoomView: View {
    
    @State var composedMessage: String = ""
    
    @EnvironmentObject var globalBoolValue: GlobalBoolValue
    @EnvironmentObject var currentUserVM: CurrentUserViewModel
    @Environment(\.imageCache) var cache: ImageCache
    
    //@Environment(\.presentationMode) var presentationMode
    @StateObject private var chatData = ChatDataHandler()
    @StateObject var conversationViewModel = ConversationViewModel()
    
    var conversation: ConversationResponse.Item!
    
    private func onApperAction() {
        chatData.conversationsId = conversation.id
        chatData.connect()
        chatData.onConnect(conversation)
    }
    
    private func onDisapperAction() {
        chatData.onDisconnect(conversation)
    }
    
    func onComment() {
        if !composedMessage.isEmpty {
            chatData.send(text: composedMessage, conversation: conversation)
        }
    }
    
    private func scrollToLastMessage(proxy: ScrollViewProxy) {
        if let lastMessage = chatData.messages.last {
            withAnimation(.easeOut(duration: 0.4)) {
                proxy.scrollTo(lastMessage.id, anchor: .bottom)
            }
        }
    }
    
    var body: some View {
        ZStack {
            
            Color("bg")
                .edgesIgnoringSafeArea(.top)
            
            VStack(alignment: .center) {
                
                // ChatDetailsTopview()
                // when you this view back button does not work
                HStack(spacing: 15) {
                    
                    Button(action: {
                        self.conversationViewModel.show.toggle()
                        self.globalBoolValue.isTabBarHidden.toggle()
                    }) {
                        Image(systemName: "control")
                            .font(.title)
                            .rotationEffect(.init(degrees: -90))
                    }
                    
                    Spacer(minLength: 5)
                    
                    HStack(spacing: 5) {
                        
                        AsyncImage(
                            avatarLink: chatData.messages.last?.sender.avatarUrl,
                            placeholder: Text("Loading ..."),
                            cache: self.cache,
                            configuration: {
                                $0.resizable()
                            }
                        )
                        .frame(width: 35, height: 35)
                        .clipShape(Circle())

                        Text(conversation.title)
                            .fontWeight(.heavy)
                    }
                    //.offset(x: )
                    
                    Spacer(minLength: 5)
                    
                    Button(action: {
                        
                    }) {
                        Image(systemName: "phone.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                        
                    }.padding(.trailing, 20)
                    
                    Button(action: {
                        
                    }) {
                        Image(systemName: "video.fill")
                            .resizable()
                            .frame(width: 23, height: 16)
                    }
                    
                }.foregroundColor(.white)
                    .padding()
                    .padding(.top, -15)
                    .padding(.bottom, -15)
                
                ScrollView {
                    ScrollViewReader{ proxy in
                        LazyVStack(spacing: 8) {
                            ForEach(self.chatData.messages) { message in
                                ChatRow(chatMessageResponse: message)
                                    .onAppear {
                                        chatData.fetchMoreMessagIfNeeded(currentItem: message)
                                    }
                            }
                            
                            if chatData.isLoadingPage {
                                ProgressView()
                            }
                        }
                        .padding(10)
                        .onChange(of: self.chatData.messages.count) { _ in
                            scrollToLastMessage(proxy: proxy)
                        }
                    }
                }
                .background(Color.white)
                
                ChatBottomView(chatData: chatData, conversation: conversation)
                
            }.navigationBarTitle("")
            .onAppear(perform: {
                onApperAction()
            })
            .onDisappear(perform: {
                onDisapperAction()
            })
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
        }
    }

}

struct ChatDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ChatRoomView(conversation: conversationCurrentUser)
        .environmentObject(ChatDataHandler())
    }
}
