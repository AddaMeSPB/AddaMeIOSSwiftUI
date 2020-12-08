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

  @State private var refreshing = false
  private var didSave =  NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave)
  
  @EnvironmentObject var store: ContactStore
  @Environment(\.colorScheme) var colorScheme
  @State var startChat = false
  @State var conversation: ConversationResponse.Item?
  
  @FetchRequest(entity: ContactEntity.entity(),
    sortDescriptors: [ NSSortDescriptor(key: "fullName", ascending: true)],
    predicate: NSPredicate(format: "isRegister == true")
  ) private var contacts: FetchedResults<ContactEntity>
  
  var body: some View {
    List {
      ForEach(contacts, id: \.identifier) { contact in
        ContactRow(contact: contact)
      }
    }
    .navigationBarTitle("Contacts", displayMode: .automatic)
  }
  
}

struct ContactsView_Previews: PreviewProvider {
  static var previews: some View {
    ContactsView()
  }
}
