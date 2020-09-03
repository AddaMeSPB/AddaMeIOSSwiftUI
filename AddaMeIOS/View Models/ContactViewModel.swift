//
//  ContactViewModel.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 02.09.2020.
//

import Contacts
import SwiftUI
import os
import PhoneNumberKit

class ContactStore: ObservableObject {
    
    //@Published var contacts: [Contact] = []
//    @Published var contacts: [Contact] = []
    @Published var contacts: [Contact] = []
//    {
//        lock.lock()
//        let contacts = _contacts
//        lock.unlock()
//        return contacts
//    }

    private let lock = NSLock()
    
    var authorization: CNAuthorizationStatus {
        return CNContactStore.authorizationStatus(for: .contacts)
    }

    var updateLocalPhoneNumberArray = [Contact]()

    private let phoneNumberKit = PhoneNumberKit()
    
    private func getCNContacts() -> [CNContact] {
        let store = CNContactStore()
        
        guard let containers = try? store.containers(matching: nil) else {
            return []
        }

        let keysToFetch: [CNKeyDescriptor] = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactImageDataKey as CNKeyDescriptor,
            CNContactThumbnailImageDataKey as CNKeyDescriptor,
            CNContactImageDataAvailableKey as CNKeyDescriptor,
            CNContactPhoneNumbersKey as CNKeyDescriptor
        ]
        
        var cnContacts: [CNContact] = []

        for container in containers {
            let predicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)

            guard let contactss = try? store.unifiedContacts(matching: predicate, keysToFetch: keysToFetch) else {
                continue
            }

            cnContacts += contactss
        }
        
        return cnContacts
    }
    
    
    func buildContacts() {
        
        let cnContacts = getCNContacts()
        
        var result: [Contact] = []
        
        for cnContact in cnContacts {
            guard let fullName = CNContactFormatter.string(from: cnContact, style: .fullName) else {
                continue
            }
            
//            if cnContact.imageDataAvailable {
//                print("image: \(cnContact.phoneNumbers) \(cnContact.thumbnailImageData)")
//            }
            
            let phoneNumberString = cnContact.phoneNumbers.map { ($0.identifier ,$0.value.stringValue) }
            let region = Locale.current

            let phoneNumbers = phoneNumberString.compactMap({
                try? phoneNumberKit.parse($0.1, withRegion: region.regionCode ?? PhoneNumberKit.defaultRegionCode() )
            })

            let mobileNumbers = phoneNumbers.filter({ $0.type == .mobile })
            let e164MobileNumbers = mobileNumbers.map({ phoneNumberKit.format($0, toType: .e164) })

            result += e164MobileNumbers.map({
                Contact(id: UUID(), phoneNumber: $0, fullName: fullName, avatar: cnContact.thumbnailImageData?.base64EncodedString(), isRegister: false)
            })
        }
        
        self.contacts = result

    }
    
}

extension CNContact: Identifiable {
    var name: String {
        return [givenName, middleName, familyName]
            .filter{ $0.count > 0}.joined(separator: " ")
    }
}
