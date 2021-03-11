//
//  UserViewModel.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 17.10.2020.
//

import Foundation
import Combine
import SwiftUI

import FuncNetworking
import UserClient
import EventClient
import KeychainService
import AttachmentClient
import AddaMeModels

public class UserViewModel: ObservableObject {
  
  @Published var showingImagePicker = false
  @Published var inputImage: UIImage?
  @Published var moveToSettingsView = false
  @Published var moveToAuthView: Bool = false
  @Published var user: User = User.draff
  @AppStorage(AppUserDefaults.Key.isUserFristNameUpdated.rawValue)
  public var isUserFristNameUpdated: Bool = false
  
  // Edit/Update Profile
  @Published var firstName: String = ""
  @Published var lastName: String = ""
  
  @Published var isUserHaveAvatarLink: Bool = false
  
  @Published var uploading = false
  public let tabBarHidePS = PassthroughSubject<Bool, Never>()

  var cancellationToken: AnyCancellable?
  
  let eventClient: EventClient
  let userClient: UserClient
  let attachmentClient: AttachmentClient
  
  public init(
    eventClient: EventClient,
    userClient: UserClient,
    attachmentClient: AttachmentClient
  ) {
    self.eventClient = eventClient
    self.userClient = userClient
    self.attachmentClient = attachmentClient
    
    self.fetchMySelf()
  }
  
  func tabBarHideAction(_ value: Bool) {
    tabBarHidePS.send(value)
  }
}

extension UserViewModel {
  
  func loadImage() {
    guard let inputImage = inputImage else { return }
    uploadAvatar(inputImage)
  }
  
  func updateUserName() {
    guard let my: User = KeychainService.loadCodable(for: .user) else {
      return
    }
    
    var cuser = my
    cuser.firstName = firstName
    cuser.lastName = lastName
    
    cancellationToken = userClient.update(cuser, "update")
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
      KeychainService.save(codable: res, for: .user)
      self.isUserFristNameUpdated = self.user.firstName == nil ? false : true
    })

  }

  func fetchMySelf() {

    guard let my: User = KeychainService.loadCodable(for: .user), !my.id.isEmpty else {
      print(#line, "USER id is missing")
      return
    }
    
    cancellationToken = userClient.me(my.id, "\(my.id)")
    .receive(on: RunLoop.main)
    .sink(receiveCompletion: { completionResponse in
      switch completionResponse {
      case .failure(let error):
        print(#line, self, error)
      case .finished:
        break
      }
    }, receiveValue: { [weak self] res in
      guard let self = self else { return }
      self.user = res
      KeychainService.save(codable: res, for: .user)
      self.isUserFristNameUpdated = self.user.firstName == nil ? false : true
      self.isUserHaveAvatarLink = self.user.lastAvatarURLString != nil
    })
  }
  
  func uploadAvatar(_ image: UIImage) {
    uploading = true
    
    guard let me: User = KeychainService.loadCodable(for: .user) else {
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

    cancellationToken = attachmentClient.uploadAvatar(attachment)
      .sink(receiveCompletion: { completionResponse in
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
  
  func resetAuthData() {
    AppUserDefaults.save(false, forKey: .isAuthorized)
    KeychainService.save(codable: User?.none, for: .user)
    KeychainService.save(codable: AuthResponse?.none, for: .token)
    KeychainService.logout()
    AppUserDefaults.erase()
  }
  
}

