//
//  AuthProfileView.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 07.12.2020.
//

import SwiftUI
import AsyncImageLoder
import SwiftUIExtension

public struct EditProfileView: View {
 
  @Environment(\.colorScheme) var colorScheme
  @ObservedObject public var uvm: UserViewModel
  
  public init(uvm: UserViewModel) {
    self.uvm = uvm
  }
  
  @ViewBuilder public var body: some View {
    ZStack {
      if uvm.uploading {
        withAnimation {
          HUDProgressView(placeHolder: "Image uploading...", show: $uvm.uploading)
        }
      }
      
      VStack {
        Text("Profile")
          .font(.title)
          .bold()
          .padding()
          .foregroundColor(colorScheme == .dark ? Color(#colorLiteral(red: 0.1921568662, green: 0.007843137719, blue: 0.09019608051, alpha: 1)) : Color(.black))
        
        if uvm.isUserHaveAvatarLink {
          AsyncImage(
            urlString: uvm.user.lastAvatarURLString!,
            placeholder: {
              HUDProgressView(placeHolder: "Image uploading...", show: $uvm.uploading)
                .frame(width: 220, height: 220)
            },
            image: {
              Image(uiImage: $0)
                .renderingMode(.original)
                .resizable()
            }
          )
          .clipShape(Circle())
          .aspectRatio(contentMode: .fit)
          .overlay(
            Button(action: {
              self.uvm.showingImagePicker = true
            }, label: {
              Image(systemName: "camera")
                .font(.system(size: 30, weight: .medium))
                .frame(width: 60, height: 60)
                .background(Color.black)
                .foregroundColor(Color.white)
                .clipShape(Circle())
                .padding(.bottom)
            })
            .sheet(isPresented: self.$uvm.showingImagePicker, onDismiss: uploadImage) {
              ImagePicker(image: self.$uvm.inputImage)
            },
            alignment: .bottomTrailing
          )
        } else {
          Image(systemName: "person.fill")
            .font(.system(size: 100, weight: .medium))
            .frame(width: 250, height: 250)
            .background(Color(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)))
            .clipShape(Circle())
            .overlay(
              Button(action: {
                self.uvm.showingImagePicker = true
              }, label: {
                Image(systemName: "camera")
                  .font(.system(size: 30, weight: .medium))
                  .frame(width: 60, height: 60)
                  .background(Color.black)
                  .foregroundColor(Color.white)
                  .clipShape(Circle())
                  .padding(.bottom)
              })
              .sheet(isPresented: self.$uvm.showingImagePicker, onDismiss: uploadImage) {
                ImagePicker(image: self.$uvm.inputImage)
              },
              alignment: .bottomTrailing
            )
            .padding()
        }
        
        Section {
          
          TextField("First Name", text: self.$uvm.firstName)
            .hideKeyboardOnTap()
            .padding()
            .lineLimit(3)
            .background(colorScheme == .dark ? Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)) : Color(.systemGray6))
            .foregroundColor(Color.blue)
            .accentColor(Color.green)
            .clipShape(Capsule())
          
          TextField("Last Name - Optional", text: self.$uvm.lastName)
            .hideKeyboardOnTap()
            .padding()
            .lineLimit(3)
            .background(colorScheme == .dark ? Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)) : Color(.systemGray6))
            .foregroundColor(Color.blue)
            .accentColor(Color.green)
            .clipShape(Capsule())
          
        }
        .padding()
        
        
        Button(action: firstAndLastName, label: {
          Text("Save")
            .font(.largeTitle)
            .bold()
        })
        .frame(maxWidth: .infinity, maxHeight: 60)
        .background(isValid ? Color.yellow : Color.gray)
        .foregroundColor(.blue)
        .clipShape(Capsule())
        .disabled(!isValid)
        .padding()
        
        Spacer()
      }
    }
  }
  
  var isValid: Bool {
    !self.uvm.firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
  }

  func firstAndLastName() {
    uvm.updateUserName()
  }
  
  private func uploadImage() {
    guard let inputImage = self.uvm.inputImage else { return }
    uvm.uploadAvatar(inputImage)
  }
  
}

struct EditProfileView_Previews: PreviewProvider {
  static var uvm: UserViewModel {
    .init(
      eventClient: .happyPath,
      userClient: .happyPath,
      attachmentClient: .happyPath
    )
  }
  static var previews: some View {
    EditProfileView(uvm: uvm)
//      .environment(\.colorScheme, .dark)
  }
}
