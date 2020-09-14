//
//  MapViewModel.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 10.09.2020.
//

import SwiftUI
import MapKit

struct MapView: View {

    //@EnvironmentObject var globalBoolValue: GlobalBoolValue
    @EnvironmentObject var locationSearchService: LocationSearchService
    @State private var moveSearchView = false
    
    var body: some View {
        ZStack {
            
            HStack(alignment: .top) {
                Spacer()
                VStack {

                    Button(action: {
                        self.moveSearchView.toggle()
                    }) {
                        Image(systemName: "doc.text.magnifyingglass")
                        .frame(width: 50, height: 50)
                        .font(.title)
                        .foregroundColor(Color.black)
                        
                    }
                    .background(
                        NavigationLink("", destination: MapSearchView(),
                            isActive: self.$moveSearchView
                        )
                    )
                   

                    Spacer()
                }
            }
            .zIndex(33)
            .padding()

            VStack {
                MapViewModel()
            }
        }
    }
    
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}


protocol HandleMapSearch: class {
    func dropPinZoomIn(placemark: MKPlacemark)
}
