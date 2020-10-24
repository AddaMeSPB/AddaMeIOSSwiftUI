//
//  EventDetail.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 26.08.2020.
//

import SwiftUI

struct EventDetail: View {
    
    var event: EventResponse.Item
    private let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    @Environment(\.imageCache) var cache: ImageCache
    @Environment(\.colorScheme) var colorScheme
    
    var currentUser: CurrentUser? {
        didSet {
            guard let currentUSER: CurrentUser = KeychainService.loadCodable(for: .currentUser) else {
                return
            }
            
            self.currentUser = currentUSER
        }
    }
    
    var body: some View {
        ZStack {
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
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
                    .padding()
                    
                    VStack(alignment: .leading) {
                        VStack(alignment: .center) {
                            
                            if event.conversation.admins!.contains(where: { $0.id == AddaMeIOS.currentUser.id }) ||
                                event.conversation.members!.contains(where: { $0.id == AddaMeIOS.currentUser.id }) {
                                
                                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                                    Text("JOIN")
                                        .font(.system(size: 17, weight: .bold, design: .serif))
                                        .foregroundColor(.white)
                                })
                                .frame(width: 80, height: 80, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                .background(Color.red)
                                .clipShape(Circle())
                            } else {
                                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                                    Text("Start Conversation")
                                        .font(.system(size: 17, weight: .bold, design: .serif))
                                        .foregroundColor(.white)
                                })
                                .frame(minWidth: 100, idealWidth: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealHeight: 70, maxHeight: 70, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                //.frame(width: 200, height: 80, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                .background(Color.red)
                                .clipShape(Capsule())
                            }
                            
                        }
                        
                        Text(event.name)
                            .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                            .lineLimit(2)
                            .minimumScaleFactor(0.5)
                            .alignmentGuide(.leading) { d in d[.leading] }
                            .font(.system(size: 21, weight: .light, design: .serif))
                            .padding(.top, 20)
                        
                        Text("created by: " + event.owner.fullName)
                            .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                            .lineLimit(2)
                            .minimumScaleFactor(0.5)
                            .alignmentGuide(.leading) { d in d[.leading] }
                            .font(.system(size: 13, weight: .light, design: .serif))
                            .padding(.top, 1)
                    }
                    
                }
                .padding()
                
                Text("Event Members:")
                    .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                    .lineLimit(2)
                    .minimumScaleFactor(0.5)
                    .alignmentGuide(.leading) { d in d[.leading] }
                    .font(.system(size: 21, weight: .light, design: .serif))
                    .padding(.leading, 20)
                    .padding(.bottom, 5)
                
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
                                    .lineLimit(2)
                                    .minimumScaleFactor(0.5)
                                    .alignmentGuide(.leading) { d in d[.leading] }
                                    .font(.system(size: 17, weight: .light, design: .serif))
                                Spacer()
                            }
                            .padding()
                            
                        }
                    }
                }

                //                Spacer()
                VStack(alignment: .leading) {
                    Text("Event Location:")
                        .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                        .lineLimit(2)
                        .minimumScaleFactor(0.5)
                        .alignmentGuide(.leading) { d in d[.leading] }
                        .font(.system(size: 21, weight: .light, design: .serif))
                        .padding()
                }
                
                Color.blue
                    .frame(height: 300, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .padding()
            }
        }
        .background(colorScheme == .dark ? Color.black : Color.white)
    }
    
    
}

struct EventDetail_Previews: PreviewProvider {
    static var previews: some View {
        EventDetail(event: eventData.uniqElemets().sorted()[2])
            .environment(\.colorScheme, .dark)
    }
}
