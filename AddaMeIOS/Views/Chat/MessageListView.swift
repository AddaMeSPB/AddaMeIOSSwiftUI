//
//  MessageListView.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 05.09.2020.
//

import SwiftUI

struct MessageListView: View {
    
    @ObservedObject var conversationViewModel = ConversationViewModel()
    @EnvironmentObject var globalBoolValue: GlobalBoolValue
    
    @State var distanationTag = false
    @State var moveToContacts = false
    @State var conversations = [ConversationResponse.Item]()
    
    var body : some View {
        NavigationView {
            List {
                ForEach(conversationViewModel.socket.conversations.map { $1 }.sorted(), id: \.self) { conversation in
                    NavigationLink(destination: ChatRoomView(conversation: conversation) ) {
                        MessageCellView(conversation: conversation)
                            .background(Color(#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)))
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
            .onAppear(perform: {
                globalBoolValue.isTabBarHidden = false
            })
            .onDisappear(perform: {
                globalBoolValue.isTabBarHidden = true
            })
            //.listStyle(GroupedListStyle())
            .navigationTitle("Chats")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing ) {
                    Button(action: {
                        self.moveToContacts = true
                    }) {
                        Image(systemName: "plus").resizable().frame(width: 20, height: 20)
                    }
                    .background (
                        NavigationLink(destination: ContactsView(), isActive: self.$moveToContacts ) {
                            EmptyView()
                        }
                        .navigationTitle("Chats")
                    )
                }
            }
            .background(Color("bg"))
            .accentColor(Color("bg"))
        }
    }
    
}


struct MessageListView_Previews: PreviewProvider {
    static var previews: some View {
        MessageListView()
            .environmentObject(GlobalBoolValue())
            .environmentObject(ConversationViewModel())
    }
}

