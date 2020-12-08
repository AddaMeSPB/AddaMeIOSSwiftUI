//
//  EventDetail.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 26.08.2020.
//

import MapKit
import SwiftUI

struct EventDetail: View {
  
  let image = ImageDraw()
  @State var eventP: EventResponse.Item
  @State var startChat: Bool = false
  @State var askJoinRequest: Bool = false
  
  @ObservedObject var conversationViewModel = ConversationViewModel()
  @Environment(\.colorScheme) var colorScheme
  @Environment(\.presentationMode) private var presentationMode
  
  var event: EventResponse.Item
  private let columns = [
    GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())
  ]
  
  init(event: EventResponse.Item) {
    self.event = event
    _eventP = State(initialValue: event)
    conversationViewModel.find(conversationsId: event.conversationsId)
  }
  
  @ViewBuilder var body: some View {
    ScrollView {
      VStack() {
        ZStack {
          if event.imageUrl != nil {
            AsyncImage(
              urlString: event.imageUrl,
              placeholder: {
                Text("Loading...").frame(width: 100, height: 100, alignment: .center)
              },
              image: {
                Image(uiImage: $0).resizable()
              }
            )
            .aspectRatio(contentMode: .fill)
            .edgesIgnoringSafeArea(.top)
            .overlay(
              EventDetailOverlay(event: event, conversation: conversationViewModel.conversation, startChat: self.$startChat, askJoinRequest: self.$askJoinRequest).environmentObject(conversationViewModel),
              alignment: .bottomTrailing
            )
            .overlay(
              Button {
                presentationMode.wrappedValue.dismiss()
              } label: {
                Image(systemName: "xmark.circle.fill")
                  .imageScale(.large)
                  .frame(width: 60, height: 60, alignment: .center)
              }
              .padding([.top, .trailing], 10),
              alignment: .topTrailing
            )
          } else {
            Image(uiImage: image.random())
              .resizable()
              .aspectRatio(contentMode: .fill)
              .overlay(
                EventDetailOverlay(event: event, conversation: conversationViewModel.conversation, startChat: self.$startChat, askJoinRequest: self.$askJoinRequest).environmentObject(conversationViewModel),
                alignment: .bottomTrailing
              )
              .overlay(
                Button {
                  presentationMode.wrappedValue.dismiss()
                } label: {
                  Image(systemName: "xmark.circle.fill")
                    .imageScale(.large)
                    .frame(width: 60, height: 60, alignment: .center)
                }
                .padding([.top, .trailing], 10),
                alignment: .topTrailing
              )
          }
          
        }
        
        Text("Event Members:")
          .font(.title)
          .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
          .lineLimit(2)
          .minimumScaleFactor(0.5)
          .alignmentGuide(.leading) { d in d[.leading] }
          .font(.system(size: 23, weight: .light, design: .rounded))
        Divider()
          .padding(.bottom, -10)
        
        ScrollView {
          LazyVGrid(columns: columns, spacing: 10) {
            ForEach( conversationViewModel.conversation.members?.uniqElemets() ?? []) { member in
              VStack(alignment: .leading) {
                
                AsyncImage(
                  urlString: member.avatarUrl,
                  placeholder: {
                    Text("Loading...").frame(width: 100, height: 100, alignment: .center)
                  },
                  image: {
                    Image(uiImage: $0).resizable()
                  }
                )
                .aspectRatio(contentMode: .fit)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50)
                .clipShape(Circle())
                .padding()
                
                Text("\(member.fullName)")
                  .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                  .lineLimit(1)
                  .alignmentGuide(.leading) { d in d[.leading] }
                  .font(.system(size: 15, weight: .light, design: .rounded))
                Spacer()
              }
              .padding()
              
            }
          }
          
        }
        
        // Spacer()
        Divider()
        VStack(alignment: .leading) {
          Text("Event Location:")
            .font(.title)
            .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
            .lineLimit(2)
            .minimumScaleFactor(0.5)
            .alignmentGuide(.leading) { d in d[.leading] }
            .font(.system(size: 23, weight: .light, design: .rounded))
            .padding()
        }
        
        MapView(place: event, places: [event], isEventDetailsView: true)
          .frame(height: 400)
          .padding(.bottom, 20)
        
      }
    }
    .edgesIgnoringSafeArea(.top)
    .edgesIgnoringSafeArea(.bottom)
    .background(Color(.systemBackground))
  }

}

struct EventDetail_Previews: PreviewProvider {
  static var previews: some View {
    let event = eventData[1]
    
    EventDetail(event: event)
      .previewDevice(PreviewDevice(rawValue: "iPhone 6+"))
      .previewDisplayName("iPhone 6 Plus")
      .environment(\.colorScheme, .dark)
  }
}


struct EventDetailOverlay: View {
  
  let event: EventResponse.Item
  let conversation: ConversationResponse.Item
  @Binding var startChat: Bool
  @Binding var askJoinRequest: Bool
  @EnvironmentObject var conversationViewModel: ConversationViewModel
  @Environment(\.colorScheme) var colorScheme
  
  @ViewBuilder var body: some View {
    ZStack {
      VStack(alignment: .trailing) {
        if conversation.canJoinConversation() {
          Button(action: {
            self.startChat = true
          }, label: {
            Text("Start Chat")
              .font(.system(size: 31, weight: .bold, design: .rounded))
              .foregroundColor(Color.white)
              .padding(20)
          })
          .sheet(isPresented: self.$startChat) {
            LazyView(
              ChatRoomView(conversation: conversation, fromContactsOrEvents: true)
            )
          }
          .frame(height: 50, alignment: .leading)
          .overlay(
            Capsule(style: .continuous).stroke(Color.white, lineWidth: 1.5)
          )
          
        } else {
          
          if !askJoinRequest {
            Button(action: join, label: {
              Text("JOIN")
                .font(.system(size: 31, weight: .bold, design: .rounded))
                .foregroundColor(Color.white)
                .padding(20)
            })
            .frame(height: 60, alignment: .leading)
            .overlay(
              Capsule(style: .continuous).stroke(Color.white, lineWidth: 1.3)
            )
            
          } else {
            
            ProgressView("Loading...")
              .frame(minWidth: 100, idealWidth: 100, maxWidth: .infinity, minHeight: 0, idealHeight: 50, maxHeight: 60, alignment: .center)
              .progressViewStyle(CircularProgressViewStyle(tint: Color.blue))
              .font(Font.system(.title2, design: .monospaced).weight(.bold))
              .foregroundColor(Color.white)
              .sheet(isPresented: self.$startChat) {
                LazyView(
                  ChatRoomView(conversation: conversation, fromContactsOrEvents: true)
                    .edgesIgnoringSafeArea(.bottom)
                )
              }
          }
          
        }
        
        Text(event.name)
          .lineLimit(2)
          .font(.system(size: 31, weight: .light, design: .rounded))
          .padding(.top, 5)
          .foregroundColor(Color.white)
        
        Text("Created by: " + "conversation.owner.fullName")
          .lineLimit(1)
          .font(.system(size: 17, weight: .light, design: .rounded))
          .foregroundColor(Color.white)
        
        Text(event.addressName)
          .font(.system(size: 17, weight: .light, design: .rounded))
          .lineLimit(2)
          .foregroundColor(Color.white)
      }
    }
    .padding(5)
  }
  
  func join() {
    self.askJoinRequest = true
    self.conversationViewModel.moveChatRoomAfterAddMember(event: event) { boolRes in
      self.startChat = boolRes
    }
  }
  
}
