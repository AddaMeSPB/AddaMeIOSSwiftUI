//
//  RootView.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 06.11.2020.
//

import SwiftUI

struct RootView: View {

  @AppStorage(AppUserDefaults.Key.isUserFristNameUpdated.rawValue) var isUserFristNameUpdated: Bool = false
  
  @ViewBuilder var body: some View {
    if isUserFristNameUpdated {
      AppTabView()
    } else {
      AuthView()
    }
  }

}

struct RootView_Previews: PreviewProvider {
  static var previews: some View {
    RootView()
  }
}
