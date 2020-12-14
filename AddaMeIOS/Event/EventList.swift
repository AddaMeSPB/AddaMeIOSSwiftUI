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
  @Environment(\.colorScheme) var colorScheme
    
  @ViewBuilder  fileprivate func eventNearByView() -> some View {
    VStack {
      ZStack {
        Pulsation(width: 200, height: 200)
        Pulsation(width: 160, height: 160)
        Pulsation(width: 100, height: 100)
        Image(systemName: "location.fill")
          .resizable()
          .scaledToFit()
          .frame(width: 60.0, height: 60)
      }
      .padding()
      
      Text("Event Nearby")
        .font(.largeTitle)
        .bold()
        .padding(.top, 50)
        .padding(.bottom, 10)
      
      Text("Add EVENT nearby cant be view without allow your locations. Also you can't add Event without Allow")
        .font(.title3)
        .bold()
        .multilineTextAlignment(.center)
        .padding(.bottom, 30)
      
      Text("Please allow on location access to enable this feature.")
        .font(.title3)
        .bold()
        .multilineTextAlignment(.center)
        .padding(.bottom, 30)
      
      Button {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
      } label: {
        VStack {
          Text("Allow Acceess")
            .bold()
            .font(.title)
            .multilineTextAlignment(.center)
            .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealWidth: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: 30, idealHeight: 40, maxHeight: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        }
        
      }
      .padding()
      .foregroundColor(colorScheme == .dark ? Color.black: Color.white)
      .background(colorScheme == .dark ? Color.white : Color.black)
      .clipShape(Capsule())
      
      Spacer()
    }
    .padding(50)
    .background(Color(UIColor.systemBackground))
  }
  
  fileprivate func eventListView() -> some View {
    return LazyVStack {
          ForEach(eventViewModel.events) { event in
            EventRow(event: event)
              .environmentObject(appState)
              .padding([.leading, .trailing], 8)
              .onAppear {
                eventViewModel.fetchMoreEventIfNeeded(currentItem: event)
              }
              .onTapGesture {
                selectedEvent = event
              }
              .sheet(item: $selectedEvent) { event in
                EventDetail(event: event)
                  .onAppear {
                    locationManager.isEventDetail = true
                  }.onDisappear {
                    locationManager.isEventDetail = false
                  }
              }
          }
          
          if eventViewModel.isLoadingPage {
            ProgressView()
          }
        }
      
  }
  
  var body: some View {
      ZStack {
        NavigationView {
          ScrollView {
            
            if locationManager.locationPermissionStatus {
              eventListView()
            } else {
              eventNearByView()
            }
            
          }
          .onAppear {
            //locationManager.currentCoordinate
            eventViewModel.fetchMoreEvents()
            updateCurrentPlace()
            locationManager.isEventDetail = false
          }
          .navigationTitle("Hangouts")
          .navigationBarTitleDisplayMode(.automatic)
          .toolbar {
            
            ToolbarItem(placement: ToolbarItemPlacement.navigationBarTrailing) {
              addButton
            }
          }
        }
        .navigationViewStyle(StackNavigationViewStyle())

      }
    }
    
    private var addButton: some View {
      
        Button(action: {
            self.showFormView = true
        }) {
            Image(systemName: "plus.circle")
                .font(.title)
                .foregroundColor(Color("bg"))
        }
        .disabled(!locationManager.locationPermissionStatus)
        .background(
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
          .environment(\.colorScheme, .dark)
    }
}

struct Pulsation: View {
  var width: CGFloat
  var height: CGFloat
  
  init(width: CGFloat, height: CGFloat) {
    self.width = width
    self.height = height
  }
  
  @Environment(\.colorScheme) var colorScheme
  @State private var pulsate = false
  
  var body: some View {
     ZStack {
       Circle()
         .stroke(Color("bg"))
         .frame(width: width, height: height)
          .scaleEffect(pulsate ? 1.3 : 1.1)
          .animation(Animation.easeInOut(duration: 1.1).repeatForever(autoreverses: true))
          .onAppear {
            self.pulsate.toggle()
          }
     }
   }
 }
