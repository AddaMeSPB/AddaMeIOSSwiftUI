//
//  ChatDetails.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 05.09.2020.
//

import Combine
import SwiftUI

struct ChatDetailsView: View {
    
    @State var composedMessage: String = ""
    
    //@EnvironmentObject var chatData: ChatDataHandle
    @EnvironmentObject var globalBoolValue: GlobalBoolValue
    @EnvironmentObject var currentUserVM: CurrentUserViewModel
    @Environment(\.imageCache) var cache: ImageCache
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var chatData = ChatDataHandle()
   
    
    private func onApperAction() {
        chatData.connect()
    }
    
    private func onDisapperAction() {
        chatData.disconnect()
    }
    
    func onComment() {
        if !composedMessage.isEmpty {
            chatData.send(text: composedMessage)
        }
    }
    
    private func scrollToLastMessage(proxy: ScrollViewProxy) {
        if let lastMessage = chatData.messages.last {
            withAnimation(.easeOut(duration: 0.4)) {
                proxy.scrollTo(lastMessage.id, anchor: .bottom)
            }
        }
    }
    
    var body: some View {
        ZStack {
            
            Color("bg")
                .edgesIgnoringSafeArea(.top)
            
            VStack(spacing: 0) {
                
                // ChatDetailsTopview()
                // when you this view back button does not work
                HStack(spacing: 15) {
                    
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                        self.chatData.show.toggle()
                        self.globalBoolValue.isTabBarHidden.toggle()
                    }) {
                        Image(systemName: "control")
                            .font(.title)
                            .rotationEffect(.init(degrees: -90))
                    }
                    
                    Spacer(minLength: 5)
                    
                    HStack(spacing: 5) {
                        
                        AsyncImage(
                            url: URL(string: chatData.messages.last?.sender.avatarUrl ?? "https://image.tmdb.org/t/p/original/pThyQovXQrw2m0s9x82twj48Jq4.jpg")!,
                            placeholder: Text("Loading ..."),
                            cache: self.cache,
                            configuration: {
                                $0.resizable()
                            }
                        )
                        .frame(width: 35, height: 35)
                        .clipShape(Circle())

                        Text((chatData.messages.last?.sender.phoneNumber) ?? "+79218821217")
                            .fontWeight(.heavy)
                    }
                    //.offset(x: )
                    
                    //Spacer()
                    
                    Button(action: {
                        
                    }) {
                        Image(systemName: "phone.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                        
                    }.padding(.trailing, 20)
                    
                    Button(action: {
                        
                    }) {
                        Image(systemName: "video.fill")
                            .resizable()
                            .frame(width: 23, height: 16)
                    }
                    
                }.foregroundColor(.white)
                    .padding()
                    .padding(.top, -15)
                    .padding(.bottom, -15)
                
                ScrollView {
                    ScrollViewReader{ proxy in
                        LazyVStack(spacing: 8) {
                            ForEach(self.chatData.messages) { message in
                                ChatRow(chatMessage: message)
                            }
                        }
                        .padding(10)
                        .onChange(of: self.chatData.messages.count) { _ in
                            scrollToLastMessage(proxy: proxy)
                        }
                    }
                }
                .background(Color.white)
                
                ChatBottomView(chatData: chatData)
                
            }.navigationBarTitle("")
            .onAppear(perform: {
                onApperAction()
            })
            .onDisappear(perform: {
                onDisapperAction()
            })
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
        }
    }

}

struct ChatDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ChatDetailsView()
        //.environmentObject(ChatDataHandle())
        .environmentObject(ChatDataHandle())
    }
}
