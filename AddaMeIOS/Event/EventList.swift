//
//  EventView.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 26.08.2020.
//

import SwiftUI
import MapKit

struct EventList: View {
    
  @State var showFormView = false
  @State var currentEventPlace = EventResponse.Item.defint
  @State var selectedEvent: EventResponse.Item?
  
  @EnvironmentObject var appState: AppState
  @StateObject private var eventViewModel = EventViewModel()
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
                      self.selectedEvent = event
                    }
                    .sheet(item: self.$selectedEvent) { event in
                        EventDetail(event: event)
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
          .navigationViewStyle(StackNavigationViewStyle())
        
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
            self.showFormView = true
        }) {
            Image(systemName: "plus.circle")
                .font(.largeTitle)
                .foregroundColor(Color("bg"))
        }.background(
            NavigationLink(
              destination: EventForm()
                    .environmentObject(locationManager)
                    .edgesIgnoringSafeArea(.bottom)
                    .onAppear(perform: {
                        appState.tabBarIsHidden = true
                        self.showFormView = false
                    })
                    .onDisappear(perform: {
                        appState.tabBarIsHidden = false
                        eventViewModel.fetchMoreEvents()
                    }),
                isActive: $showFormView
            ) {
                EmptyView()
            }
        )
    }
    
  
  func updateCurrentPlace() {
    guard let loc = locationManager.currentCoordinate else {
      return
    }
    
    if locationManager.locationPermissionStatus {
      DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
        currentEventPlace.coordinates = loc.double
        locationManager.fetchAddress()
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
