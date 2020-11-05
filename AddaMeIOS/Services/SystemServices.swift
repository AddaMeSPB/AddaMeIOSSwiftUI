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
  static var locationSearchService: LocationSearchService = LocationSearchService()

  func body(content: Content) -> some View {
    content
      // services
      .environmentObject(Self.appState)
      .environmentObject(Self.contactStore)
      .environmentObject(Self.locationSearchService)
  }
}
