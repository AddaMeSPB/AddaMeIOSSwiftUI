//
//  AppDelegate.swift
//  AddaMeIOS
//
//  Created by Alif on 11/7/20.
//

import UIKit
import UserNotifications
import PushKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  let voipRegistry = PKPushRegistry(queue: DispatchQueue.main)
  
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
      
      registerForPushNotifications()

      return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
  
  func application(
    _ application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
  ) {
    let token = deviceToken.toHexString()
    KeychainService.save(string: token, for: .deviceToken)
    print("Device Token: \(token)")
  }
  
  func application(
    _ application: UIApplication,
    didFailToRegisterForRemoteNotificationsWithError error: Error
  ) {
    print("Failed to register: \(error)")
  }

  func registerForPushNotifications() {

    UNUserNotificationCenter.current()
      .requestAuthorization(
        options: [.alert, .sound, .badge]) { [weak self] granted, _ in
        print(#line, "Permission granted: \(granted)")
        guard granted else { return }
        self?.getNotificationSettings()
      }
    
    registerForPushNVoip()
  }

  func getNotificationSettings() {
    UNUserNotificationCenter.current().getNotificationSettings { settings in
      print(#line, "Notification settings: \(settings)")
      guard settings.authorizationStatus == .authorized else { return }
      DispatchQueue.main.async {
        UIApplication.shared.registerForRemoteNotifications()
      }
    }
  }

  private func registerForPushNVoip() {
      //register for voip notifications
      voipRegistry.delegate = self
      voipRegistry.desiredPushTypes = [.voIP]
      UIApplication.shared.registerForRemoteNotifications()
  }
  
}

