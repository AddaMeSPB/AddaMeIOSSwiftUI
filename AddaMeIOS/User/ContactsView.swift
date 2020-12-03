//
//  ContactsView.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 02.09.2020.
//

import SwiftUI
import Contacts
import Foundation
import CoreData

struct ContactsView: View {
  //    @State var expand = false
  //    @State var searchExpand = true
  
//  @Environment(\.managedObjectContext) private var viewContext
  
//  @FetchRequest(
//    entity: ContactEntity.entity(),
//    sortDescriptors: [NSSortDescriptor(keyPath: \ContactEntity.fullName, ascending: true)],
//    predicate: NSPredicate(format: "isRegister == true"),
//    animation: .default
//  ) private var resContacts: FetchedResults<ContactEntity>
  
  var contacts = PersistenceController.shared.getContacts()

  @EnvironmentObject var store: ContactStore
  @StateObject var conversationView = ConversationViewModel()
  @Environment(\.colorScheme) var colorScheme
  @State var startChat = false
  @State var conversation: ConversationResponse.Item?

  var body: some View {
    List {
      ForEach(contacts, id: \.identifier) { contact in
        HStack {
          if contact.avatar == nil {
            Image(systemName: "person.crop.circle.fill")
              .resizable()
              .frame(width: 55, height: 55)
              .clipShape(Circle())
              .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
          } else {
            AsyncImage(
              urlString: contact.avatar,
              placeholder: { Text("Loading...").frame(width: 35, height: 35, alignment: .center) },
              image: {
                Image(uiImage: $0).resizable()
              }
            )
            .aspectRatio(contentMode: .fit)
            .frame(width: 45)
            .clipShape(Circle())
            
          }
          
          
          VStack(alignment: .leading) {
            Text(contact.fullName)
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
              ChatRoomView(conversation: conversationView.conversation, fromContactsOrEvents: true)
                .edgesIgnoringSafeArea(.bottom)
            )
          }
          
        }
      }
    }
    .navigationBarTitle("Contacts", displayMode: .automatic)
  }
  
  func startChat(_ contact: ContactEntity) {
    guard let currentUSER: CurrentUser = KeychainService.loadCodable(for: .currentUser) else {
        return
    }
    
    let conversation = CreateConversation(
      title: "\(currentUSER.fullName), \(contact.fullName)",
      type: .oneToOne,
      opponentPhoneNumber: contact.phoneNumber
    )
    
    conversationView.startOneToOneChat(conversation)
  }
  
  func invite() {
    let url = URL(string: "https://testflight.apple.com/join/gXWnCqLB")
    let av = UIActivityViewController(activityItems: [url], applicationActivities: nil)
    UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
  }
}

struct ContactsView_Previews: PreviewProvider {
  static var previews: some View {
    ContactsView()
      .environmentObject(ContactStore())
  }
}
