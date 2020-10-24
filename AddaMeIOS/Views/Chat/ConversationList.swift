//
//  MessageListView.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 05.09.2020.
//

import SwiftUI

struct ConversationList: View {
    
//    @EnvironmentObject var conversationViewModel: ConversationViewModel
    @ObservedObject var conversationViewModel = ConversationViewModel()
    @EnvironmentObject var appState: AppState
    
    @State var distanationTag = false
    @State var moveToContacts = false
    
    var body : some View {
        NavigationView {
            List {
                ForEach(conversationViewModel.socket.conversations.map { $1 }.sorted(), id: \.self) { conversation in
                    NavigationLink(
                        destination: LazyView(ChatRoomView(conversation: conversation))
                            .edgesIgnoringSafeArea(.bottom)
                            .onAppear(perform: {
                                appState.tabBarIsHidden = true
                            })
                            .onDisappear(perform: {
                                appState.tabBarIsHidden = false
                            })
                    ) {
                        ConversationRow(conversation: conversation)
                            .background(Color(#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)))
                            .onAppear {
                                conversationViewModel.fetchMoreEventIfNeeded(
                                    currentItem: conversation
                                )
                            }
                    }
//                    .listRowBackground(
//                        item.id == self.selectedItemId ? Color.blue : Color(UIColor.systemBackground)
//                    )
                }
                
                if conversationViewModel.isLoadingPage {
                    ProgressView()
                }
                
            }
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


struct ConversationList_Previews: PreviewProvider {
    static var previews: some View {
        ConversationList()
            .environmentObject(GlobalBoolValue())
            .environmentObject(ConversationViewModel())
    }
}

