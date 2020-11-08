//
//  MapViewUI.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 07.11.2020.
//

import SwiftUI
import MapKit

struct MapViewUI: UIViewRepresentable {
  
  let location: EventPlace
  let places: [EventPlace]
  let mapViewType: MKMapType
  
  func makeUIView(context: Context) -> MKMapView {
    let mapView = MKMapView()
    mapView.setRegion(location.region, animated: false)
    mapView.mapType = mapViewType
    mapView.isRotateEnabled = false
    mapView.addAnnotations(places)
    mapView.delegate = context.coordinator
    let categories: [MKPointOfInterestCategory] = [
      .restaurant, .nightlife, .park, .nationalPark,
      .hotel, .movieTheater, .foodMarket
    ]
    let filter = MKPointOfInterestFilter(including: categories)
    mapView.pointOfInterestFilter = filter
    return mapView
  }
  
  func updateUIView(_ mapView: MKMapView, context: Context) {
    mapView.mapType = mapViewType
  }
  
  func makeCoordinator() -> MapCoordinator {
    .init()
  }
  
  
  final class MapCoordinator: NSObject, MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

      switch annotation {
      case let cluster as MKClusterAnnotation:
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "cluster") as? MKMarkerAnnotationView ?? MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "cluster")
        annotationView.markerTintColor = .brown
        for clusterAnnotation in cluster.memberAnnotations {
          if let place = clusterAnnotation as? EventPlace {
            if place.sponsored! { // not ! its normal here becz it by default false
              cluster.title = place.addressName
              break
            }
          }
        }
        annotationView.titleVisibility = .visible
        return annotationView
      case let placeAnnotation as EventPlace:
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "InterestingPlace") as? MKMarkerAnnotationView ?? MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "Interesting Place")
        annotationView.canShowCallout = true
        annotationView.glyphText = "○🧘🏻‍♂️○"
        annotationView.clusteringIdentifier = "cluster"
        annotationView.markerTintColor = UIColor(displayP3Red: 0.082, green: 0.518, blue: 0.263, alpha: 1.0)
        annotationView.titleVisibility = .visible
        
        if placeAnnotation.image == "person.fill" {
          //annotationView.detailCalloutAccessoryView = UIImage(named: placeAnnotation.image!).map(UIImageView.init)
        } else {
          annotationView.detailCalloutAccessoryView = UIImage(named: placeAnnotation.image!).map(UIImageView.init) // using ! becz
        }
        
        return annotationView
      default: return nil
      }
      
    }

  }
  
}
//
//struct MapViewUI_Previews: PreviewProvider {
//  static var previews: some View {
//    MapViewUI()
//  }
//}
