//
//  LocationServiceModel.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 12.09.2020.
//

import Foundation
import Combine
import MapKit

class LocationServiceModel: NSObject, ObservableObject {
    
    enum LocationStatus: Equatable {
        case idle
        case noResults
        case isSearching
        case error(String)
        case result
    }
    
    @Published var queryFragment: String = ""
    @Published private(set) var status: LocationStatus = .idle
    @Published private(set) var searchResults: [MKLocalSearchCompletion] = []
    @Published private(set) var mapItems: [MKMapItem] = []
    
//    weak var handleMapSearchDelegate: HandleMapSearch?
//    @Published private(set) var matchingItems: [MKMapItem] = []
//    var mapView: MKMapView?
//    @Published var addressName: String = ""
    
    private var queryCancellable: AnyCancellable?
    private let searchCompleter: MKLocalSearchCompleter!
    
    init(searchCompleter: MKLocalSearchCompleter = MKLocalSearchCompleter()) {
        self.searchCompleter = searchCompleter
        super.init()
//        self.mapView = MKMapView()
//        self.searchCompleter.region = self.mapView!.region
        self.searchCompleter.delegate = self
        
        
//        let request = MKLocalSearch.Request()
//        request.naturalLanguageQuery = addressName
//        request.region = mapView!.region
//        let search = MKLocalSearch(request: request)
        
        queryCancellable =  $queryFragment
            .receive(on: DispatchQueue.main)
            // we're debouncing the search, because the search completer is rate limited.
            // feel free to play with the proper value here
            .debounce(for: .milliseconds(250), scheduler: RunLoop.main, options: nil)
            .sink(receiveValue: { fragment in
                self.status = .isSearching
                if !fragment.isEmpty {
                    self.searchCompleter.queryFragment = fragment
                    //self.addressName = fragment
                } else {
                    self.status = .idle
                    self.searchResults = []
                }
        })
    }
}

extension LocationServiceModel: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        // Depending on what you're searching, you might need to filter differently or
        // remove the filter altogether. Filtering for an empty Subtitle seems to filter
        // out a lot of places and only shows cities and countries.
//
//        let searchRequest = MKLocalSearch.Request(completion: completer.results)
//        let search = MKLocalSearch(request: searchRequest)
//        search.startWithCompletionHandler { (response, error) in
//            if error == nil {
//                let coordinate = response?.mapItems[0].placemark.coordinate
//            }
//        }
        
        self.searchResults = completer.results
        self.status = completer.results.isEmpty ? .noResults : .result
        
//        completer.results.forEach { (mKLocalSearchCompletion) in
//            
//                    
//            //        let request = MKLocalSearch.Request()
//            //        request.naturalLanguageQuery = addressName
//            //        request.region = mapView!.region
//            //        let search = MKLocalSearch(request: request)
//            
//            let searchRequest = MKLocalSearch.Request(completion: mKLocalSearchCompletion)
//            searchRequest.naturalLanguageQuery = queryFragment
//            searchRequest.region = MKMapView().region
//            let search = MKLocalSearch(request: searchRequest)
//            search.start { (response, error) in
//                
//                if error != nil {
//                    print(error?.localizedDescription)
//                }
//                
//                guard let response = response else {
//                    return
//                }
//                
//                //let coordinate = response?.mapItems[0].placemark.coordinate
//                self.mapItems = response.mapItems
//            }
//        }
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        self.status = .error(error.localizedDescription)
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

