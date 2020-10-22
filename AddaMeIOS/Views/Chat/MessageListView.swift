//
//  MessageListView.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 05.09.2020.
//

import SwiftUI

struct MessageListView: View {
    
    @StateObject var conversationViewModel = ConversationViewModel()
    @EnvironmentObject var globalBoolValue: GlobalBoolValue
    
    @State var distanationTag = false
    @State var conversations = [ConversationResponse.Item]()
        
    var body : some View {
        ChatTopView()
        
        ScrollView {
            LazyVStack {
                ForEach(conversationViewModel.socket.conversations.map { $1 }.sorted(), id: \.self) { conversation in
                    NavigationLink(destination:
                        ChatRoomView(conversation: conversation)
                    ) {
                        MessageCellView(conversation: conversation)
                            .background(Color(#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)))
                            .onAppear {
                                conversationViewModel.fetchMoreEventIfNeeded(
                                    currentItem: conversation
                                )
                            }
                    }
                }
                .onReceive( self.conversationViewModel.socket.objectWillChange ) { conversation in
                    if let objectConversation = conversation as? ConversationResponse.Item{
                        DispatchQueue.main.async {
                            self.conversations.append(objectConversation)
                        }
                    }
                }
                .navigationBarHidden(true)
                
                
                if conversationViewModel.isLoadingPage {
                    ProgressView()
                }
            }
        }
        .onAppear {
            print(#line, "ScrollView Appear")
        }
        .onDisappear(perform: {
            globalBoolValue.isTabBarHidden = true
        })
    }
}


struct MessageListView_Previews: PreviewProvider {
    static var previews: some View {
        MessageListView()
            .environmentObject(GlobalBoolValue())
            .environmentObject(ConversationViewModel())
    }
}

