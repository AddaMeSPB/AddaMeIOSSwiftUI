//
//  ContactViewModel.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 02.09.2020.
//

//import Contacts
//import SwiftUI
//import os
//import PhoneNumberKit
//import Combine
//import Pyramid
//import CoreData
//
//class ContactStore: ObservableObject {
//  
//  @Published var isAuthorization = false
//  
//  init() {
//
//      CNContactStore().requestAccess(for: .contacts) { [weak self] granted, _ in
//        guard let self = self else { return }
//        if granted {
//          DispatchQueue.main.async {
//            self.isAuthorization = true
//            self.buildContacts()
//          }
//        } else {
//          DispatchQueue.main.async {
//            self.isAuthorization = false
//          }
//        }
//      }
//  }
//  
//  var authorization: CNAuthorizationStatus {
//    return CNContactStore.authorizationStatus(for: .contacts)
//  }
//  
//  var updateLocalPhoneNumberArray = [Contact]()
//  
//  private let phoneNumberKit = PhoneNumberKit()
//  
//  private func getCNContacts() -> [CNContact] {
//    let store = CNContactStore()
//    
//    guard let containers = try? store.containers(matching: nil) else {
//      return []
//    }
//    
//    let keysToFetch: [CNKeyDescriptor] = [
//      CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
//      CNContactPhoneNumbersKey as CNKeyDescriptor,
//      CNContactIdentifierKey as CNKeyDescriptor
//    ]
//    
//    var cnContacts: [CNContact] = []
//    
//    for container in containers {
//      let predicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
//      
//      guard let contactss = try? store.unifiedContacts(matching: predicate, keysToFetch: keysToFetch) else {
//        continue
//      }
//      
//      cnContacts += contactss
//    }
//    
//    return cnContacts
//  }
//  
//  
//  func buildContacts() {
//    
//    guard let currentUSER: CurrentUser = KeychainService.loadCodable(for: .currentUser) else {
//      return
//    }
//    
//    let cnContacts = getCNContacts()
//    
//    var result: [Contact] = []
//    
//    for cnContact in cnContacts {
//      guard let fullName = CNContactFormatter.string(from: cnContact, style: .fullName) else {
//        continue
//      }
//      
//      let phoneNumberString = cnContact.phoneNumbers.map { ($0.identifier, $0.value.stringValue) }
//      let region = Locale.current
//      
//      let phoneNumbers = phoneNumberString.compactMap({
//        try? self.phoneNumberKit.parse($0.1, withRegion: region.regionCode ?? PhoneNumberKit.defaultRegionCode() )
//      })
//      
//      let mobileNumbers = phoneNumbers.filter({ $0.type == .mobile })
//      let e164MobileNumbers = mobileNumbers.map({ self.phoneNumberKit.format($0, toType: .e164) })
//      
//      result += e164MobileNumbers.map({ phoneNumber in
//        
//        let contactEntity = ContactEntity(context: PersistenceController.shared.moc)
//        contactEntity.id = String.empty
//        contactEntity.fullName = fullName
//        contactEntity.avatar = nil
//        contactEntity.identifier = cnContact.identifier
//        contactEntity.isRegister = false
//        contactEntity.userId = currentUSER.id
//        contactEntity.phoneNumber = phoneNumber
//        
//        return Contact(identifier: cnContact.identifier, userId: currentUSER.id, phoneNumber: phoneNumber, fullName: fullName, avatar: nil, isRegister: false)
//      })
//    }
//    
//    PersistenceController.shared.saveContext()
//    
//    self.createContacts(result)
//  }
//  
//  let provider = Pyramid()
//  var cancellable: AnyCancellable?
//  
//}
//
//extension ContactStore {
//  func createContacts(_ contacts: [Contact]) {
//    
//    cancellable = provider.request(
//      with: ContactAPI.create(contacts: contacts),
//      scheduler: RunLoop.main,
//      class: [CurrentUser].self
//    )
//    .receive(on: DispatchQueue.main)
//    .sink(receiveCompletion: { completionResponse in
//      switch completionResponse {
//      case .failure(let error):
//        print(#line, error)
//      case .finished:
//        break
//      }
//    }, receiveValue: { res in
//      
//      DispatchQueue.main.async {
//        res.forEach { user in
//          
//          let fetchRequest: NSFetchRequest<ContactEntity> = ContactEntity.fetchRequest()
//          fetchRequest.predicate = NSPredicate(format: "phoneNumber = %@", "\(user.phoneNumber)")
//          
//          do {
//            let results = try PersistenceController.shared.moc.fetch(fetchRequest)
//            results.last?.setValue(true, forKey: "isRegister")
//            results.last?.setValue(user.lastAvatarURLString, forKey: "avatar")
//          } catch {
//            print("failed to fetch record from CoreData")
//          }
//          
//        }
//        
//        PersistenceController.shared.saveContext()
//        
//      }
//    })
//  }
//  
//}
