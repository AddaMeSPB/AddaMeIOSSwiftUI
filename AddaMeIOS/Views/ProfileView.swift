//
//  ProfileView.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 04.09.2020.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        ZStack {
            VStack {
                Image("Rafael")
                   .resizable()
                   .renderingMode(.original)
                   .frame(width: 170, height: 170)
                   .clipShape(Circle())
                   
                    
                Text("Saroar Kkhandoker")
                    .font(.title).bold()
                    .padding()
                
                
                Button(action: {
                    
                }) {
                    Image(systemName: "ant.circle")
                    .resizable()
                    .renderingMode(.original)
                    .frame(width: 40, height: 40)
                    Text("Account Details")
                    Spacer()
                    Image(systemName: "arrow.right")
                }
                
                Button(action: {
                    SettingsView()
                }) {
                    Image(systemName: "ant.circle")
                    .resizable()
                    .renderingMode(.original)
                    .frame(width: 40, height: 40)
                    Text("Settings")
                    
                    Spacer()
                    Image(systemName: "arrow.right")
                }
                
                Button(action: {
                    
                }) {
                    Image(systemName: "ant.circle")
                    .resizable()
                    .renderingMode(.original)
                    .frame(width: 40, height: 40)
                    Text("Contact Us")
                    Spacer()
                    Image(systemName: "arrow.right")
                }
                
                Spacer()
                Button(action: {
                    
                }) {
                    Text("Logout")
                        .font(.title)
                        .bold()
                }
                Spacer()
            }
            .padding()
            
            
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
