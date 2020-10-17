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
    
    var body : some View {
        ChatTopView()
        ScrollView {
            LazyVStack {
                ForEach(conversationViewModel.conversations) { conversation in

                    NavigationLink(destination: ChatRoomView(conversation: conversation)) {
                        
                        MessageCellView(conversation: conversation)
                            .onTapGesture {
                                DispatchQueue.main.async {
                                    //self.conversationViewModel.show.toggle()
                                    self.globalBoolValue.isTabBarHidden.toggle()
                                }
                            }
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
        }
    }
}


struct MessageListView_Previews: PreviewProvider {
    static var previews: some View {
        MessageListView()
    }
}
