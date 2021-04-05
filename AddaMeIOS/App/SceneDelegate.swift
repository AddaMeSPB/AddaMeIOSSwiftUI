//
//  SceneDelegate.swift
//  AddaMeIOS
//
//  Created by Alif on 11/7/20.
//

import UIKit
import SwiftUI
import Combine
import AddaMeModels
import KeychainService
import UserView
import EventView
import UserClientLive
import AuthClientLive
import EventClientLive
import ConversationClientLive
import AttachmentClientLive
import WebsocketClientLive
import ChatClientLive
import ChatView

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  var window: UIWindow?
  var baseURL: URL { EnvironmentKeys.rootURL }
  
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

    let avm = AuthViewModel(authClient: .live(api: .build ) )
    
    let uvm = UserViewModel(
      eventClient: .live(api: .build),
      userClient: .live(api: .build),
      attachmentClient: .live(api: .build)
    )
    
    let evm = EventViewModel(
      locationClient: .live,
      pathMonitorClient: .live(queue: .main),
      eventClient: .live(api: .build)
    )
    
    let cvm = ConversationViewModel(conversationClient: .live(api: .build))
    let chatvm = ChatViewModel(chatClient: .live(api: .build) )
    let wvm = WebsocketViewModel(websocketClient: .live(api: .build))
    let ccvm = ConversationChatViewModel(
      conversationViewModel: cvm,
      chatViewModel: chatvm,
      websocketViewModel: wvm
    )
    
    let aptvm = AppTabViewModel(evm: evm, avm: avm, uvm: uvm, ccvm: ccvm)

    let conentView = RootView(appTabViewModel: aptvm)
      .modifier(SystemServices())
    
    if let windowScene = scene as? UIWindowScene {
      let window = UIWindow(windowScene: windowScene)
      
      window.rootViewController = UIHostingController(rootView: conentView)
      self.window = window
      window.makeKeyAndVisible()
    }
  }
  
  func sceneDidDisconnect(_ scene: UIScene) {}
  
  func sceneDidBecomeActive(_ scene: UIScene) {
    guard let _ : User = KeychainService.loadCodable(for: .user) else {
      print(#line, "Missing current user from KeychainService")
      return
    }
    
    guard UserDefaults.standard.bool(forKey: "isAuthorized") == true else { return }
    
//    _ = SocketViewModel.shared
  }
  
  func sceneWillResignActive(_ scene: UIScene) {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
  }
  
  func sceneWillEnterForeground(_ scene: UIScene) {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
  }
  
  func sceneDidEnterBackground(_ scene: UIScene) {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
  }
  
  
}

extension SceneDelegate: UIGestureRecognizerDelegate {
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return true
  }
}

//class AnyGestureRecognizer: UIGestureRecognizer {
//  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
//    if let touchedView = touches.first?.view, touchedView is UIControl {
//      state = .cancelled
//      
//    } else if let touchedView = touches.first?.view as? UITextView, touchedView.isEditable {
//      state = .cancelled
//      
//    } else {
//      state = .began
//    }
//  }
//  
//  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//    state = .ended
//  }
//  
//  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
//    state = .cancelled
//  }
//}
