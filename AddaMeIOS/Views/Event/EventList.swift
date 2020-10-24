//
//  EventView.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 26.08.2020.
//

import SwiftUI

struct EventList: View {

    @State var selectedTag = false
    @State var moveToChatRoom = false
    
    @StateObject private var eventViewModel = EventViewModel()
    @ObservedObject var conversationViewModel = ConversationViewModel()

    @EnvironmentObject var appState: AppState
    @State private var moveToEventPreviewView = false

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack {
                    ForEach(eventViewModel.events, id: \.id) { event in
//                        NavigationLink(
//                            destination: LazyView(ChatRoomView(conversation: event.conversation)
//                                .edgesIgnoringSafeArea(.bottom)
//                                .onAppear(perform: {
//                                    appState.tabBarIsHidden = true
//                                })
//                                .onDisappear(perform: {
//                                    appState.tabBarIsHidden = false
//                                })
//                            ),
//                            tag: event.id,
//                            selection: $appState.selectedItemId
//                        ) {
                        EventRow(event: event)
                                .frame(height: 100)
                                .padding(10)
                                .onAppear {
                                    eventViewModel.fetchMoreEventIfNeeded(currentItem: event)
                                }
                                .onTapGesture {
                                    self.eventViewModel.event = event
                                    self.moveToEventPreviewView = true
                                }
                                .sheet(isPresented: self.$moveToEventPreviewView) {
                                    EventDetail(event: self.eventViewModel.event!)
                                }
                            
                                
//                                .onTapGesture {
//                                    if conversationViewModel.isMemberCanMoveToChatRoom(event: event) == true {
//                                        appState.selectedItemId = event.id
//                                    }
//                                }
//                        }
                        
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
