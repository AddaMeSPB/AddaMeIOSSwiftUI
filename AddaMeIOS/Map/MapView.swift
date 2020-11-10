//
//  MapViewModel.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 10.09.2020.
//

import SwiftUI
import MapKit

struct MapView: View {
  
  let location: EventPlace
  let places: [EventPlace]
  
  @State private var region: MKCoordinateRegion
  @State private var mapType: MKMapType = .standard
  @State private var showSearch = false
  @State private var isEventDetailsView: Bool = false
  @State private var selectedItem: MKMapItem?
  
  @StateObject private var locationQuery: LocationQuery
  @Environment(\.presentationMode) private var presentationMode
  
  private var currentLocation: Binding<String?>
  private var textBinding: Binding<String> {
    Binding<String>(
      get: { print(#line, location.addressName, currentLocation); return location.addressName },
      set: { newString in print(#line, newString); location.addressName = newString }
    )
  }
  
  init(location: EventPlace, places: [EventPlace], isEventDetailsView: Bool = false) {
    self.location = location
    self.places = places
    _isEventDetailsView = State(initialValue: isEventDetailsView)
    _region = State(initialValue: location.region)
    currentLocation = Binding.constant(location.addressName)
    _locationQuery = StateObject(wrappedValue: LocationQuery(region: location.region))
  }
  
  var body: some View {
    ZStack {
      
      MapViewUI(location: location, places: places, mapViewType: mapType, isEventDetailsView: isEventDetailsView)
      
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
            
            TextField("Searching...", text: showSearch == false ? textBinding : $locationQuery.searchQuery)
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
                location.addressName = data.placemark.formattedAddress ?? ""
                location.coordinates = [data.placemark.coordinate.latitude, data.placemark.coordinate.longitude]
              }) {
                Text(data.placemark.formattedAddress ?? "")
              }
              
            }
            
          } else {
            Picker("", selection: $mapType) {
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
    MapView(location: place[0], places: place)
  }
}


//struct MapView: View {
//
//  @State private var moveSearchView = false
//  @State private var isSearchHidden = false
//
//  @State var checkPoint: CheckPoint = CheckPoint(title: "", coordinate: CLLocationCoordinate2DMake(60.014506, 30.388123))
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
//        return self.checkPoint.title ?? ""
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
//  @State var addressNameValidation: String = ""
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
