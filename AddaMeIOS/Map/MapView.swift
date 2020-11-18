//
//  MapViewModel.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 10.09.2020.
//

import SwiftUI
import MapKit

struct MapView: View {
  
  @State var place: EventPlace
  @State var places: [EventPlace]
  
  @State private var region: MKCoordinateRegion
  @State private var mapType: MKMapType = .standard
  @State private var showSearch = false
  @State private var isEventDetailsView: Bool = false
  @State private var selectedItem: MKMapItem?
  
  @StateObject private var locationQuery: LocationQuery
  @Environment(\.presentationMode) private var presentationMode
  
  private var eventPlaceBinding: Binding<EventPlace> {
    Binding<EventPlace>(
      get: { return place },
      set: { newString in place = newString }
    )
  }
  
  init(place: EventPlace, places: [EventPlace], isEventDetailsView: Bool = false) {
    _place = State(initialValue: place)
    _places = State(initialValue: places)
    _isEventDetailsView = State(initialValue: isEventDetailsView)
    _region = State(initialValue: place.region)
    _locationQuery = StateObject(wrappedValue: LocationQuery(region: place.region))
  }
  
  var body: some View {
    ZStack {
      
      MapViewUI(place: place, places: places, mapViewType: mapType, isEventDetailsView: isEventDetailsView)
      
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

  }
}

struct MapView_Previews: PreviewProvider {
  static var previews: some View {
    let place = demoPlaces
    MapView(place: place[0], places: place)
  }
}


//struct MapView: View {
//
//  @State private var moveSearchView = false
//  @State private var isSearchHidden = false
//
//  @State var checkPoint: CheckPoint = CheckPoint(title: String.empty, coordinate: CLLocationCoordinate2DMake(60.014506, 30.388123))
//  @State var moveToEventForm = false
//
//  @Environment(\.colorScheme) var colorScheme
//  @EnvironmentObject var locationSearchService: LocationSearchService
//  @Environment(\.presentationMode) var presentationMode
//
//  @Binding var checkPointRequest: CheckPoint
//
//  var textBinding: Binding<String> {
//    Binding<String>(
//      get: {
//        return self.checkPoint.title ?? String.empty
//      },
//      set: { newString in
//        self.checkPoint.title = newString
//        addressNameValidation = newString
//      })
//  }
//
//  var idAddressNameValid: Bool {
//    checkPoint.title?.count ?? 0 < 1
//  }
//
//  @State var addressNameValidation: String = String.empty
//
//  var body: some View {
//    ZStack {
//
//      if isSearchHidden {
//        HStack(alignment: .top) {
//          Spacer()
//          VStack {
//            HStack {
//              TextField("Search ...", text: textBinding)
//                .padding(3)
//                .padding(.horizontal, 25)
//                .cornerRadius(8)
//                .overlay(
//                  HStack {
//                    Image(systemName: "magnifyingglass")
//                      .foregroundColor(.gray)
//                      .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
//                      .padding(.leading, 0)
//                  }
//                )
//                .padding(.horizontal, 10)
//                .onTapGesture {
//                  self.moveSearchView.toggle()
//                }
//            }
//            .padding(10)
//            .background(Color(.systemGray6))
//            .clipShape(Capsule())
//            .sheet(isPresented: self.$moveSearchView) {
//              MapView(checkPointRequest: $checkPointRequest)
//            }
//
//            Spacer()
//          }
//        }
//        .zIndex(33)
//        .padding()
//
//      }
//      VStack {
//        let isEventDetailsPage: Binding = .constant(false)
//        MapViewModel(checkPoint: $checkPoint, isEventDetailsPage: isEventDetailsPage)
//      }
//
//      VStack(alignment: .center) {
//        Spacer()
//        Button(action: {
//          self.checkPointRequest = self.checkPoint
//          self.presentationMode.wrappedValue.dismiss()
//        }) {
//          Text("Done")
//            .font(.title)
//            .bold()
//        }
//        .disabled(idAddressNameValid)
//        .opacity(idAddressNameValid ? 0 : 1)
//        .padding()
//      }
//    }
//  }
//
//}
//
//struct MapView_Previews: PreviewProvider {
//  static var previews: some View {
//    let data = eventData[0].geoLocations.last!
//
//    let checkPoint = CheckPoint(title: data.addressName, coordinate: CLLocationCoordinate2DMake(data.coordinates[0], data.coordinates[1]))
//    MapView(checkPointRequest: .constant(checkPoint) )
//  }
//}
