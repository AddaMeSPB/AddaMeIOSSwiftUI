//
//  EventView.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 26.08.2020.
//

import SwiftUI
import MapKit

struct EventList: View {
    
    @State var selectedTag = false
    
    @StateObject private var eventViewModel = EventViewModel()
    
    @EnvironmentObject var appState: AppState
    @State private var moveToEventPreviewView = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack {
                    ForEach(eventViewModel.events) { event in
                        EventRow(event: event)
                            .padding([.leading, .trailing], 8)
                            .onAppear {
                                eventViewModel.fetchMoreEventIfNeeded(currentItem: event)
                            }
                            .onTapGesture {
                                self.eventViewModel.event = event
                                self.eventViewModel.checkPoint = event.checkPoint()
                                self.moveToEventPreviewView = true
                            }
                            .sheet(isPresented: self.$moveToEventPreviewView) {
                                EventDetail(
                                    event: self.eventViewModel.event!,
                                    checkP: self.eventViewModel.checkPoint!
                                )
                            }
                    }
                    
                    if eventViewModel.isLoadingPage {
                        ProgressView()
                    }
                }
            }
            .onAppear {
                self.eventViewModel.fetchMoreEvents()
            }
            .navigationTitle("Hagnouts")
            .navigationBarTitleDisplayMode(.automatic)
            .toolbar {
                ToolbarItem(placement: ToolbarItemPlacement.navigationBarTrailing) {
                    addButton
                }
            }
        }
        
    }
    
    
    private var addButton: some View {
        Button(action: {
            self.selectedTag = true
        }) {
            Image(systemName: "plus.circle")
                .font(.largeTitle)
                .foregroundColor(Color("bg"))
        }.background(
            NavigationLink(
                destination: EventForm()
                    .environmentObject(appState)
                    .edgesIgnoringSafeArea(.bottom)
                    .onAppear(perform: {
                        appState.tabBarIsHidden = true
                        self.selectedTag = false
                    })
                    .onDisappear(perform: {
                        appState.tabBarIsHidden = false
                    }),
                isActive: $selectedTag
            ) {
                EmptyView()
            }
        )
    }
    
}

struct EventList_Previews: PreviewProvider {
    static var previews: some View {
        EventList()
        //        .environment(\.colorScheme, .dark)
    }
}
