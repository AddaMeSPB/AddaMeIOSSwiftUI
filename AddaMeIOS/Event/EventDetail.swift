//
//  EventDetail.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 26.08.2020.
//

import MapKit
import SwiftUI

struct EventDetail: View {
  
  @ObservedObject var conversationViewModel = ConversationViewModel()
  var event: EventResponse.Item
  
  private let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
  @Environment(\.imageCache) var cache: ImageCache
  @Environment(\.colorScheme) var colorScheme
  @State var startChat: Bool = false
  @State var askJoinRequest: Bool = false
  
  var eventPlace: EventPlace
  @State var eventP: EventPlace
  
  init(eventPlace: EventPlace, event: EventResponse.Item) {
    self.event = event
    self.eventPlace = eventPlace
    _eventP = State(initialValue: eventPlace)
  }
  
  var body: some View {
    ScrollView {
      VStack() {
        HStack(alignment: .bottom) {
          AsyncImage(
            avatarLink: event.owner.avatarUrl,
            placeholder: Text("Loading ..."),
            cache: self.cache, configuration: {
              $0.resizable()
            }
          )
          .aspectRatio(contentMode: .fit)
          .frame(width: 100, height: 100)
          .clipShape(Circle())
          .padding()
          
          VStack {
            VStack(alignment: .center) {
              if event.canJoinConversation() {
                Button(action: {
                  self.startChat = true
                }, label: {
                  Text("Start Chat")
                    .font(.system(size: 17, weight: .bold, design: .serif))
                    .foregroundColor(.white)
                })
                .sheet(isPresented: self.$startChat) {
                  
                  //                                    LazyView(
                  ChatRoomView(conversation: event.conversation)
                    .edgesIgnoringSafeArea(.bottom)
                  //                                    )
                }
                .frame(minWidth: 100, idealWidth: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealHeight: 70, maxHeight: 70, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                //.frame(width: 200, height: 80, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .background(Color.red)
                .clipShape(Capsule())
                
              } else {
                
                if !askJoinRequest {
                  Button(action: join, label: {
                    Text("JOIN")
                      .font(.system(size: 17, weight: .bold, design: .serif))
                      .foregroundColor(.white)
                  })
                  .frame(minWidth: 100, idealWidth: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealHeight: 50, maxHeight: 70, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                  .background(Color.red)
                  .clipShape(Capsule())
                } else {
                  
                  ProgressView("Loading...")
                    .frame(minWidth: 100, idealWidth: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealHeight: 50, maxHeight: 70, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.blue))
                    .font(Font.system(.title2, design: .monospaced).weight(.bold))
                    .sheet(isPresented: self.$startChat) {
                      LazyView(
                        ChatRoomView(conversation: event.conversation)
                          .padding(.bottom, 20)
                          .edgesIgnoringSafeArea(.bottom)
                      )
                    }
                }
                
                
              }
            }
            
            VStack(alignment: .leading) {
              
              Text(event.name)
                .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                .lineLimit(2)
                .alignmentGuide(.leading) { d in d[.leading] }
                .font(.system(size: 25, weight: .light, design: .serif))
                .padding(.top, 25)
              
              Text("created by: " + event.owner.fullName)
                .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                .lineLimit(2)
                .alignmentGuide(.leading) { d in d[.leading] }
                .font(.system(size: 13, weight: .light, design: .serif))
                .padding(.top, 1)
            }
          }
          
          
        }
        .padding()
        
        Text("Event Members:")
          .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
          .lineLimit(2)
          .minimumScaleFactor(0.5)
          .alignmentGuide(.leading) { d in d[.leading] }
          .font(.system(size: 23, weight: .light, design: .serif))
        Divider()
          .padding(.bottom, -10)
        
        ScrollView {
          LazyVGrid(columns: columns, spacing: 10) {
            ForEach( event.conversation.members?.uniqElemets() ?? []) { member in
              VStack(alignment: .leading) {
                AsyncImage(
                  avatarLink: member.avatarUrl,
                  placeholder: Text("Loading ..."),
                  cache: self.cache, configuration: {
                    $0.resizable()
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
                  .font(.system(size: 15, weight: .light, design: .serif))
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
            .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
            .lineLimit(2)
            .minimumScaleFactor(0.5)
            .alignmentGuide(.leading) { d in d[.leading] }
            .font(.system(size: 23, weight: .light, design: .serif))
            .padding()
        }
        
        //let isEventDetailsPage: Binding = .constant(true)
      
//        let checkPP: Binding = .constant(checkP)
//        MapViewModel(checkPoint: checkPP, isEventDetailsPage: isEventDetailsPage)
//          .frame(height: 400)
//          .padding(.bottom, 20)
        
      }
    }
    .edgesIgnoringSafeArea(.bottom)
    .background(colorScheme == .dark ? Color.black : Color.white)
    .padding(.top, 20)
  }
  
  
  func join() {
    self.askJoinRequest = true
    self.conversationViewModel.moveChatRoomAfterAddMember(event: event) { boolRes in
      self.startChat = boolRes
    }
  }
}

//struct EventDetail_Previews: PreviewProvider {
//  static var previews: some View {
//    let event = eventData.uniqElemets().sorted()[1]
//    let geo = event.geoLocations.sorted().last!
//    let checkPoint =
//      
//    EventDetail(eventPlace: )
//      .previewDevice(PreviewDevice(rawValue: "iPhone 6+"))
//      .previewDisplayName("iPhone 6 Plus")
//    //            .environment(\.colorScheme, .dark)
//  }
//}
