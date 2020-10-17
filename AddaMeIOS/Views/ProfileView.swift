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
    @Environment(\.imageCache) var cache: ImageCache
    @ObservedObject var me = UserViewModel()
    
    var body: some View {

        NavigationView {
            VStack() {

                AsyncImage(
                    avatarLink: me.user?.avatarUrl,
                    placeholder: Text("Loading ..."),
                    cache: self.cache,
                    configuration: {
                        $0.resizable()
                    }
                )
                .frame(width: 160, height: 160)
                .clipShape(Circle())


                Text(me.user?.fullName ?? "Missing UR Name")
                    .font(.title).bold()
                    .padding()

                    VStack(alignment: .leading) {
                        ForEach(settingMenu.smenus) { menu in
                            NavigationLink(destination: DynamicView.destination(menu.id) ) {
                                HStack {
                                    MenuRow(smenu: menu)
                                    Spacer()
                                }
                            }
                        }
                    }

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
            return AnyView(SettingsView())
        case 2:
            return AnyView(SettingsView())
        default:
            return AnyView(EmptyView())
        }
    }
}
