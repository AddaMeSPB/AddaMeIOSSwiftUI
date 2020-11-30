//
//  AppDelegate+PKPushRegistryDelegate.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 29.11.2020.
//

import PushKit
import UIKit
import CallKit

// MARK: PKPushRegistryDelegate
extension AppDelegate: PKPushRegistryDelegate {

    func pushRegistry(_ registry: PKPushRegistry, didUpdate credentials: PKPushCredentials, for type: PKPushType) {
        
        print(#line, "voip token saved")
        let voipToken = credentials.token.toHexString()
        KeychainService.save(string: voipToken, for: .voipToken)
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didInvalidatePushTokenFor type: PKPushType) {
        print(#line, "invalid \(self)")
    }

    func pushRegistry(
        _ registry: PKPushRegistry,
        didReceiveIncomingPushWith payload: PKPushPayload,
        for type: PKPushType, completion: @escaping () -> Void) {

      
        if type == .voIP {
          print(#line, "lets fire PKPushPayload voIP")
          if let handle = payload.dictionaryPayload["aps"] {
            print(#line, handle)
          }
        }
          
    }
}
