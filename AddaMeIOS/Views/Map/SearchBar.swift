//
//  SearchBar.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 12.09.2020.
//

import Foundation
import SwiftUI
import MapKit
import Combine

struct SearchBar: View {
    @Binding var text: String
    @State private var isEditing = false

    var body: some View {
        HStack {
            TextField("Search ...", text: $text)
                .padding(3)
                .padding(.horizontal, 25)
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 0)

                        if isEditing {
                            Button(action: {
                                self.text = ""
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 5)
                            }
                        }
                    }
                )
                .padding(.horizontal, 10)
                .onTapGesture {
                    self.isEditing = true
                }

        }
        .padding(10)
        .background(Color(.systemGray6))
        .clipShape(Capsule())

    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(text: .constant(""))
    }
}

class LocationSearchService: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    
    enum LocationStatus: Equatable {
        case idle
        case noResults
        case isSearching
        case error(String)
        case result
    }
    
    @Published var searchQuery = ""
    @Published var completions: [MKLocalSearchCompletion] = []
    @Published private(set) var status: LocationStatus = .idle
    @Published var mapItems: [MKMapItem] = []
    @Published var userLatitude: Double = 0
    @Published var userLongitude: Double = 0
    
    var completer: MKLocalSearchCompleter
    var cancellable: AnyCancellable?
    
    private let locationManager = CLLocationManager()
    
    @State var mapViewModel = MapViewModel()

    override init() {
        completer = MKLocalSearchCompleter()
        completer.resultTypes = .address
        
        super.init()
        completer.delegate = self
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()

        cancellable = $searchQuery
            .receive(on: DispatchQueue.main)
            .debounce(for: .milliseconds(150), scheduler: RunLoop.main, options: nil)
            .sink(receiveValue: { fragment in
                    self.status = .isSearching
                    if !fragment.isEmpty {
                        self.completer.queryFragment = fragment
                    } else {
                        self.status = .idle
                        self.mapItems = []
                    }
            })
    }

    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        //self.completions = completer.results
        
        self.status = completer.results.isEmpty ? .noResults : .result
        self.mapItems = []
        completer.results.forEach { mKLocalSearchCompletion in
            
            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = mKLocalSearchCompletion.title
            request.region = mapViewModel.mapView.region
            let search = MKLocalSearch(request: request)
            search.start { (response, error) in
                guard let response = response else {return}
                self.mapItems.append(contentsOf: response.mapItems)
            }
        }
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        self.status = .error(error.localizedDescription)
    }
}

extension MKLocalSearchCompletion: Identifiable {}

extension LocationSearchService: CLLocationManagerDelegate {
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.last else { return }
    userLatitude = location.coordinate.latitude
    userLongitude = location.coordinate.longitude
    print(location)
  }
}

import Contacts

extension MKPlacemark {
    var formattedAddress: String? {
        guard let postalAddress = postalAddress else { return nil }
        return CNPostalAddressFormatter.string(
            from: postalAddress, style: .mailingAddress)
            .replacingOccurrences(of: "\n", with: " "
        )
    }
}
