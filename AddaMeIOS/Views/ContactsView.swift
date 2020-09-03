//
//  ContactsView.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 02.09.2020.
//

import SwiftUI
import Contacts
import Foundation

struct ContactsView: View {
//    @State var expand = false
//    @State var searchExpand = true
    @EnvironmentObject var store: ContactStore
    let image = UIImage(systemName: "person.circle")
    
    var body: some View {
 
        VStack {
            Text("Contacts")
            
                List(store.contacts) { contact in
                    HStack {
                        Image("Alif")
                            .resizable()
                            .renderingMode(.original)
                            .frame(width: 55, height: 55)
                            .clipShape(Circle())
                        
                        VStack(alignment: .leading) {
                            Text(contact.fullName ?? "")
                            Text(contact.phoneNumber)
                        }
                        
                        Spacer(minLength: 0)
                        
                        VStack{
                            Text("\(DateHelper.dateFormatter(timestamp: Double(Date().timeIntervalSince1970))!)")
                            Spacer()
                        }
                        
                    }
                    //return Text(contact.name)
                }.onAppear {
                    DispatchQueue.main.async {
                        self.store.buildContacts()
                    }
                }
            
        }
    }
}

struct ContactsView_Previews: PreviewProvider {
    static var previews: some View {
        ContactsView()
    }
}
