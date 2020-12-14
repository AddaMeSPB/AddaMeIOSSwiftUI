//
//  SystemServices.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 05.11.2020.
//

import SwiftUI

struct SystemServices: ViewModifier {
  static var appState: AppState = AppState()
  static var authViewModel: AuthViewModel = AuthViewModel()
  static var eventViewModel: EventViewModel = EventViewModel()
  static var deviceViewModel: DeviceViewModel = DeviceViewModel()
  let persistenceController = PersistenceController.shared

  func body(content: Content) -> some View {
    content
      // services
      .environmentObject(Self.appState)
      .environmentObject(Self.authViewModel)
      .environmentObject(Self.eventViewModel)
      .environmentObject(Self.deviceViewModel)
      .environment(\.managedObjectContext, persistenceController.container.viewContext)
  }
}

//struct SystemServices: ViewModifier {
//
//
//  let persistenceController: PersistenceController
//  @StateObject var contactStorage: ContactStore
//
//  init() {
//    let persistenceManager = PersistenceController()
//    self.persistenceController = persistenceManager
//    let managedObjectContext = persistenceManager.container.viewContext
//    let storage = ContactStore(managedObjectContext: managedObjectContext)
//    self._contactStorage = StateObject(wrappedValue: storage)
//  }
//
//  static var appState: AppState = AppState()
//  static var authViewModel: AuthViewModel = AuthViewModel()
//  static var eventViewModel: EventViewModel = EventViewModel()
//  static var deviceViewModel: DeviceViewModel = DeviceViewModel()
////  let persistenceController = PersistenceController.shared
//
//  func body(content: Content) -> some View {
//    content
//      // services
//      .environmentObject(Self.appState)
//      .environmentObject(Self.authViewModel)
//      .environmentObject(Self.eventViewModel)
//      .environmentObject(Self.deviceViewModel)
////      .environment(\.managedObjectContext, persistenceController.container.viewContext)
//  }
//}
