//
//  TabView.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 26.08.2020.
//

import SwiftUI
import Combine

struct TabView: View {
    @State var index = 0
    @State var expand = true
    @State var searchExpand = true
    @EnvironmentObject var data: MsgDatas
    @EnvironmentObject var globalBoolValue: GlobalBoolValue
    
    var body: some View {
        
        VStack(alignment: .center) {
            //TabBarTopView(expand: self.$expand, searchExpand: self.$searchExpand)

            ZStack {
                if index == 0 {
                    //EventForm()
                    EventList()
                } else if index == 1 {
                    NavigationView {
                        ChatView()
                            .navigationBarTitle("",displayMode: .inline)
                            .navigationBarHidden(true)
                    }
                } else if index == 2 {
                    ProfileView()
                }
            }
            
            Spacer()
            if self.globalBoolValue.isTabBarHidden {
                CustomTabs(index: self.$index, expand: self.$expand, searchExpand: self.$searchExpand)
            }
        }
        .background(Color.white)//.edgesIgnoringSafeArea(.top)
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        TabView().environmentObject(GlobalBoolValue())
    }
}

struct CustomTabs: View {
    @Binding var index: Int
    @Binding var expand: Bool
    @Binding var searchExpand: Bool
    
    var body: some View {
        
        HStack {
            
            Button(action: {
                self.index = 0
                self.expand = true
                self.searchExpand = true
            }) {
                VStack {
                    Image(systemName: "captions.bubble")
                    Text("Events")
                }
            }
            .foregroundColor(Color("bg").opacity(self.index == 0 ? 1 : 0.3))
            Spacer()
            
            Button(action: {
                self.expand = false
                self.searchExpand = true
                self.index = 1
            }) {
                VStack {
                    Image(systemName: "bubble.left.and.bubble.right.fill")
                    Text("Chat")
                }
            }
            .foregroundColor(Color("bg").opacity(self.index == 1 ? 1 : 0.3))
            
            Spacer()
            
            Button(action: {
                self.expand = false
                self.searchExpand = false
                self.index = 2
            }) {
                VStack {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
            }
            .foregroundColor(Color("bg").opacity(self.index == 2 ? 1 : 0.3))

        }
        .padding()
        .background(Color.white)
    }
}

struct SettingsView: View {
//    @State var expand = false
//    @State var searchExpand = false
    var body: some View {
        Text("Welcome Settings Page")
    }
}
