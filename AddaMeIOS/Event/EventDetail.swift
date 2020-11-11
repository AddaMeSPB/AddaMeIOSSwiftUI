//
//  EventDetail.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 26.08.2020.
//

import MapKit
import SwiftUI

struct EventDetail: View {
  
  @State var eventP: EventPlace
  @State var startChat: Bool = false
  @State var askJoinRequest: Bool = false
  
  @ObservedObject var conversationViewModel = ConversationViewModel()
  @Environment(\.colorScheme) var colorScheme
  @Environment(\.presentationMode) private var presentationMode
  
  var event: EventResponse.Item
  var eventPlace: EventPlace
  private let columns = [
    GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())
  ]
  
  init(eventPlace: EventPlace, event: EventResponse.Item) {
    self.event = event
    self.eventPlace = eventPlace
    _eventP = State(initialValue: eventPlace)
  }
  
  var body: some View {
    ScrollView {
      VStack() {
        
        ZStack {
          
          
          AsyncImage(
            urlString: eventData[0].imageUrl,
            placeholder: {
              Text("Loading...").frame(width: 100, height: 100, alignment: .center)
            },
            image: {
              Image(uiImage: $0).resizable()
            }
          )
          .aspectRatio(contentMode: .fill)
          .edgesIgnoringSafeArea(.top)
          .overlay(EventDetailOverlay(event: event, startChat: startChat, askJoinRequest: askJoinRequest, conversationViewModel: conversationViewModel) , alignment: .bottomTrailing)
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
            ForEach( event.conversation.members?.uniqElemets() ?? []) { member in
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
                
                Text(member.fullName)
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
        
        MapView(place: eventPlace, places: [eventPlace], isEventDetailsView: true)
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
    let event = eventData.uniqElemets().sorted()[1]
    let eventP = event.lastPlace()
    
    EventDetail(eventPlace: eventP, event: event)
      .previewDevice(PreviewDevice(rawValue: "iPhone 6+"))
      .previewDisplayName("iPhone 6 Plus")
      .environment(\.colorScheme, .dark)
  }
}


struct EventDetailOverlay: View {
  
  let event: EventResponse.Item
  @State var startChat: Bool = false
  @State var askJoinRequest: Bool = false
  @ObservedObject var conversationViewModel = ConversationViewModel()
  @Environment(\.colorScheme) var colorScheme
  
  var body: some View {
    ZStack {
      VStack(alignment: .trailing) {
        if event.canJoinConversation() {
          Button(action: {
            self.startChat = true
          }, label: {
            Text("Start Chat")
              .font(.system(size: 31, weight: .bold, design: .rounded))
              .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
              .padding(20)
          })
          .sheet(isPresented: self.$startChat) {
            LazyView(
              ChatRoomView(conversation: event.conversation)
                .edgesIgnoringSafeArea(.bottom)
            )
          }
          .frame(height: 50, alignment: .leading)
          .overlay(
            Capsule(style: .continuous).stroke(lineWidth: 1.5)
          )
          
        } else {
          
          if !askJoinRequest {
            Button(action: join, label: {
              Text("JOIN")
                .font(.system(size: 31, weight: .bold, design: .rounded))
                .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                .padding(20)
            })
            .frame(height: 60, alignment: .leading)
            .overlay(
              Capsule(style: .continuous).stroke(lineWidth: 1.3)
            )
            
          } else {
            
            ProgressView("Loading...")
              .frame(minWidth: 100, idealWidth: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealHeight: 50, maxHeight: 60, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
              .progressViewStyle(CircularProgressViewStyle(tint: Color.blue))
              .font(Font.system(.title2, design: .monospaced).weight(.bold))
              .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
              .sheet(isPresented: self.$startChat) {
                LazyView(
                  ChatRoomView(conversation: event.conversation)
                    .edgesIgnoringSafeArea(.bottom)
                )
              }
          }
          
        }
        
        Text(event.name)
          .lineLimit(2)
          .font(.system(size: 31, weight: .light, design: .rounded))
          .padding(.top, 5)
          .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
        
        Text("Created by: " + event.owner.fullName)
          .lineLimit(1)
          .font(.system(size: 17, weight: .light, design: .rounded))
          .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
        
        Text(event.eventPlaces.last?.addressName ?? "")
          .font(.system(size: 17, weight: .light, design: .rounded))
          .lineLimit(2)
          .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
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
