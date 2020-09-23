//
//  EventView.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 26.08.2020.
//

import SwiftUI

struct EventList: View {

    @StateObject var eventViewModel = EventViewModel()
    @State var selectedTag = false
    @EnvironmentObject var globalBoolValue: GlobalBoolValue

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack { // eventData.items
                    ForEach(eventViewModel.events) { event in
                        NavigationLink(destination: EventDetail(event: event)) {
                            EventRow(event: event)
                                .frame(height: 100)
                                .onAppear {
                                    eventViewModel.fetchMoreEventIfNeeded(currentItem: event)
                                }
                                .padding(10)
                        }
                        
                    }
                    
                    if eventViewModel.isLoadingPage {
                        ProgressView()
                    }
                }
            }
            .navigationTitle("Hagnouts")
            .navigationBarTitleDisplayMode(.automatic)
            .toolbar {
                ToolbarItem(placement: ToolbarItemPlacement.navigationBarTrailing) {
                    addButton
                }
            }
        }
        .onAppear {
            self.globalBoolValue.isTabBarHidden = false
        }

    }
    
    private var addButton: some View {
        Button(action: {
            DispatchQueue.main.async {
                self.selectedTag = true
                self.globalBoolValue.isTabBarHidden = true
            }
        }) {
            Image(systemName: "plus.circle")
                .font(.largeTitle)
                .foregroundColor(Color("bg"))
        }.background(
            NavigationLink(destination: EventForm(), isActive: $selectedTag) {
                EmptyView()
            }
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
