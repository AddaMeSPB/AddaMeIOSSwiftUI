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
    
    @EnvironmentObject var data: MsgDatas
    @EnvironmentObject var chatData: ChatDataHandle
    
    
    var body: some View {
        ZStack {
            
            Color("bg").edgesIgnoringSafeArea(.top)
            
            VStack(spacing: 0) {
                
                // ChatDetailsTopview()
                // when you this view back button does not work
                HStack(spacing: 15) {
                    
                    Button(action: {
                        self.data.show.toggle()
                    }) {
                        Image(systemName: "control")
                            .font(.title)
                            .rotationEffect(.init(degrees: -90))
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 5) {
                        Image(data.selectedData.pic)
                            .resizable()
                            .frame(width: 45, height: 45)
                            .clipShape(Circle())
                        
                        Text(data.selectedData.name)
                            .fontWeight(.heavy)
                        
                    }.offset(x: 25)
                    
                    Spacer()
                    
                    Button(action: {
                        
                    }) {
                        Image(systemName: "phone.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                        
                    }.padding(.trailing, 25)
                    
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

                
                GeometryReader { _ in
                    VStack {
                        List {
                            ForEach(self.chatData.messages, id: \.self) { msg in
                                ChatRow(chatMessage: msg)
                            }
                        }
                        .onAppear(perform: {
                            UITableView.appearance().separatorStyle = .none
                        })

                        HStack {
                            // this textField generates the value for the composedMessage @State var
                            TextField("Message...", text: self.$composedMessage).frame(minHeight: CGFloat(30))
                            // the button triggers the sendMessage() function written in the end of current View
                            Button(action: self.sendMessage) {
                                Text("Send")
                            }
                        }.frame(minHeight: CGFloat(50))
                            .padding()
                    }
                }
                .background(Color.white)
                
                ChatBottomView()
                
            }.navigationBarTitle("")
                .navigationBarHidden(true)
        }
    }
    
    func sendMessage() {
        chatData.sendMessage(ChatMessage(message: composedMessage, avatar: "Alif", color: .red, isMe: true))
        composedMessage = ""
    }
}

struct ChatDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ChatDetailsView()
        .environmentObject(ChatDataHandle())
        .environmentObject(MsgDatas())
    }
}

class ChatDataHandle: ObservableObject {

    var didChange = PassthroughSubject<Void, Never>()

    @Published var messages = [
        ChatMessage(message: "Hello world", avatar: "Anastaisa", color: .red),
        ChatMessage(message: "Hi", avatar: "Rafael", color: .blue)
    ]
    
    func sendMessage(_ chatMessage: ChatMessage) {
        messages.append(chatMessage)
        didChange.send(())
    }
}

struct ChatMessage : Hashable {
    var message: String
    var avatar: String
    var color: Color
    // isMe will be true if We sent the message
    var isMe: Bool = false
}

struct ChatRow : View {

    var chatMessage: ChatMessage

    var body: some View {
        Group {
            if !chatMessage.isMe {
                HStack {
                    Group {
                        
                        Image(chatMessage.avatar)
                            .resizable()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                        
                        Text(chatMessage.message)
                            .bold()
                            .padding(10)
                            .foregroundColor(Color.white)
                            .background(chatMessage.color)
                            .cornerRadius(10)
                    }
                }
            } else {
                HStack {
                    Group {
                        Spacer()
                        Text(chatMessage.message)
                            .bold()
                            .foregroundColor(Color.white)
                            .padding(10)
                            .background(chatMessage.color)
                            .cornerRadius(10)
                        Image(chatMessage.avatar)
                        .resizable()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                    }
                }
            }
        }

    }
}
