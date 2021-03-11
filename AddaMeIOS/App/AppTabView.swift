//
//  TabView.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 26.08.2020.
//

import SwiftUI
import Combine
import UserView
import EventView

public class AppTabViewModel: ObservableObject {
  var evm: EventViewModel
  var avm: AuthViewModel
  var uvm: UserViewModel
  var ccvm: ConversationChatViewModel
  
  var cancellationToken: AnyCancellable?
  @Published var hideTabBar: Bool = false
  
  public init(
    evm: EventViewModel,
    avm: AuthViewModel,
    uvm: UserViewModel,
    ccvm: ConversationChatViewModel
  ) {
    self.evm = evm
    self.avm = avm
    self.uvm = uvm
    self.ccvm = ccvm
    
    cancellationToken = uvm.tabBarHidePS.sink { [weak self] boolValue in
      self?.hideTabBar = boolValue
    }
  }
  
}

struct AppTabView: View {
  @State var index = 0
  @State var expand = true
  @State var searchExpand = true
  
  @EnvironmentObject var appState: AppState
  //    @EnvironmentObject var conversationView: ConversationViewModel
  @Environment(\.colorScheme) var colorScheme
  
  // var newConversationCountText: String {
  //        if conversationView.conversations.isEmpty {
  //            return "Chat"
  //        } else {
  //            return "Chat - \(conversationView.conversations.count)"
  //        }
  //    }

  @ObservedObject private var aptvm: AppTabViewModel
    
  public init(
    appTabViewModel: AppTabViewModel
  ) {
    self.aptvm = appTabViewModel
  }
  
  @ViewBuilder var body: some View {
    
    VStack(alignment: .center) {
      ZStack {
        if index == 0 {
          EventList(eventViewModel: aptvm.evm)
            .environmentObject(appState)
        } else if index == 1 {
          ConversationList(conversationChatViewModel: aptvm.ccvm) //(conversationViewModel: aptvm.cvm, websocketViewModel: aptvm.wvm )
//            .environmentObject(appState)
        } else if index == 2 {
          ProfileView(userViewModel: aptvm.uvm, authViewModel: aptvm.avm)
        }
      }
      
      Spacer()
      
      if aptvm.hideTabBar == false {
        CustomTabs(index: self.$index, expand: self.$expand)
      }
    }
    .background(Color(.systemBackground))
    .edgesIgnoringSafeArea(.all)
  }
}

struct AppTabView_Previews: PreviewProvider {
  
  static var avm: AuthViewModel { .init(authClient: .happyPath) }

  static var uvm: UserViewModel {
    .init(
      eventClient: .happyPath,
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
    .init(conversationViewModel: cvm, chatViewModel: chatvm, websocketViewModel: wvm)
  }
  
  static var aptvm: AppTabViewModel { .init(evm: evm, avm: avm, uvm: uvm, ccvm: ccvm) }

  static var previews: some View {
    AppTabView(appTabViewModel: aptvm)
    //        .environmentObject(ConversationViewModel())
  }
}

struct CustomTabs: View {
  @Binding var index: Int
  @Binding var expand: Bool
  
  @Environment(\.colorScheme) var colorScheme
  
  var body: some View {
    HStack {
      
      Button(action: {
        self.index = 0
        self.expand = true
      }) {
        VStack {
          Image(systemName: "captions.bubble")
          Text("Events")
        }
      }
      .foregroundColor(Color("bg").opacity(self.index == 0 ? 1 : 0.6))
      Spacer()
      
      Button(action: {
        self.expand = false
        self.index = 1
      }) {
        VStack {
          Image(systemName: "bubble.left.and.bubble.right.fill")
          Text("Chat")
        }
      }
      .foregroundColor(Color("bg").opacity(self.index == 1 ? 1 : 0.6))
      
      Spacer()
      
      Button(action: {
        self.expand = false
        self.index = 2
      }) {
        VStack {
          Image(systemName: "person.fill")
          Text("Profile")
        }
      }
      .foregroundColor(Color("bg").opacity(self.index == 2 ? 1 : 0.6))
      
    }
    .padding([.bottom, .trailing, .leading], 40)
    .background(Color(.systemBackground))
  }
}

struct CustomTabs_Previews: PreviewProvider {
  static var previews: some View {
    CustomTabs(index: .constant(1), expand: .constant(true))
    //        .environmentObject(ConversationViewModel())
  }
}

