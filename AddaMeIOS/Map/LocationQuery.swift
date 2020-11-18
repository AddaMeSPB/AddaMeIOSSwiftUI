//
//  LocationQuery.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 07.11.2020.
//

import Foundation
import MapKit
import Combine

final class LocationQuery: ObservableObject {

  @Published var searchQuery = String.empty
  @Published private(set) var searchResults: [MKMapItem] = []
  
  private var subscriptions: Set<AnyCancellable> = []
  private let region: MKCoordinateRegion

  init(region: MKCoordinateRegion) {
    self.region = region
    $searchQuery
      .debounce(for: .milliseconds(150), scheduler: RunLoop.main)
      .removeDuplicates()
      .sink { [weak self] value in
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = value
        searchRequest.region = region
        let search = MKLocalSearch(request: searchRequest)
        search.start { response, error in
          guard let response = response else {
            if let error = error {
              print(error.localizedDescription)
            }
            return
          }
          self?.searchResults = response.mapItems
        }
      }
      .store(in: &subscriptions)
  }
}
