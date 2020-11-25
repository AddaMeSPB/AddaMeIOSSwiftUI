//
//  MapViewModel.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 10.09.2020.
//

import SwiftUI
import MapKit

struct MapView: View {
  
  @State var place: EventResponse.Item
  @State var places: [EventResponse.Item]
  
  @State private var region: MKCoordinateRegion
  @State private var mapType: MKMapType = .standard
  @State private var showSearch = false
  @State private var isEventDetailsView: Bool = false
  @State private var selectedItem: MKMapItem?
  
  @StateObject private var locationQuery: LocationQuery
  @Environment(\.presentationMode) private var presentationMode
  
  private var eventPlaceBinding: Binding<EventResponse.Item> {
    Binding<EventResponse.Item>(
      get: { return place },
      set: { newString in place = newString }
    )
  }
  
  init(place: EventResponse.Item, places: [EventResponse.Item], isEventDetailsView: Bool = false) {
    _place = State(initialValue: place)
    _places = State(initialValue: places)
    _isEventDetailsView = State(initialValue: isEventDetailsView)
    _region = State(initialValue: place.region)
    _locationQuery = StateObject(wrappedValue: LocationQuery(region: place.region))
  }
  
  @ViewBuilder var body: some View {
    ZStack {
      
      MapViewUI(place: place, places: places, mapViewType: mapType, isEventDetailsView: isEventDetailsView)
        .ignoresSafeArea(.all)
      
      Spacer()
      if !isEventDetailsView {
        VStack {
          
          HStack {
            
            if !showSearch {
              Button {
                presentationMode.wrappedValue.dismiss()
              } label: {
                Image(systemName: "xmark.circle.fill")
                  .imageScale(.large)
                  .frame(width: 60, height: 60, alignment: .center)
              }
            }
            
            Spacer()
            
            TextField("Searching...", text: showSearch == false ? eventPlaceBinding.addressName : $locationQuery.searchQuery)
              .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
              .padding(.horizontal, 30)
              .padding(15)
              .overlay(
                HStack {
                  Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 15)
                }
              )
              .background(Color(.systemGray6))
              .clipShape(Capsule())
              .onTapGesture {
                showSearch.toggle()
              }
            
            if showSearch {
              Button {
                showSearch = false
              } label: {
                Text("Cancel")
              }
            }
            
          } // HStack
          .padding()
          Spacer()
          
          if showSearch  {
            List(locationQuery.searchResults, id: \.self) { data in
              
              Button(action: {
                selectedItem = data
                showSearch = false
                place.addressName = data.placemark.formattedAddress ?? String.empty
                place.coordinates = [data.placemark.coordinate.latitude, data.placemark.coordinate.longitude]
              }) {
                Text(data.placemark.formattedAddress ?? String.empty)
              }
              
            }
            
          } else {
            Picker(String.empty, selection: $mapType) {
              Text("Standard").tag(MKMapType.standard)
              Text("Hybrid").tag(MKMapType.hybrid)
              Text("Satellite").tag(MKMapType.satellite)
            }
            .pickerStyle(SegmentedPickerStyle())
            .offset(y: -28)
          }
          
        } // VStack
      }
    } // ZStack
    .ignoresSafeArea(.all)
  }
  
}

struct MapView_Previews: PreviewProvider {
  static var previews: some View {
    let place = eventData
    MapView(place: place[0], places: place)
  }
}
