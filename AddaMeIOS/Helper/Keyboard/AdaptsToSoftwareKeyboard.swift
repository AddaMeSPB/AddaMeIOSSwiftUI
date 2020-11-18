//
//  AdaptsToSoftwareKeyboard.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 18.11.2020.
//

import SwiftUI
import Combine

struct AdaptsToSoftwareKeyboard: ViewModifier {
  @State var currentHeight: CGFloat = 0
  
  func body(content: Content) -> some View {
    content
      .padding(.bottom, currentHeight)
      .animation(.default)
      .edgesIgnoringSafeArea(currentHeight == 0 ? [] : .bottom)
      .onAppear(perform: subscribeToKeyboardEvents)
  }
  
  private func subscribeToKeyboardEvents() {
    NotificationCenter.Publisher(
      center: NotificationCenter.default,
      name: UIResponder.keyboardWillShowNotification
    ).compactMap { notification in
      notification.userInfo?["UIKeyboardFrameEndUserInfoKey"] as? CGRect
    }.map { rect in
      rect.height
    }.subscribe(Subscribers.Assign(object: self, keyPath: \.currentHeight))
    
    NotificationCenter.Publisher(
      center: NotificationCenter.default,
      name: UIResponder.keyboardWillHideNotification
    ).compactMap { notification in
      CGFloat.zero
    }.subscribe(Subscribers.Assign(object: self, keyPath: \.currentHeight))
  }
}

