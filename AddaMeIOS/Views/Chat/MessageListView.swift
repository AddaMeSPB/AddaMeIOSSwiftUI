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
    
    var body : some View {
        ChatTopView()
        ScrollView {
            LazyVStack {
                ForEach(conversationViewModel.conversations) { conversation in

                    NavigationLink(
                        destination: ChatRoomView(conversation: conversation),
                        isActive: self.$distanationTag ) {
                        
                        MessageCellView(conversation: conversation)
                            .onTapGesture {
                                DispatchQueue.main.async {
                                    self.distanationTag = true
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
        .onAppear {
            self.globalBoolValue.isTabBarHidden = false
        }
    }
}


struct MessageListView_Previews: PreviewProvider {
    static var previews: some View {
        MessageListView()
    }
}
