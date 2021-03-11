//
//  AppState.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 06.11.2020.
//

import Combine

public class AppState: ObservableObject {
  @Published var currentTab = AppTabs.event
  @Published var tabBarIsHidden: Bool = false
}

public enum AppTabs: Int {
  case event, chat, profile
}
