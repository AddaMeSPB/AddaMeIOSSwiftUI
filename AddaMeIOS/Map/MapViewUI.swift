//
//  MapViewUI.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 07.11.2020.
//

import SwiftUI
import MapKit

final class WrappedMap: MKMapView {
  
  var onLongPress: (CLLocationCoordinate2D) -> Void = { _ in }
  
  init() {
    super.init(frame: .zero)
    let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
    gestureRecognizer.minimumPressDuration = 0.09
    addGestureRecognizer(gestureRecognizer)
  }
  
  @objc func handleTap(sender: UILongPressGestureRecognizer) {
    if sender.state == .began {
      let location = sender.location(in: self)
      let coordinate = convert(location, toCoordinateFrom: self)
      onLongPress(coordinate)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

struct MapViewUI: UIViewRepresentable {
  
  @State private var annotation = MKPointAnnotation()
  @State private var place = EventResponse.Item.defint
  @State private var places: [EventResponse.Item]
  
  let mapViewType: MKMapType
  let isEventDetailsView: Bool
  var mapView = WrappedMap()
  
  private var eventPlaceBinding: Binding<EventResponse.Item> {
    Binding<EventResponse.Item>(
      get: { return place },
      set: { newString in place = newString }
    )
  }
  
  init(place: EventResponse.Item, places: [EventResponse.Item], mapViewType: MKMapType, isEventDetailsView: Bool ) {
    _place = State(initialValue: place)
    _places = State(initialValue: places)
    self.mapViewType = mapViewType
    self.isEventDetailsView = isEventDetailsView
  }
  
  func makeUIView(context: Context) -> MKMapView {

    mapView.setRegion(place.region, animated: true)
    mapView.mapType = mapViewType
    
    if isEventDetailsView {
      mapView.isZoomEnabled = false
      mapView.isScrollEnabled = false
    }
    
    mapView.isRotateEnabled = false
    mapView.addAnnotations(places)
    mapView.delegate = context.coordinator
    let categories: [MKPointOfInterestCategory] = [
      .restaurant, .nightlife, .park, .nationalPark,
      .hotel, .movieTheater, .foodMarket
    ]
    let filter = MKPointOfInterestFilter(including: categories)
    mapView.pointOfInterestFilter = filter
    
    mapView.onLongPress = addAnnotation(for:)
    
    return mapView
    
  }
  
  func updateUIView(_ uiView: MKMapView, context: Context) {
    mapView.mapType = mapViewType
    
    uiView.removeAnnotations(uiView.annotations)
    uiView.addAnnotation(place)
    
  }
  
  func addAnnotation(for coordinate: CLLocationCoordinate2D) {
    let newAnnotation = MKPointAnnotation()

    newAnnotation.coordinate = coordinate
    annotation = newAnnotation

    let location = CLLocation(
      latitude: newAnnotation.coordinate.latitude,
      longitude: newAnnotation.coordinate.longitude
    )

    addAnnotationPin(forLocation: location)
    
  }

  private func addAnnotationPin(forLocation location: CLLocation) {

    self.place.coordinates = [location.coordinate.latitude, location.coordinate.longitude]

    let geocoder = CLGeocoder()
    annotation = MKPointAnnotation(__coordinate: location.coordinate)
  
    geocoder.reverseGeocodeLocation(location) { placemarks, error in
      if let error = error {
        fatalError(error.localizedDescription)
      }
      guard let placemark = placemarks?.first else { return }
      
      if let placemarkLocation = placemark.location {
        self.place.coordinates = [placemarkLocation.coordinate.latitude, placemarkLocation.coordinate.longitude]
      } else {
        debugPrint(#line, "placemark.location missing")
      }
      
      if let streetNumber = placemark.subThoroughfare,
         let street = placemark.thoroughfare,
         let city = placemark.locality,
         let state = placemark.administrativeArea {
        DispatchQueue.main.async {
          self.place.addressName = "\(streetNumber) \(street) \(city), \(state)"
          self.place.details = "\(streetNumber) \(street) \(city), \(state)"
        }
      } else if let city = placemark.locality, let state = placemark.administrativeArea {
        DispatchQueue.main.async {
          self.place.addressName = "\(city), \(state)"
          self.place.details = "\(city), \(state)"
        }
      } else {
        DispatchQueue.main.async {
          self.place.addressName = "Address Unknown"
        }
      }
    }
    
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
          if let place = clusterAnnotation as? EventResponse.Item {
            if place.sponsored {
              cluster.title = place.addressName
              break
            }
          }
        }
        annotationView.titleVisibility = .visible
        return annotationView
      case let placeAnnotation as EventResponse.Item:
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "InterestingPlace") as? MKMarkerAnnotationView ?? MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "Interesting Place")
        annotationView.canShowCallout = true
        annotationView.glyphText = "○🧘🏻‍♂️○"
        annotationView.clusteringIdentifier = "cluster"
        annotationView.markerTintColor = .lightGray
        annotationView.titleVisibility = .visible
        
        if placeAnnotation.imageUrl == "person.fill" {
          //annotationView.detailCalloutAccessoryView = UIImage(named: placeAnnotation.image!).map(UIImageView.init)
        } else {
          let image = placeAnnotation.imageUrl == nil ? UIImage(systemName: "person.fill") : UIImage(named: placeAnnotation.imageUrl!)
          annotationView.detailCalloutAccessoryView = image.map(UIImageView.init) // using ! becz
        }
        
        return annotationView
      default: return nil
        
      }
    }
  }
}

struct MapViewUI_Previews: PreviewProvider {
  static var previews: some View {
    MapViewUI(place: eventData[0], places: eventData, mapViewType: .standard, isEventDetailsView: false)
  }
}
