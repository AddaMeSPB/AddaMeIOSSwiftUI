//
//  ChatView.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 05.09.2020.
//

import SwiftUI

struct ChatView: View {
    
//    @EnvironmentObject var chatData: ChatDataHandler
//    var conversationWithLastMessage = [Conversation]()
    
    var body : some View {
        ZStack {
            Color("bg")
                .edgesIgnoringSafeArea(.top)

            VStack {
                MessageListView()
                    .clipShape(RoundLeft())
                    
            }
        }
        
    }
}


struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ChatView()
        }
    }
}
