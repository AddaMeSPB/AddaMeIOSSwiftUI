//
//  ProfileView.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 04.09.2020.
//

import SwiftUI

struct ProfileView: View {

  @State var moveToAuth: Bool = false
  
  @StateObject private var eventViewModel = EventViewModel()
  @ObservedObject private var me = UserViewModel()
  @ObservedObject var viewModel = AuthViewModel()
  @EnvironmentObject var appState: AppState
  
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
        .aspectRatio(contentMode: .fit)
        .overlay(ProfileImageOverlay(me: me), alignment: .bottomTrailing)
        
        Divider()
        
        VStack(alignment: .leading) {
          Text("My Events:")
            .font(.system(size: 23, weight: .light, design: .rounded))
            .padding(.top, 10)
            .padding()
        }
        
        
        LazyVStack {
          ForEach(eventViewModel.myEvents) { event in
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
                .navigationBarTitle(String.empty)
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
      //.environment(\.colorScheme, .dark)
      .environmentObject(UserViewModel())
  }
}

struct ProfileImageOverlay: View {
  let me: UserViewModel
  @Environment(\.colorScheme) var colorScheme
  
  var body: some View {
    ZStack {
      Text(me.user.fullName)
        .font(.title).bold()
        .padding()
    }
    .padding(6)
  }
}
