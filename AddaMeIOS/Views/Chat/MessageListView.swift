//
//  MessageListView.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 05.09.2020.
//

import SwiftUI

struct MessageListView: View {
    var chatDataLastMessage = [LastMessage]()
    @EnvironmentObject var chatData: ChatDataHandle
    @EnvironmentObject var globalBoolValue: GlobalBoolValue
    
    var body : some View {
        ZStack {
            List(demoLastMessages) { lm in // chatData.lastMessages
                MessageCellView(lastMsg: lm)
                    .onTapGesture {
                        DispatchQueue.main.async {
                            self.chatData.show.toggle()
                            self.globalBoolValue.isTabBarHidden.toggle()
                        }
                    }.background(Color(#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)))
            }
            
        }

    }
}


struct MessageListView_Previews: PreviewProvider {
    static var previews: some View {
        MessageListView(chatDataLastMessage: demoLastMessages)
    }
}

let timestamp = Date().timeIntervalSince1970
let demoLastMessages = [
    LastMessage(id: "5f718d9638428728ef9430db", senderID: currentUser.id, phoneNumber: currentUser.phoneNumber, firstName: currentUser.fullName, lastName: "", avatar: currentUser.avatarUrl!, messageBody: "Here we go ", totalUnreadMessages: 4, timestamp: Int(timestamp)),
    LastMessage(id: "5f718d9638428728ef9430dc", senderID: opponentUser.id, phoneNumber: opponentUser.phoneNumber, firstName: opponentUser.fullName, lastName: "", avatar: opponentUser.avatarUrl!, messageBody: "WOW", totalUnreadMessages: 55, timestamp: Int(timestamp))
]
