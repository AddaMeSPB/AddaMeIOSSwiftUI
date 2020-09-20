//
//  ProfileView.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 04.09.2020.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var settingMenu = SettingsMenuView()
    @State var moveToAuth: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                
                Image("Rafael")
                    .resizable()
                    //.renderingMode(.original)
                    .scaledToFit()
                //.frame(width: 170, height: 170, alignment: .center)
                    .clipShape(Circle())
                
                Text("Saroar Kkhandoker")
                    .font(.title).bold()
                    .padding()
                
                List(settingMenu.smenus) { menu in
                    NavigationLink(destination: DynamicView.destination(menu.id) ) {
                        MenuRow(smenu: menu)
                    }
                }
                .navigationBarTitle("Profile", displayMode: .inline)
                .frame(height: 160)
                
                Spacer()
                Button(action: {
                    KeychainService.logout()
                    self.moveToAuth.toggle()
                }) {
                    Text("Logout")
                        .font(.title)
                        .bold()
                }.background(
                    
                    NavigationLink.init(
                        destination: AuthView(),
                        isActive: $moveToAuth,
                        label: {}
                    )
                )
                .navigationBarHidden(true)
                
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


class SettingsMenuView: ObservableObject {
    @Published var smenus: [SMenu]
    
    init() {
        self.smenus = globalMenus
    }
}

struct SMenu: Codable, Identifiable {
    var id: Int
    var name: String
    var imageName: String
}

var globalMenus: [SMenu] = [
    SMenu(
        id: 1,
        name: "Account Details",
        imageName: "ant.circle"
    ),
    SMenu(
        id: 2,
        name: "Settings",
        imageName: "ant.circle"
    ),
    SMenu(
        id: 3,
        name: "Notifications",
        imageName: "ant.circle"
    )
]

struct MenuRow: View {
    var smenu: SMenu
    var body: some View {
        HStack {
            Image(systemName: smenu.imageName)
                .resizable()
                .renderingMode(.original)
                .frame(width: 30, height: 30)
                .clipShape(Circle())
            Text(smenu.name)
        }
    }
}

class DynamicView {
    static func destination(_ index: Int) -> AnyView {
        switch index {
        case 1:
            return AnyView(ChatView())
        case 2:
            return AnyView(SettingsView())
        default:
            return AnyView(EmptyView())
        }
    }
}
