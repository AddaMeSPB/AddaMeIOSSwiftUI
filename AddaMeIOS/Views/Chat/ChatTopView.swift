//
//  ChatTopView.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 05.09.2020.
//

import SwiftUI

struct ChatTopView: View {
    @State var expand = false
    @EnvironmentObject var chatData: ChatDataHandle
    @EnvironmentObject var globalBoolValue: GlobalBoolValue
    
    var body: some View {
        
        ZStack {
            
            HStack(spacing: 16) {
                Text("Chats")
                    .fontWeight(.heavy)
                    .font(.system(size: 23))
                
                Spacer()
                
                Button(action: {
                
                }) {
                    Image(systemName: "magnifyingglass").resizable().frame(width: 20, height: 20)
                }
                .padding(.trailing, 10)
                
                Button(action: {
                    self.chatData.show.toggle()
                }) {
                    Image(systemName: "plus").resizable().frame(width: 20, height: 20)
                }
            }
            .foregroundColor(Color.white)
            .padding()
            .padding(.bottom, -13)
        }
        
    }
}

struct ChatTopView_Previews: PreviewProvider {
    static var previews: some View {
        ChatTopView()
            .environmentObject(ChatDataHandle())
    }
}
