//
//  ChatDetails.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 05.09.2020.
//

import Combine
import SwiftUI

struct ChatRoomView: View {
    
    @State var composedMessage: String = ""
    
    @EnvironmentObject var globalBoolValue: GlobalBoolValue
    @Environment(\.imageCache) var cache: ImageCache
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var messages = [ChatMessageResponse.Item]()
    @StateObject private var chatData = ChatDataHandler()
    let socket = SocketViewModel.shared
    
    var conversation: ConversationResponse.Item!
    
    private func onApperAction() {
        globalBoolValue.isTabBarHidden = false
        self.chatData.conversationsId = conversation.id
        self.chatData.fetchMoreMessages()
        
        self.socket.socket.receive { result in
            
            switch result {
            
            case .success(let message):
                switch message {
                case .data(let data):
                    print(#line, data)
                case .string(let str):
                    print(#line, str)
                    guard let data = str.data(using: .utf8) else { return }
                    
                @unknown default:
                  break
                }
            case .failure(let error):
                print(#line, error)
                
                return
            }
        }
    }
    
    func onComment() {
        if !composedMessage.isEmpty {
            chatData.send(text: composedMessage, conversation: conversation)
        }
    }
    
    var body: some View {
        List {
            // self.chatData.socket.messages[conversation.id] ?? [] // demoLastMessages
            ForEach( self.chatData.socket.messages[conversation.id] ?? []  ) { message in
                ChatRow(chatMessageResponse: message)
                    .onAppear {
                        chatData.fetchMoreMessagIfNeeded(currentItem: message)
                    }
                    .scaleEffect(x: 1, y: -1, anchor: .center)
                    .padding([.top, .bottom], 5)
                    .padding([.leading, .trailing], -10)
                    .hideRowSeparator()
            }
            
            if chatData.isLoadingPage {
                ProgressView()
            }
        }
        .scaleEffect(x: 1, y: -1, anchor: .center)
        .offset(x: 0, y: 2)
        .previewLayout(.sizeThatFits)
        .padding(10)
        .navigationBarTitle("")
        .onAppear(perform: {
            onApperAction()
        })
        .onDisappear(perform: {
            globalBoolValue.isTabBarHidden = true
        })
        .navigationTitle("\(conversation.title)")
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
//                    globalBoolValue.isTabBarHidden = false
//                }) {
//                    Image(systemName: "arrow.left.circle")
//                        .font(.title)
//                }
//            }
        }
        
        ChatBottomView(chatData: chatData, conversation: conversation)
    }

}

struct ChatDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ChatRoomView(conversation: conversationCurrentUser)
            .environmentObject(GlobalBoolValue())
            .environmentObject(ChatDataHandler())
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
//                        globalBoolValue.isTabBarHidden = false
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

struct HideRowSeparatorModifier: ViewModifier {
  static let defaultListRowHeight: CGFloat = 44
  var insets: EdgeInsets
  var background: Color
  init(insets: EdgeInsets, background: Color) {
    self.insets = insets
    var alpha: CGFloat = 0
    UIColor(background).getWhite(nil, alpha: &alpha)
    assert(alpha == 1, "Setting background to a non-opaque color will result in separators remaining visible.")
    self.background = background
  }
  func body(content: Content) -> some View {
    content
      .padding(insets)
      .frame(
        minWidth: 0, maxWidth: .infinity,
        minHeight: Self.defaultListRowHeight,
        alignment: .leading
      )
      .listRowInsets(EdgeInsets())
      .background(background)
  }
}
extension EdgeInsets {
  static let defaultListRowInsets = Self(top: 0, leading: 16, bottom: 0, trailing: 16)
}
extension View {
  func hideRowSeparator(
    insets: EdgeInsets = .defaultListRowInsets,
    background: Color = .white
  ) -> some View {
    modifier(HideRowSeparatorModifier(
      insets: insets,
      background: background
    ))
  }
}
