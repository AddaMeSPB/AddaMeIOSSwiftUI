//
//  SystemServices.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 05.11.2020.
//

import SwiftUI
import LocationClientLive
import PathMonitorClientLive
import AuthClientLive
import UserView
import CoreDataStore

struct SystemServices: ViewModifier {
  static var appState: AppState = AppState()
//  static var authViewModel:  AuthViewModel = AuthViewModel(authClient: .live(api: .build) )
//  static var deviceViewModel: DeviceViewModel = DeviceViewModel()
  let persistenceController = CoreDataStore.shared

  func body(content: Content) -> some View {
    content
      // services
      .environmentObject(Self.appState)
//      .environmentObject(Self.authViewModel)
//      .environmentObject(Self.deviceViewModel)
      .environment(\.managedObjectContext, persistenceController!.container.viewContext)
  }
}
