//
//  MessageCellView.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 05.09.2020.
//

import SwiftUI

struct MessageCellView : View {

    let conversation: ConversationResponse.Item
    
    @Environment(\.imageCache) var cache: ImageCache
    
    var body : some View {
        
        HStack(spacing: 15) {
            
            AsyncImage(
                avatarLink: conversation.lastMessage?.sender.avatarUrl,
                placeholder: Text("Loading ..."), cache: self.cache,
                configuration: {
                    $0.resizable()
                }
            )
            .aspectRatio(contentMode: .fit)
            .frame(width: 50, height: 50)
            .clipShape(Circle())
            
            VStack(alignment:.leading,spacing: 5) {
                
                Text(
                    conversation.title
                )
                .font(.system(size: 18, weight: .semibold, design: .serif))
                .foregroundColor(.black)
                
                if conversation.lastMessage != nil {
                    Text(conversation.lastMessage!.messageBody).lineLimit(2)
                }
            }
            .padding(5)
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 10) {
                if conversation.lastMessage != nil {
                    Text("\(conversation.lastMessage!.createdAt?.dateFormatter ?? "")")
                }
                if conversation.lastMessage?.messageBody != "" {
                    Text("6").padding(8).background(Color("bg")).foregroundColor(.white).clipShape(Circle())
                } else{
                    Spacer()
                }
            }
            
        }
        .padding(9)

    }
}

struct MessageCellView_Previews: PreviewProvider {
    static var previews: some View {
        MessageCellView(conversation: demoConversations.last!)
    }
}
