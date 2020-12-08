//
//  UserViewModel.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 17.10.2020.
//

import Foundation
import Combine
import Pyramid
import UIKit
import SwiftUI

class UserViewModel: ObservableObject {
  
  @Published var user: CurrentUser = CurrentUser.dInit
  @AppStorage(AppUserDefaults.Key.isAuthorized.rawValue) var isAuthorized: Bool = false
  @AppStorage(AppUserDefaults.Key.isUserFristNameUpdated.rawValue) var isUserFristNameUpdated: Bool = false
  
  @Published var uploading = false
  
  let provider = Pyramid()
  var cancellationToken: AnyCancellable?
  
  init() {
    self.fetchMySelf()
  }
  
}

extension UserViewModel {
  
  func updateUserName(_ firstName: String, _ lastName: String?) {
    guard let my: CurrentUser = KeychainService.loadCodable(for: .currentUser) else {
      return
    }
    
    var cuser = my
    cuser.firstName = firstName
    cuser.lastName = lastName
    
    cancellationToken = provider.request(
      with: UserAPI.update(cuser),
      scheduler: RunLoop.main,
      class: CurrentUser.self
    )
    .receive(on: RunLoop.main)
    .sink(receiveCompletion: { completionResponse in
      switch completionResponse {
      case .failure(let error):
        print(error)
      case .finished:
        break
      }
    }, receiveValue: { [weak self] res in
      guard let self = self else { return }
      self.isUserFristNameUpdated = true
      self.user = res
      KeychainService.save(codable: res, for: .currentUser)
      self.isUserFristNameUpdated = self.user.firstName == nil ? false : true
    })

  }
  
  func fetchMySelf() {
    guard let my: CurrentUser = KeychainService.loadCodable(for: .currentUser) else {
      return
    }
    
    cancellationToken = provider.request(
      with: UserAPI.me(my.id),
      scheduler: RunLoop.main,
      class: CurrentUser.self
    )
    .receive(on: RunLoop.main)
    .sink(receiveCompletion: { completionResponse in
      switch completionResponse {
      case .failure(let error):
        print(error)
      case .finished:
        break
      }
    }, receiveValue: { [weak self] res in
      guard let self = self else { return }
      self.user = res
      KeychainService.save(codable: res, for: .currentUser)
      self.isUserFristNameUpdated = self.user.firstName == nil ? false : true
    })
  }
  
  func uploadAvatar(_ image: UIImage) {
    uploading = true
    
    guard let me: CurrentUser = KeychainService.loadCodable(for: .currentUser) else {
      uploading = false
      return
    }
    
    AWSS3Helper.uploadImage(image, conversationId: nil, userId: me.id) { [weak self] imageURLString in
      guard imageURLString != nil else {
        DispatchQueue.main.async { self?.uploading = false }
        return
      }
      
      DispatchQueue.main.async {
        self?.uploading = false
        let attachment = Attachment(type: .image, userId: me.id, imageUrlString: imageURLString)
        self?.createAttachment(attachment)
      }
    }
  }
  
  func createAttachment(_ attachment: Attachment) {

    cancellationToken = provider.request(
      with: AttachmentAPI.create(attachment),
      scheduler: RunLoop.main,
      class: Attachment.self
    ).sink(receiveCompletion: { completionResponse in
      switch completionResponse {
      case .failure(let error):
        print(error)
      case .finished:
        break
      }
    }, receiveValue: { [weak self] res in
      print(#line, res)
      self?.fetchMySelf()
    })
  }
  
}

