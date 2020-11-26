//
//  ChatRow.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 28.09.2020.
//

import SwiftUI

struct ChatRow : View {
  let image = ImageDraw()
  var chatMessageResponse: ChatMessageResponse.Item
  
  @Environment(\.colorScheme) var colorScheme
  
  @ViewBuilder var body: some View {
    Group {
      
      if !currenuser(chatMessageResponse.sender.id) {
        HStack {
          Group {
            
            if chatMessageResponse.sender.avatarUrl != nil {
              AsyncImage(
                urlString: chatMessageResponse.sender.avatarUrl,
                placeholder: { Text("Loading...").frame(width: 40, height: 40, alignment: .center) },
                image: {
                  Image(uiImage: $0).resizable()
                }
              )
              .aspectRatio(contentMode: .fit)
              .frame(width: 40, height: 40)
              .clipShape(Circle())
            } else {
              Image(uiImage: image.random())
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
                .clipShape(Circle())
            }
            
            Text(chatMessageResponse.messageBody)
              .bold()
              .padding(10)
              .foregroundColor(Color.white)
              .background(Color.blue)
              .cornerRadius(10)
          }
          .background(Color(.systemBackground))
          Spacer()
        }
        .background(Color(.systemBackground))
      } else {
        HStack {
          Group {
            Spacer()
            Text(chatMessageResponse.messageBody)
              .bold()
              .foregroundColor(Color.white)
              .padding(10)
              .background(Color.red)
              .cornerRadius(10)
            
            if chatMessageResponse.sender.avatarUrl != nil {
              AsyncImage(
                urlString: chatMessageResponse.sender.avatarUrl,
                placeholder: { Text("Loading...").frame(width: 40, height: 40, alignment: .center) },
                image: {
                  Image(uiImage: $0).resizable()
                }
              )
              .aspectRatio(contentMode: .fit)
              .frame(width: 40, height: 40)
              .clipShape(Circle())
            } else {
              Image(uiImage: image.random())
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
                .clipShape(Circle())
            }
            
          }
          
        }
        .background(Color(.systemBackground))
      }
    }
    .background(Color(.systemBackground))
  }
  
  func currenuser(_ userId: String) -> Bool {
    guard let currentUSER: CurrentUser = KeychainService.loadCodable(for: .currentUser) else {
      return false
    }
    
    return currentUSER.id == userId ? true : false
    
  }
}


struct ChatRow_Previews: PreviewProvider {
  static var previews: some View {
    ChatRow(chatMessageResponse: chatDemoData[1])
      .environmentObject(ChatDataHandler())
      .environment(\.colorScheme, .dark)
  }
}

// fixed this image issue i mean night mode issue
//#imageLiteral(resourceName: "IMG_9505 3.PNG")
