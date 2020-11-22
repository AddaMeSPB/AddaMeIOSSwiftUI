//
//  ProfileView.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 04.09.2020.
//

import SwiftUI
import URLImage

struct ProfileView: View {
  
  let image = ImageDraw()
  @State var moveToAuth: Bool = false
  
  @StateObject private var eventViewModel = EventViewModel()
  @StateObject private var me = UserViewModel()
  @ObservedObject var viewModel = AuthViewModel()
  @EnvironmentObject var appState: AppState
  @State private var showingImagePicker = false
  @State private var inputImage: UIImage?
  
  var body: some View {
    
    NavigationView {
      ScrollView {
        if me.user.imageURL != nil {
        URLImage(url: me.user.imageURL!) { image in
            image
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
        .overlay(
          ProfileImageOverlay(
            showingImagePicker: self.$showingImagePicker,
            inputImage: self.$inputImage
          ).environmentObject(me) ,
          alignment: .bottomTrailing
        )
        } else {
          Image(uiImage: image.random())
            .renderingMode(.original)
            .resizable()
            .aspectRatio(contentMode: .fit)
        }
        
        VStack(alignment: .leading) {
          Text("My Events:")
            .font(.system(size: 23, weight: .bold, design: .rounded))
            .padding(.top, 10)
            .padding()
        }
        
        Divider()
        
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
      .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
        ImagePicker(image: self.$inputImage)
      }
    }
    .navigationViewStyle(StackNavigationViewStyle())
  }
  
  func loadImage() {
    guard let inputImage = inputImage else { return }
    //image = Image(uiImage: inputImage)
    me.uploadAvatar(inputImage)
    
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
  @EnvironmentObject var me: UserViewModel
  @Environment(\.colorScheme) var colorScheme
  @Binding var showingImagePicker: Bool
  @Binding var inputImage: UIImage?
  
  var body: some View {
    ZStack {
      if me.uploading {
        withAnimation {
          HUDProgressView(placeHolder: "Image uploading...", show: $me.uploading)
        }
      }
      
      VStack {
        HStack {
          Spacer()
          Button(action: {
            showingImagePicker = true
          }, label: {
            Image(systemName: "photo")
          })
          .imageScale(.large)
          .frame(width: 40, height: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
          .padding()
        }
        Spacer()
        Text(me.user.fullName)
          .font(.title).bold()
          .foregroundColor(.white)
          .padding()
      }
      .padding(6)
    }
  }
}
