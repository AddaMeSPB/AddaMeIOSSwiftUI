//
//  ChatDetailsTopview.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 05.09.2020.
//

import SwiftUI

//struct ChatDetailsTopview: View {
//    
//    //var chatData = ChatDataHandler()
////    @StateObject private var model = ChatScreenModel()
//    
//    var conversation: ConversationResponse.Item
//    @Environment(\.imageCache) var cache: ImageCache
//    
//    var body : some View {
//        
//        HStack(spacing: 15) {
//            
//            Button(action: {
//                //self.chatData.show.toggle()
//            }) {
//                Image(systemName: "control")
//                    .font(.title)
//                    .rotationEffect(.init(degrees: -90))
//            }
//            
//            Spacer()
//            
//            VStack(spacing: 5) {
//                if conversation.lastMessage != nil {
//                    AsyncImage(
//                        avatarLink: conversation.lastMessage?.sender.avatarUrl,
//                        placeholder: Text("Loading..."),
//                        cache: self.cache,
//                        configuration: {
//                            $0.resizable()
//                    })
//                    .frame(width: 45, height: 45)
//                    .clipShape(Circle())
//                
//                    Text(conversation.title) // will check for 1to1 chat
//                        .fontWeight(.heavy)
//                
//                }
//            }.offset(x: 25)
//            
//            Spacer()
//            
//            Button(action: {
//                
//            }) {
//                Image(systemName: "phone.fill")
//                    .resizable()
//                    .frame(width: 20, height: 20)
//                
//            }.padding(.trailing, 25)
//            
//            Button(action: {
//                
//            }) {
//                Image(systemName: "video.fill")
//                    .resizable()
//                    .frame(width: 23, height: 16)
//            }
//            
//        }.foregroundColor(.white)
//            .padding()
//            .padding(.top, -15)
//            .padding(.bottom, -15)
//    }
//}
//
//struct ChatDetailsTopview_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatDetailsTopview(conversation: demoConversations.last!)
//    }
//}
