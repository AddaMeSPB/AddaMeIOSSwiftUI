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
    @State var currentEventPlace: EventPlace = EventPlace.defualtInit
    @StateObject private var locationManager = LocationManager()
    
    var body: some View {
      ZStack {
        if locationManager.locationPermissionStatus {
          NavigationView {
            ScrollView {
              LazyVStack {
                ForEach(eventViewModel.events) { event in
                  EventRow(event: event)
                    .environmentObject(appState)
                    .padding([.leading, .trailing], 8)
                    .onAppear {
                      eventViewModel.fetchMoreEventIfNeeded(currentItem: event)
                    }
                    .onTapGesture {
                      self.eventViewModel.event = event
                      //self.eventViewModel.checkPoint = event.checkPoint()
                      self.moveToEventPreviewView = true
                    }
                    .sheet(isPresented: self.$moveToEventPreviewView) {
//                      EventDetail(
//                        event: self.eventViewModel.event!,
//                        checkP: self.eventViewModel.checkPoint
//                      ).environmentObject(appState)
                    }
                }
                
                if eventViewModel.isLoadingPage {
                  ProgressView()
                }
              }
            }
            .onAppear {
              self.eventViewModel.fetchMoreEvents()
              self.updateCurrentPlace()
            }
            .navigationTitle("Hagnouts")
            .navigationBarTitleDisplayMode(.automatic)
            .toolbar {
              ToolbarItem(placement: ToolbarItemPlacement.navigationBarTrailing) {
                addButton
              }
            }
          }
        
        } else {
          
          VStack {
            Spacer()
            Text("Sorry you cant see others EVENT without allow your locations.")
              .bold()
              .multilineTextAlignment(.center)
              .padding(.bottom, 30)
            Button {
              UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            } label: {
              VStack {
              Image(systemName: "location.circle")
                .imageScale(.large)
              Text("Click Here to acceess your \n Location Permision")
                .multilineTextAlignment(.center)
              }
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.red)
            .clipShape(Capsule())
            
            
            Spacer()
          }
          .padding(50)
          
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
              destination: EventForm(currentPlace: currentEventPlace, locationManager: locationManager)
                    .edgesIgnoringSafeArea(.bottom)
                    .onAppear(perform: {
                        appState.tabBarIsHidden = true
                        self.selectedTag = false
                    })
                    .onDisappear(perform: {
                        appState.tabBarIsHidden = false
                        eventViewModel.fetchMoreEvents()
                    }),
                isActive: $selectedTag
            ) {
                EmptyView()
            }
        )
    }
    
  
  func updateCurrentPlace() {
    if locationManager.locationPermissionStatus {
      DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
        currentEventPlace.coordinates = locationManager.currentCoordinate.double
        locationManager.fetchAddress(for: currentEventPlace)
      }
    }
  }
}

struct EventList_Previews: PreviewProvider {
    static var previews: some View {
        EventList()
          .environmentObject(AppState())
        //        .environment(\.colorScheme, .dark)
    }
}
