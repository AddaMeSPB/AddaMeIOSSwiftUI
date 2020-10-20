//
//  ChatRow.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 28.09.2020.
//

import SwiftUI

struct ChatRow : View {

    var chatMessageResponse: ChatMessageResponse.Item

    @Environment(\.imageCache) var cache: ImageCache

    var body: some View {
        Group {

            if !currenuser(chatMessageResponse.sender.id) {
                HStack {
                    Group {

                        AsyncImage(
                            avatarLink: chatMessageResponse.sender.avatarUrl,
                            placeholder: Text("Loading ..."),
                            cache: self.cache, configuration: {
                                $0.resizable()
                            }
                        )
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                        
                        Text(chatMessageResponse.messageBody)
                            .bold()
                            .padding(10)
                            .foregroundColor(Color.white)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    Spacer()
                }
            }
            else {
                HStack {
                    Group {
                        
                        Spacer()
                        Text(chatMessageResponse.messageBody)
                            .bold()
                            .foregroundColor(Color.white)
                            .padding(10)
                            .background(Color.red)
                            .cornerRadius(10)
                        AsyncImage(
                            avatarLink: chatMessageResponse.sender.avatarUrl,
                            placeholder: Text("Loading ..."), cache: self.cache,
                            configuration: {
                                $0.resizable()
                            }
                        )
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                        
                    }
                }
            }
        }
    }
    
    func currenuser(_ userId: String) -> Bool {
        guard let currentUSER: CurrentUser = KeychainService.loadCodable(for: .currentUser) else {
            return false
        }
        
        return currentUSER.id == userId ? true : false
    
    }
}


//struct ChatRow_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatRow(chatMessageResponse: demoChatMessages.last)
//            .environmentObject(ChatDataHandler())
//    }
//}

