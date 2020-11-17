////
////  VarticalExample.swift
////  AddaMeIOS
////
////  Created by Saroar Khandoker on 26.10.2020.
////

import SwiftUI
import MapKit

struct MapViewWithAnnotations: View {
    
    var body: some View {
      VStack {
        Spacer()
        Text("Hello")
          .padding([.bottom], 55)
      }
    }
}

struct MapViewWithAnnotations_Previews: PreviewProvider {
    static var previews: some View {
        MapViewWithAnnotations()
            //.environment(\.colorScheme, .dark)
    }
}

