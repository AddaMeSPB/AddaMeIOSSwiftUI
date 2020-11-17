//
//  TabView.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 26.08.2020.
//

import SwiftUI
import Combine

struct AppTabView: View {
    @State var index = 0
    @State var expand = true
    @State var searchExpand = true

    @EnvironmentObject var appState: AppState
//    @EnvironmentObject var conversationView: ConversationViewModel
    @Environment(\.colorScheme) var colorScheme
  
//    var newConversationCountText: String {
//        if conversationView.conversations.isEmpty {
//            return "Chat"
//        } else {
//            return "Chat - \(conversationView.conversations.count)"
//        }
//    }

    var body: some View {

        VStack(alignment: .center) {
            ZStack {
                if index == 0 {
                    EventList()
                      .environmentObject(appState)
                } else if index == 1 {
                    ConversationList()
                      .environmentObject(appState)
                } else if index == 2 {
                    ProfileView()
                      .environmentObject(appState)
                }
            }

            Spacer()
            if appState.tabBarIsHidden == false {
              CustomTabs(index: self.$index, expand: self.$expand)
            }
        }
        .background(Color(.systemBackground))
        .edgesIgnoringSafeArea(.all)
    }
}

struct AppTabView_Previews: PreviewProvider {
    static var previews: some View {
      AppTabView()
        .environmentObject(ConversationViewModel())
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
        .padding(30)
        .padding(.bottom, -10)
        .background(Color(.systemBackground))
    }
}

struct SettingsView: View {
//    @State var expand = false
//    @State var searchExpand = false
    var body: some View {
        Text("Welcome Settings Page")
    }
}

