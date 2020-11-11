//
//  ProfileView.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 04.09.2020.
//

import SwiftUI

struct ProfileView: View {
  //@ObservedObject var settingMenu = SettingsMenuView()
  @ObservedObject private var me = UserViewModel()
  @StateObject private var eventViewModel = EventViewModel()
  @ObservedObject var viewModel = AuthViewModel()
  
  @Environment(\.imageCache) var cache: ImageCache
  @EnvironmentObject var appState: AppState
  
  @State var moveToAuth: Bool = false
  
  var body: some View {
    
    NavigationView {
      ScrollView {
        AsyncImage(
          urlString: me.user.avatarUrl,
          placeholder: { Text("Loading...").frame(width: 100, height: 100, alignment: .center) },
          image: {
            Image(uiImage: $0).resizable()
          }
        )
//        .frame(idealHeight: UIScreen.main.bounds.width / 2 * 3)
        .aspectRatio(contentMode: .fit)
        .overlay(ProfileImageOverlay(me: me), alignment: .bottomTrailing)
        
        Divider()
        
        VStack(alignment: .leading) {
          Text("My Events:")
            .font(.system(size: 23, weight: .light, design: .serif))
            .padding(.top, 10)
            .padding()
        }
        
        
        LazyVStack {
          ForEach(eventViewModel.myEvents) { event in // eventViewModel.myEvents
            EventRow(event: event)
              .hideRowSeparator()
              .onAppear {
                eventViewModel.fetchMoreMyEventIfNeeded(currentItem: event)
              }
          }
          
          if eventViewModel.isLoadingPage {
            ProgressView()
          }
        }
        
        HStack {
          Button(action: {
            AppUserDefaults.resetAuthData()
            self.viewModel.isAuthorized = false
            self.moveToAuth.toggle()
          }) {
            Text("Logout")
              .font(.title)
              .bold()
          }.background(
            NavigationLink.init(
              destination: AuthView()
                .onAppear(perform: {
                  appState.tabBarIsHidden = true
                })
                .navigationBarTitle("")
                .navigationBarHidden(true),
              isActive: $moveToAuth,
              label: {}
            )
            
          )
        }
      }
      .navigationBarTitle("Profile", displayMode: .inline)
      .onAppear {
        self.eventViewModel.fetchMoreMyEvents()
      }
    }
    .navigationViewStyle(StackNavigationViewStyle())
  }
}

struct ProfileView_Previews: PreviewProvider {
  static var previews: some View {
    ProfileView()
      //          .environment(\.colorScheme, .dark)
      .environmentObject(UserViewModel())
  }
}

struct ProfileImageOverlay: View {
  let me: UserViewModel
  var body: some View {
    ZStack {
      Text(me.user.fullName)
        .font(.title).bold()
        .foregroundColor(.black)
        .opacity(1)
        .padding()
    }
    .padding(6)
  }
}
