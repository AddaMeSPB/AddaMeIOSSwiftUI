//
//  ChatDetails.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 05.09.2020.
//

import Combine
import SwiftUI

struct ChatRoomView: View {
        
    @Environment(\.imageCache) var cache: ImageCache
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject private var chatData = ChatDataHandler()

    @State var composedMessage: String = ""
    @State var conversation: ConversationResponse.Item!
    
    private func onApperAction() {
        self.chatData.conversationsId = conversation.id
        self.chatData.fetchMoreMessages()
    }
    
    func onComment() {
        if !composedMessage.isEmpty {
            chatData.send(text: composedMessage)
        }
    }
    
    var body: some View {
        ScrollView {
            // self.chatData.socket.messages[conversation.id] ?? [] // demoLastMessages
            ForEach( self.chatData.socket.messages[conversation.id] ?? [] ) { message in
                ChatRow(chatMessageResponse: message)
                    .padding([.top, .bottom], 5)
                    .padding([.leading, .trailing], -10)
                    .onAppear {
                        self.chatData.fetchMoreMessagIfNeeded(currentItem: message)
                    }
                    .scaleEffect(x: 1, y: -1, anchor: .center)
                    .hideRowSeparator()
                    .background(Color(.systemBackground))
                    .foregroundColor(Color(.systemBackground))
            }
            
            
            if self.chatData.isLoadingPage {
                ProgressView()
            }
        }
        .scaleEffect(x: 1, y: -1, anchor: .center)
        .offset(x: 0, y: 2)
        .previewLayout(.sizeThatFits)
        .padding(10)
        .onAppear(perform: {
            onApperAction()
        })
        .navigationBarTitle("\(conversation.title)", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing ) {
                Button(action: {
                    //
                }) {
                    Image(systemName: "plus").resizable().frame(width: 20, height: 20)
                }
            }
            
//            ToolbarItem(placement: .navigationBarLeading ) {
//                Button(action: {
//                    self.presentationMode.wrappedValue.dismiss()
//                    appState.tabBarIsHidden = false
//                }) {
//                    Image(systemName: "arrow.left.circle")
//                        .font(.title)
//                }
//            }
        }
        .background(Color(.systemBackground))
        
        
        ChatBottomView(chatData: chatData)
    }

}

struct ChatDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ChatRoomView(conversation: conversationData.last!)
            .environmentObject(GlobalBoolValue())
            .environmentObject(ChatDataHandler())
            .environment(\.colorScheme, .dark)
    }
}

//        ZStack {
//
//            Color("bg")
//                .edgesIgnoringSafeArea(.top)
//
//            VStack(alignment: .center) {
//
//                HStack(spacing: 15) {
//
//                    Button(action: {
//                        self.presentationMode.wrappedValue.dismiss()
//                        appState.tabBarIsHidden = false
//                    }) {
//                        Image(systemName: "control")
//                            .font(.title)
//                            .rotationEffect(.init(degrees: -90))
//                    }
//
//                    Spacer(minLength: 5)
//
//                    HStack(spacing: 5) {
//
//                        AsyncImage(
//                            avatarLink: chatData.messages.last?.sender.avatarUrl,
//                            placeholder: Text("Loading ..."),
//                            cache: self.cache,
//                            configuration: {
//                                $0.resizable()
//                            }
//                        )
//                        .frame(width: 35, height: 35)
//                        .clipShape(Circle())
//
//                        Text(conversation.title)
//                            .fontWeight(.heavy)
//                    }
//                    //.offset(x: )
//
//                    Spacer(minLength: 5)
//// For Calling Funtutions buttons
////                    Button(action: {
////
////                    }) {
////                        Image(systemName: "phone.fill")
////                            .resizable()
////                            .frame(width: 20, height: 20)
////
////                    }.padding(.trailing, 20)
////
////                    Button(action: {
////
////                    }) {
////                        Image(systemName: "video.fill")
////                            .resizable()
////                            .frame(width: 23, height: 16)
////                    }
//
//                }.foregroundColor(.white)
//                    .padding()
//                    .padding(.top, -15)
//                    .padding(.bottom, -15)
//
//
//            }
//
//        }
