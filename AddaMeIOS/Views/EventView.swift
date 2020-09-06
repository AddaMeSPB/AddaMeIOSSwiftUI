//
//  EventView.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 26.08.2020.
//

import SwiftUI

struct EventList: View {
    @ObservedObject var eventViewModel = EventViewModel()
    
    var body: some View {
        NavigationView {
            list.navigationBarItems(trailing: addButton)
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
        }

    }
    
    private var addButton: some View {
        Button(action: {
            // action goes here :) 
        }) {
            Image(systemName: "plus.circle.fill")
            .frame(width: 40, height: 40)
        }
    }
}

struct EventList_Previews: PreviewProvider {
    static var previews: some View {
        EventList()
    }
}
