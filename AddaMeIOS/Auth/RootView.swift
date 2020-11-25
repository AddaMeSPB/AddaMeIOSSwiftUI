//
//  RootView.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 06.11.2020.
//

import SwiftUI

struct RootView: View {
  @EnvironmentObject var authModel: AuthViewModel
  @ObservedObject var authenticator = Authenticator.shared
  
  @ViewBuilder var body: some View {
    if authModel.isAuthorized {
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
