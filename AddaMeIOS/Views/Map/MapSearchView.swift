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
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $locationSearchService.searchQuery)
                List(locationSearchService.mapItems) { completion in
                    Button(action: {
                        
                    }) {
                        VStack(alignment: .leading) {
                            Text(completion.placemark.name ?? "")
                            Text(completion.placemark.formattedAddress ?? "")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }.navigationBarTitle(Text("Search near me"))
            }
        }
    }
    
}

struct MapSearchView_Previews: PreviewProvider {
    static var previews: some View {
        MapSearchView()
    }
}

extension MKMapItem: Identifiable {}
