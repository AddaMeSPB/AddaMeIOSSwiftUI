//
//  LocationSearchService.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 18.09.2020.
//

import Foundation
import SwiftUI
import MapKit
import Combine

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
    @Published var coordinate: CLLocationCoordinate2D?
    @State var checkPoint: CheckPoint = CheckPoint(title: "Unknow", coordinate: CLLocationCoordinate2DMake(60.014506, 30.388123))
    
    var completer: MKLocalSearchCompleter
    var cancellable: AnyCancellable?
    
    private let locationManager = CLLocationManager()

    override init() {
        completer = MKLocalSearchCompleter()
        completer.resultTypes = .address
        
        super.init()
        completer.delegate = self
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        //self.locationManager.startUpdatingLocation()

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
            let isEventDetailsPage: Binding = .constant(true)
            request.region = MapViewModel(checkPoint: $checkPoint, isEventDetailsPage: isEventDetailsPage).mapView.region
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
    self.coordinate = location.coordinate
    print(#line, location)
    
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
