//
//  RootView.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 06.11.2020.
//

import SwiftUI
import KeychainService
import UserView
import EventView

public struct RootView: View {
  
  @ObservedObject private var appvm: AppTabViewModel
  
  public init(appTabViewModel: AppTabViewModel) {
    self.appvm = appTabViewModel
  }
  
  @ViewBuilder public var body: some View {
    if appvm.uvm.isUserFristNameUpdated {
      AppTabView(appTabViewModel: appvm)
    } else {
      AuthView(authViewModel: appvm.avm, userViewModel: appvm.uvm)
    }
  }

}

struct RootView_Previews: PreviewProvider {
  
  static var avm: AuthViewModel { .init(authClient: .happyPath) }
  
  static var uvm: UserViewModel {
    .init(
      eventClient: .empty,
      userClient: .happyPath,
      attachmentClient: .happyPath
    )
  }
  
  static var evm: EventViewModel {
    .init(
      locationClient: .authorizedWhenInUse,
      pathMonitorClient: .satisfied,
      eventClient: .happyPath
    )
  }
  
  static var chatvm: ChatViewModel {
    .init(chatClient: .happyPath)
  }
  
  static var cvm: ConversationViewModel {
    .init(conversationClient: .happyPath)
  }
  
  static var wvm: WebsocketViewModel {
    .init(websocketClient: .happyPath)
  }
  
  static var ccvm: ConversationChatViewModel {
    .init(
      conversationViewModel: cvm,
      chatViewModel: chatvm,
      websocketViewModel: wvm
    )
  }
  
  static var aptvm: AppTabViewModel {
    .init(evm: evm, avm: avm, uvm: uvm, ccvm: ccvm)
  }
  
  static var previews: some View {
    RootView(appTabViewModel: aptvm)
  }
}
