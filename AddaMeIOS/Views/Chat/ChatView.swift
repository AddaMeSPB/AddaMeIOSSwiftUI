//
//  ChatView.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 05.09.2020.
//

import SwiftUI

struct ChatView: View {
    
    @EnvironmentObject var chatData: ChatDataHandle
    
    var body : some View {
        ZStack {
            Color("bg")
                .edgesIgnoringSafeArea(.top)
            
            NavigationLink(destination: ChatDetailsView(), isActive: $chatData.show) {
                EmptyView()
            }

            VStack {
                ChatTopView()
                MessageListView(chatDataLastMessage: chatData.lastMessages)
                    .clipShape(RoundLeft())
                    
            }
        }
        
    }
}


struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ChatView()
                .environmentObject(ChatDataHandle())
        }
    }
}

let demoCurrentDate = Date()
let demoChatMessages = [
    ChatMessage(id: UUID().uuidString, conversationId: "5f718d9638428728ef9430dw", sender: currentUser, recipient: nil, messageBody: "I am fine brother", messageType: .text, createdAt: demoCurrentDate, updatedAt: demoCurrentDate),
    
    ChatMessage(id: UUID().uuidString, conversationId: "5f718d9638428728ef9430dd", sender: opponentUser, recipient: nil, messageBody: "whats up bro", messageType: .text, createdAt: demoCurrentDate, updatedAt: demoCurrentDate),
    
    ChatMessage(id: UUID().uuidString, conversationId: "5f718d9638428728ef9430dw", sender: currentUser, recipient: nil, messageBody: "I am fine brother", messageType: .text, createdAt: demoCurrentDate, updatedAt: demoCurrentDate),
    ChatMessage(id: UUID().uuidString, conversationId: "5f718d9638428728ef9430dd", sender: opponentUser, recipient: nil, messageBody: "whats up bro", messageType: .text, createdAt: demoCurrentDate, updatedAt: demoCurrentDate),
    
    ChatMessage(id: UUID().uuidString, conversationId: "5f718d9638428728ef9430dw", sender: currentUser, recipient: nil, messageBody: "I am fine brother", messageType: .text, createdAt: demoCurrentDate, updatedAt: demoCurrentDate),
    ChatMessage(id: UUID().uuidString, conversationId: "5f718d9638428728ef9430dd", sender: opponentUser, recipient: nil, messageBody: "whats up bro", messageType: .text, createdAt: demoCurrentDate, updatedAt: demoCurrentDate),
    
    ChatMessage(id: UUID().uuidString, conversationId: "5f718d9638428728ef9430dw", sender: currentUser, recipient: nil, messageBody: "I am fine brother", messageType: .text, createdAt: demoCurrentDate, updatedAt: demoCurrentDate),
    ChatMessage(id: UUID().uuidString, conversationId: "5f718d9638428728ef9430dd", sender: opponentUser, recipient: nil, messageBody: "whats up bro", messageType: .text, createdAt: demoCurrentDate, updatedAt: demoCurrentDate)
]
