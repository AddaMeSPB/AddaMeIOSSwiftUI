//
//  AuthProfileView.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 07.12.2020.
//

import SwiftUI

struct AuthProfileView: View {
  
  let image = ImageDraw()
 
  @State var firstName: String = ""
  @State var lastName: String = ""
  @State private var inputImage: UIImage?
  @Environment(\.colorScheme) var colorScheme
  @State private var showingImagePicker = false
 
  @StateObject private var me = UserViewModel()
  
  @ViewBuilder var body: some View {
    ZStack {
      if me.uploading {
        withAnimation {
          HUDProgressView(placeHolder: "Image uploading...", show: $me.uploading)
        }
      }
      
      VStack {
        Text("Profile")
          .font(.title)
          .bold()
          .padding()
          .foregroundColor(colorScheme == .dark ? Color(#colorLiteral(red: 0.1921568662, green: 0.007843137719, blue: 0.09019608051, alpha: 1)) : Color(.black))
        
        if me.user.lastAvatarURLString() != nil {
          AsyncImage(
            urlString: me.user.lastAvatarURLString()!,
            placeholder: { Text("Loading...") },
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
              showingImagePicker = true
            }, label: {
              Image(systemName: "camera")
                .font(.system(size: 30, weight: .medium))
                .frame(width: 60, height: 60)
                .background(Color.black)
                .foregroundColor(Color.white)
                .clipShape(Circle())
                .padding(.bottom)
            })
            .sheet(isPresented: $showingImagePicker, onDismiss: uploadImage) {
              ImagePicker(image: self.$inputImage)
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
                showingImagePicker = true
              }, label: {
                Image(systemName: "camera")
                  .font(.system(size: 30, weight: .medium))
                  .frame(width: 60, height: 60)
                  .background(Color.black)
                  .foregroundColor(Color.white)
                  .clipShape(Circle())
                  .padding(.bottom)
              })
              .sheet(isPresented: $showingImagePicker, onDismiss: uploadImage) {
                ImagePicker(image: self.$inputImage)
              },
              alignment: .bottomTrailing
            )
            .padding()
        }
        
        
        
        Section {
          
          TextField("First Name", text: $firstName)
            .hideKeyboardOnTap()
            .padding()
            .lineLimit(3)
            .background(colorScheme == .dark ? Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)) : Color(.systemGray6))
            .foregroundColor(Color.blue)
            .accentColor(Color.green)
            .clipShape(Capsule())
          
          TextField("Last Name - Optional", text: $lastName)
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
    !firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
  }

  func firstAndLastName() {
    me.updateUserName(firstName, lastName)
  }
  
  private func uploadImage() {
    guard let inputImage = inputImage else { return }
    me.uploadAvatar(inputImage)
  }
  
}

struct AuthProfileView_Previews: PreviewProvider {
  static var previews: some View {
    AuthProfileView()
//      .environment(\.colorScheme, .dark)
  }
}
