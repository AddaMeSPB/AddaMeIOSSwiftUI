//
//  MapSearchView.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 12.09.2020.
//

import SwiftUI
import MapKit

struct MapSearchView: View {
    
    @EnvironmentObject var locationSearchService: LocationSearchService
    @EnvironmentObject var eventModel: EventViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Search near me")
                .font(.title)
                .bold()
                .padding()
                .padding(.top, 0)
                .padding(.bottom, -15)
            ZStack(alignment: .trailing) {
                SearchBar(text: $locationSearchService.searchQuery)
                    .padding()
                    .padding(.top, -25)
                if locationSearchService.status == .isSearching {
                    Image(systemName: "clock")
                        .foregroundColor(Color.red)
                        .padding()
                        .padding(.trailing, 25)
                        .padding(.top, -25)
                }
            }
            
            List(locationSearchService.mapItems) { completion in
                Button(action: {
                    
                }) {
                    VStack(alignment: .leading) {
                        Group { () -> AnyView in
                            switch self.locationSearchService.status {
                            case .noResults: return AnyView(Text("No Results"))
                            case .error(let description): return AnyView(Text("Error: \(description)"))
                            default: return AnyView(EmptyView())
                            }
                        }.foregroundColor(Color.gray)
                        Text(completion.placemark.name ?? "")
                        Text(completion.placemark.formattedAddress ?? "")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(.top, -25)
        }
    }
    
}

struct MapSearchView_Previews: PreviewProvider {
    static var previews: some View {
        MapSearchView()
            .environmentObject(LocationSearchService())
    }
}

extension MKMapItem: Identifiable {}
