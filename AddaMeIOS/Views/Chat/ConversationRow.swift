//
//  ConversationRow.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 05.09.2020.
//

import SwiftUI


struct ConversationRow: View {
    
    var conversation: ConversationResponse.Item
    
    @Environment(\.imageCache) var cache: ImageCache
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    
    var body : some View {
        Group {
            HStack(spacing: 0) {
                
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
                .padding(.trailing, 5)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(conversation.title)
                    .lineLimit(1)
                    .font(.system(size: 18, weight: .semibold, design: .serif))
                    .foregroundColor(Color(.systemBlue))
                    
                    if conversation.lastMessage != nil {
                        Text(conversation.lastMessage!.messageBody).lineLimit(1)
                    }
                }
                .padding(5)
                
                Spacer(minLength: 3)
                
                VStack(alignment: .trailing, spacing: 5) {
                    if conversation.lastMessage != nil {
                        Text("\(conversation.lastMessage!.createdAt?.dateFormatter ?? "")")
                    }
                    
                    if conversation.lastMessage?.messageBody != "" {
                        //Text("6").padding(8).background(Color("bg"))
                          //  .foregroundColor(.white).clipShape(Circle())
                    } else {
                        Spacer()
                    }
                }
                
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 20, alignment: .leading)
            .padding(2)
        }
    }
}

struct ConversationRow_Previews: PreviewProvider {
    static var previews: some View {
        ConversationRow(conversation: demoConversations[0])
    }
}
