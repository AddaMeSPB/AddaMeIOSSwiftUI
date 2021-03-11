//
//  ProfileView.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 04.09.2020.
//

import SwiftUI
import AsyncImageLoder
import UserClient
import KeychainService
import SwiftUIExtension
import AddaMeModels

public struct ProfileView: View {

  let image = ImageDraw()

  @Environment(\.colorScheme) var colorScheme

  @ObservedObject private var avm: AuthViewModel
  @ObservedObject private var uvm: UserViewModel

  public init(userViewModel: UserViewModel, authViewModel: AuthViewModel) {
    self.uvm = userViewModel
    self.avm = authViewModel
  }

  @ViewBuilder public var body: some View {

    NavigationView {
      ScrollView {
        if self.uvm.user.attachments != nil {
          AsyncImage(
            urlString: self.uvm.user.lastAvatarURLString!,
            placeholder: {
              HUDProgressView(placeHolder: "Image uploading...", show: $uvm.uploading)
                .frame(width: 60, height: 60)
                .padding(.top, 100)
                .padding(.bottom, 100)
            },
            image: {
              Image(uiImage: $0)
                .renderingMode(.original)
                .resizable()
            }
          )
          .aspectRatio(contentMode: .fit)
          .overlay(
            ProfileImageOverlay(
              showingImagePicker: self.$uvm.showingImagePicker,
              inputImage: self.$uvm.inputImage
            )
            .environmentObject(self.uvm),
            alignment: .bottomTrailing
          )
        } else {
          Image(systemName: "person.fill")
            .font(.system(size: 200, weight: .medium))
            .frame(width: 450, height: 350)
            .foregroundColor(Color.backgroundColor(for: self.colorScheme))
            .overlay(
              ProfileImageOverlay(
                showingImagePicker: self.$uvm.showingImagePicker,
                inputImage: self.$uvm.inputImage
              )
              .padding(.top, 40)
              .environmentObject(self.uvm),
              alignment: .bottomTrailing
            )
        }

        VStack(alignment: .leading) {
          Text("My Events:")
            .font(.system(size: 23, weight: .bold, design: .rounded))
            .padding(.top, 10)
            .padding()
        }

        Divider()

        //        LazyVStack {
        //          ForEach(eventViewModel.myEvents) { event in
        //            EventRow(event: event)
        //              .hideRowSeparator()
        //              .onAppear {
        //                eventViewModel.fetchMoreMyEventIfNeeded(currentItem: event)
        //              }
        //          }
        //
        //          if eventViewModel.isLoadingPage {
        //            ProgressView()
        //          }
        //        }

        HStack {
          Button(action: {
            self.uvm.resetAuthData()
            self.uvm.moveToAuthView = true
          }) {
            Text("Logout")
              .font(.title)
              .bold()
          }
          .background(
            NavigationLink.init(
              destination: AuthView(authViewModel: self.avm, userViewModel: self.uvm)
                .onAppear(perform: {
                  //appState.tabBarIsHidden = true
                })
                .navigationBarTitle(String.empty)
                .navigationBarHidden(true),
              isActive: self.$uvm.moveToAuthView,
              label: {}
            )
          )
        }
      }
      .navigationBarTitle("Profile", displayMode: .inline)
      .sheet(isPresented: self.$uvm.showingImagePicker, onDismiss: self.uvm.loadImage) {
        ImagePicker(image: self.$uvm.inputImage)
      }
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing ) { settings }
      }
    }
    .navigationViewStyle(StackNavigationViewStyle())
  }

  private var settings: some View {
    Button(action: {
      self.uvm.moveToSettingsView = true
    }) {
      Image(systemName: "gear")
        .font(.title)
//        .foregroundColor(Color("bg"))
    }.background(
      NavigationLink(
        destination: SettingsView()
          .edgesIgnoringSafeArea(.bottom)
          .onAppear(perform: {
            self.uvm.tabBarHideAction(true)
            self.uvm.moveToSettingsView = false
          })
          .onDisappear(perform: {
            self.uvm.tabBarHideAction(false)
          }),
        isActive: self.$uvm.moveToSettingsView
      ) {
        EmptyView()
      }
    )
  }

}

struct ProfileView_Previews: PreviewProvider {

  static var avm: AuthViewModel { .init(authClient: .happyPath) }

  static var uvm: UserViewModel {
    .init(
      eventClient: .happyPath,
      userClient: .happyPath,
      attachmentClient: .happyPath
    )
  }

  static var previews: some View {
    avm.isAuthorized = true
//    KeychainService.save(codable: uvm.user, for: .user)
    KeychainService.save(codable: User?.none, for: .user)
    return ProfileView(
      userViewModel: uvm,
      authViewModel: avm
    )
//    .environmentObject(uvm)
//      .environment(\.colorScheme, .dark)
  }
}

public struct ProfileImageOverlay: View {
  @EnvironmentObject var me: UserViewModel
  @Environment(\.colorScheme) var colorScheme
  @Binding var showingImagePicker: Bool
  @Binding var inputImage: UIImage?
  
  public var body: some View {
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
            Image(systemName: "camera")
              .font(.system(size: 15, weight: .medium))
              .frame(width: 40, height: 40)
              .background(Color.black)
              .foregroundColor(Color.white)
              .clipShape(Circle())
              .padding(.trailing, 30)
            
          })
          .imageScale(.large)
          .frame(width: 40, height: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
          .padding()
        }
        
        Spacer()
        
        Text(me.user.fullName)
          .font(.title).bold()
          .foregroundColor(Color.backgroundColor(for: self.colorScheme))
        
      }
      .padding(6)
    }
  }
}

//struct ProfileImageOverlay_Previews: PreviewProvider {
//  static var uvm: UserViewModel {
//    .init(
//      eventClient: .happyPath,
//      userClient: .happyPath,
//      attachmentClient: .happyPath
//    )
//  }
//
//  static var previews: some View {
//    return ProfileImageOverlay(
//      showingImagePicker: Binding.constant(false),
//      inputImage: Binding.constant(nil)
//    )
//    .environmentObject(uvm)
//    .environment(\.colorScheme, .dark)
//  }
//}
