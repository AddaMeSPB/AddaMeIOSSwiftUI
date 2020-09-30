//
//  ChatRow.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 28.09.2020.
//

import SwiftUI

struct ChatRow : View {

    var chatMessage: ChatMessage

    @EnvironmentObject var currentUserVM: CurrentUserViewModel
    @Environment(\.imageCache) var cache: ImageCache

    var body: some View {
        Group {
            if currentUserVM.currentUser?.id != chatMessage.sender.id {
                HStack {
                    Group {

                        AsyncImage(
                            url: URL(string: chatMessage.sender.avatarUrl ??  "https://image.tmdb.org/t/p/original/pThyQovXQrw2m0s9x82twj48Jq4.jpg")!,
                            placeholder: Text("Loading ..."), cache: self.cache,
                            configuration: {
                                $0.resizable()
                            }
                        )
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                        
                        Text(chatMessage.messageBody)
                            .bold()
                            .padding(10)
                            .foregroundColor(Color.white)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    Spacer()
                }
            } else {
                HStack {
                    Group {
                        
                        Spacer()
                        Text(chatMessage.messageBody)
                            .bold()
                            .foregroundColor(Color.white)
                            .padding(10)
                            .background(Color.red)
                            .cornerRadius(10)
                        AsyncImage(
                            url: URL(string: chatMessage.sender.avatarUrl ??  "https://image.tmdb.org/t/p/original/pThyQovXQrw2m0s9x82twj48Jq4.jpg")!,
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
}


struct ChatRow_Previews: PreviewProvider {
    static var previews: some View {
        ChatRow(chatMessage: demoChatMessages.last!)
            .environmentObject(ChatDataHandle())
    }
}

