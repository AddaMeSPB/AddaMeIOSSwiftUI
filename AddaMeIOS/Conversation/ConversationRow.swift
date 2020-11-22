//
//  ConversationRow.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 05.09.2020.
//

import SwiftUI


struct ConversationRow: View {
  
  let image = ImageDraw()
  var conversation: ConversationResponse.Item
  
  @Environment(\.imageCache) var cache: ImageCache
  @Environment(\.presentationMode) var presentationMode
  @Environment(\.colorScheme) var colorScheme
  
  var body : some View {
    Group {
      HStack(spacing: 0) {
        if conversation.lastMessage?.sender.avatarUrl != nil {
        AsyncImage(
          urlString: conversation.lastMessage?.sender.avatarUrl,
          placeholder: {
            Text("Loading...").frame(width: 100, height: 100, alignment: .center)
          },
          image: {
            Image(uiImage: $0).resizable()
          }
        )
        .aspectRatio(contentMode: .fit)
        .frame(width: 50, height: 50)
        .clipShape(Circle())
        .padding(.trailing, 5)
      } else {
        Image(uiImage: image.random())
          .aspectRatio(contentMode: .fit)
          .frame(width: 50, height: 50)
          .clipShape(Circle())
        }
        
        VStack(alignment: .leading, spacing: 5) {
          Text(conversation.title)
            .lineLimit(1)
            .font(.system(size: 18, weight: .semibold, design: .rounded))
            .foregroundColor(Color(.systemBlue))
          
          if conversation.lastMessage != nil {
            Text(conversation.lastMessage!.messageBody).lineLimit(1)
          }
        }
        .padding(5)
        
        Spacer(minLength: 3)
        
        VStack(alignment: .trailing, spacing: 5) {
          if conversation.lastMessage != nil {
            Text("\(conversation.lastMessage!.createdAt?.dateFormatter ?? String.empty)")
          }
          
          if conversation.lastMessage?.messageBody != String.empty {
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

//struct ConversationRow_Previews: PreviewProvider {
//  static var previews: some View {
//    ConversationRow(conversation: demoConversations[0])
//  }
//}
