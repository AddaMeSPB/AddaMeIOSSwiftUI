//
//  AppState.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 06.11.2020.
//

import Combine

class AppState: ObservableObject {
  @Published var currentTab = AppTabs.event
  @Published var tabBarIsHidden: Bool = false
}

enum AppTabs: Int {
  case event, chat, profile
}
