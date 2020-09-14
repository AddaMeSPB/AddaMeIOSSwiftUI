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

//struct SearchBar: View {
//    @Binding var text: String
//    @State private var isEditing = false
//
//    var body: some View {
//        HStack {
//            TextField("Search ...", text: $text)
//                .padding(7)
//                .padding(.horizontal, 25)
//                .cornerRadius(8)
//                .overlay(
//                    HStack {
//                        Image(systemName: "magnifyingglass")
//                            .foregroundColor(.gray)
//                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
//                            .padding(.leading, 8)
//
//                        if isEditing {
//                            Button(action: {
//                                self.text = ""
//                            }) {
//                                Image(systemName: "multiply.circle.fill")
//                                    .foregroundColor(.gray)
//                                    .padding(.trailing, 5)
//                            }
//                        }
//                    }
//                )
//                .padding(.horizontal, 10)
//                .onTapGesture {
//                    self.isEditing = true
//                }
//
//        }
//        .padding(10)
//        .background(Color(.systemGray6))
//        .clipShape(Capsule())
//
////        .padding(.leading, 10)
////        .padding(.trailing, 10)
//    }
//}
//
//struct SearchBar_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchBar(text: .constant(""))
//    }
//}

struct SearchBar: UIViewRepresentable {

    @Binding var text: String

    class Coordinator: NSObject, UISearchBarDelegate {

        @Binding var text: String

        init(text: Binding<String>) {
            _text = text
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
    }

    func makeCoordinator() -> SearchBar.Coordinator {
        return Coordinator(text: $text)
    }

    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.searchBarStyle = .minimal
        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = text
    }
}

class LocationSearchService: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    
    @Published var searchQuery = ""
    @Published var completions: [MKLocalSearchCompletion] = []
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
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()

        cancellable = $searchQuery
            .receive(on: DispatchQueue.main)
            .debounce(for: .milliseconds(350), scheduler: RunLoop.main, options: nil)
            .assign(to: \.queryFragment, on: self.completer)
        
        completer.delegate = self
    }

    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.completions = completer.results
        completer.results.forEach { mKLocalSearchCompletion in
            
            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = mKLocalSearchCompletion.title
            request.region = mapViewModel.mapView.region
            let search = MKLocalSearch(request: request)
            search.start { (response, error) in
                
                guard let response = response else {return}
                self.mapItems = response.mapItems
                print(response.mapItems.map { $0.placemark.formattedAddress })
            
            }
        }
        
        print(completer.results.first?.title)
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
