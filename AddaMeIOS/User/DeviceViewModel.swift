//
//  DeviceViewModel.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 29.11.2020.
//

//import Foundation
//import Combine
//import Pyramid
//import UIKit
//
//class DeviceViewModel: ObservableObject {
//  
//  @Published var device: Device?
//  
//  let provider = Pyramid()
//  var cancellationToken: AnyCancellable?
//  
//  init() {
//    createOrUpdate()
//  }
//  
//}
//
//extension DeviceViewModel {
//  func createOrUpdate() {
//    guard let my: CurrentUser = KeychainService.loadCodable(for: .currentUser),  UserDefaults.standard.bool(forKey: "isAuthorized") else {
//      return
//    }
//
//    guard let token: String = KeychainService.loadString(for: .deviceToken),
//          let voipToken: String = KeychainService.loadString(for: .voipToken) else {
//      print(#line, "token or voipToken are missing")
//      return
//    }
//    
//    let device = Device(id: nil, ownerId: my.id, name: UIDevice.current.name, model: UIDevice.current.model, osVersion: UIDevice.current.systemVersion, token: token, voipToken: voipToken, createAt: nil, updatedAt: nil)
//    
//    cancellationToken = provider.request(
//      with: DeviceAPI.createOrUpdate(device),
//      scheduler: RunLoop.main,
//      class: Device.self
//    )
//    .receive(on: RunLoop.main)
//    .sink(receiveCompletion: { completionResponse in
//      switch completionResponse {
//      case .failure(let error):
//        print(error)
//      case .finished:
//        break
//      }
//    }, receiveValue: { [weak self] res in
//      guard let self = self else { return }
//      self.device = res
//    })
//  }
//}
