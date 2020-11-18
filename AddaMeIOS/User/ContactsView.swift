//
//  ContactsView.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 02.09.2020.
//

import SwiftUI
import Contacts
import Foundation

struct ContactsView: View {
  //    @State var expand = false
  //    @State var searchExpand = true
  @EnvironmentObject var store: ContactStore
  @StateObject var conversationView = ConversationViewModel()
  @Environment(\.colorScheme) var colorScheme
  @State var startChat = false
  @State var conversation: ConversationResponse.Item?
  
  var body: some View {
    List(store.contacts, id: \.self) { contact in //demoContacts
      HStack {
        if contact.avatar == nil {
          Image(systemName: contact.avatar ?? "person.circle")
            .resizable()
            .frame(width: 55, height: 55)
            .clipShape(Circle())
            .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
        } else {
          AsyncImage(
            urlString: contact.avatar,
            placeholder: { Text("Loading...").frame(width: 55, height: 55, alignment: .center) },
            image: {
              Image(uiImage: $0).resizable()
            }
          )
          .aspectRatio(contentMode: .fit)
          .frame(width: 55)
          .padding()
          .clipShape(Circle())
        }
        
        
        VStack(alignment: .leading) {
          Text(contact.fullName ?? String.empty)
          Text(contact.phoneNumber)
        }
        
        Spacer(minLength: 0)
        
        Button(action: {
          startChat(contact)
        }, label: {
          Image(systemName: "bubble.left.and.bubble.right.fill")
            .imageScale(.large)
            .frame(width: 60, height: 60, alignment: .center)
        })
        .sheet(isPresented: $conversationView.startChat) {
          LazyView(
            ChatRoomView(conversation: conversationView.conversation)
              .edgesIgnoringSafeArea(.bottom)
          )
        }
        
      }
      //return Text(contact.name)
    }.onAppear {
      DispatchQueue.main.async {
        self.store.buildContacts()
      }
    }
  }
  
  func startChat(_ contact: Contact) {
    guard let currentUSER: CurrentUser = KeychainService.loadCodable(for: .currentUser) else {
        return
    }
    
    let conversation = CreateConversation(
      title: "\(currentUSER.fullName), \(contact.fullName ?? String.empty)",
      type: .oneToOne,
      opponentPhoneNumber: contact.phoneNumber
    )
    
    conversationView.startOneToOneChat(conversation)
  
  }
}

struct ContactsView_Previews: PreviewProvider {
  static var previews: some View {
    ContactsView()
      .environmentObject(ContactStore())
  }
}
