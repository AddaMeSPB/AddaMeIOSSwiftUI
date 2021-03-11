//
//  ChatRow.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 28.09.2020.
//

import SwiftUI
import AddaMeModels
import KeychainService
import AsyncImageLoder
import SwiftUIExtension

public struct ChatRow : View {

  var chatMessageResponse: ChatMessageResponse.Item
  
  @Environment(\.colorScheme) var colorScheme
  
  @ViewBuilder public func systemImage() -> some View {
    Image(systemName: "person.fill")
      .aspectRatio(contentMode: .fit)
      .frame(width: 40, height: 40)
      .foregroundColor(Color.backgroundColor(for: self.colorScheme))
      .clipShape(Circle())
      .overlay(Circle().stroke(Color.blue, lineWidth: 1))
      .padding(.trailing, 5)
  }
  
  @ViewBuilder
  public var body: some View {
    Group {
      
      if !currenuser(chatMessageResponse.sender.id)  {
        HStack {
          Group {
            
            if chatMessageResponse.sender.lastAvatarURLString != nil {
              AsyncImage(
                urlString: chatMessageResponse.sender.lastAvatarURLString,
                placeholder: {
                  HUDProgressView(placeHolder: "Image uploading...", show: Binding.constant(true) )
                    .frame(width: 40, height: 40)
                },
                image: {
                  Image(uiImage: $0).resizable()
                }
              )
              .aspectRatio(contentMode: .fit)
              .frame(width: 40, height: 40)
              .clipShape(Circle())
            } else {
              systemImage()
            }
            
            Text(chatMessageResponse.messageBody)
              .bold()
              .padding(10)
              .foregroundColor(Color.white)
              .background(Color.blue)
              .cornerRadius(10)
          }
          .background(Color(.systemBackground))
          Spacer()
        }
        .background(Color(.systemBackground))
      } else { 
        HStack {
          Group {
            Spacer()
            Text(chatMessageResponse.messageBody)
              .bold()
              .foregroundColor(Color.white)
              .padding(10)
              .background(Color.red)
              .cornerRadius(10)
            
            if chatMessageResponse.sender.lastAvatarURLString != nil {
              AsyncImage(
                urlString: chatMessageResponse.sender.lastAvatarURLString,
                placeholder: {
                  HUDProgressView(placeHolder: "Image uploading...", show: Binding.constant(true))
                    .frame(width: 40, height: 40)
                },
                image: {
                  Image(uiImage: $0).resizable()
                }
              )
              .aspectRatio(contentMode: .fit)
              .frame(width: 40, height: 40)
              .clipShape(Circle())
            } else {
              systemImage()
            }
            
          }
          
        }
        .background(Color(.systemBackground))
      }
    }
//    .background(Color(.systemBackground))
  }
  
  func currenuser(_ userId: String) -> Bool {
    guard let currentUSER: User = KeychainService.loadCodable(for: .user) else {
      return false
    }
    
    return currentUSER.id == userId ? true : false
    
  }
}


//struct ChatRow_Previews: PreviewProvider {
//  static var previews: some View {
//    ChatRow(chatMessageResponse: chatDemoData[1])
//      .environmentObject(ChatViewModel())
//      .environment(\.colorScheme, .dark)
//  }
//}

// fixed this image issue i mean night mode issue
//#imageLiteral(resourceName: "IMG_9505 3.PNG")

public struct IfLet<T, Out: View>: View {
  let value: T?
  let produce: (T) -> Out

  public init(_ value: T?, produce: @escaping (T) -> Out) {
    self.value = value
    self.produce = produce
  }

  public var body: some View {
    Group {
      if value != nil {
        produce(value!)
      }
    }
  }
}
