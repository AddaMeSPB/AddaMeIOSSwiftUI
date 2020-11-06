//
//  RootView.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 06.11.2020.
//

import SwiftUI

struct RootView: View {
  @EnvironmentObject var viewModel: AuthViewModel
  @ObservedObject var authenticator = Authenticator.shared
  
  var body: some View {
    if isLoggedInOrcurrentTokenIsNotNil {
      AppTabView()
    } else {
      AuthView()
    }
  }
  
  var isLoggedInOrcurrentTokenIsNotNil: Bool {    
    return viewModel.lAndVRes.isLoggedIn == true || authenticator.currentToken != nil
  }
  
}

struct RootView_Previews: PreviewProvider {
  static var previews: some View {
    RootView()
  }
}
