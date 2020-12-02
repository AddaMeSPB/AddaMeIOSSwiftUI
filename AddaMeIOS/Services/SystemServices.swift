//
//  SystemServices.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 05.11.2020.
//

import SwiftUI

struct SystemServices: ViewModifier {
  static var appState: AppState = AppState()
  static var contactStore: ContactStore = ContactStore()
  static var authViewModel: AuthViewModel = AuthViewModel()
  static var eventViewModel: EventViewModel = EventViewModel()
  static var deviceViewModel: DeviceViewModel = DeviceViewModel()
  let persistenceController = PersistenceController.shared

  func body(content: Content) -> some View {
    content
      // services
      .environmentObject(Self.appState)
      .environmentObject(Self.contactStore)
      .environmentObject(Self.authViewModel)
      .environmentObject(Self.eventViewModel)
      .environmentObject(Self.deviceViewModel)
      .environment(\.managedObjectContext, persistenceController.container.viewContext)
  }
}
