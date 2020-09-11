//
//  EventView.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 26.08.2020.
//

import SwiftUI

struct EventList: View {

    @ObservedObject var eventViewModel = EventViewModel()
    @State var selectedTag: String?
    @EnvironmentObject var globalBoolValue: GlobalBoolValue

    var body: some View {
        NavigationView {
            list.navigationBarItems(trailing: addButton)
        }.onAppear() {
            // UINavigationBar.appearance().backgroundColor = UIColor(named: "red")
            // self.globalBoolValue.isTabBarHidden.toggle()
        }
    }
    
    private var list: some View {
        VStack {
            List(eventViewModel.events) { event in //globalEvents
                NavigationLink(destination: EventDetail(event: event)) {
                    EventRow(event: event)
                        .frame(height: 100)
                }
            }
            .navigationBarTitle("Hangouts")
            .navigationBarItems(leading:
                Button(action: {
                    self.globalBoolValue.isTabBarHidden.toggle()
                }) {
                    HStack {
                        Image(systemName: "arrow.left")
                        Text("Go Back")
                    }
                }
            )
        }

    }
    
    private var addButton: some View {
        Button(action: {
            self.selectedTag = "moveEventForm"
            self.globalBoolValue.isTabBarHidden.toggle()
        }) {
            Image(systemName: "plus.circle")
                .padding()
                .background(Color.red)
                .foregroundColor(Color.white)
                .clipShape(Circle())
        }.background(
            NavigationLink(
                destination: EventForm(),
                tag: "moveEventForm",
                selection: $selectedTag,
                label: { Text("")  }
            )
        )
        .navigationBarHidden(true)

    }
}

struct EventList_Previews: PreviewProvider {
    static var previews: some View {
        EventList()
//        .environment(\.colorScheme, .dark)
    }
}
