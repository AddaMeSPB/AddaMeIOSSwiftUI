//
//  MapView.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 10.09.2020.
//

import SwiftUI
import MapKit

//struct MapViewModel: UIViewRepresentable {
//
//  @Binding var eventPlace: EventPlace
//  @Binding var isEventDetailsPage: Bool
//
//  class Coordinator: NSObject, MKMapViewDelegate {
//    var parent: MapViewModel
//
//    init(_ parent: MapViewModel) {
//      self.parent = parent
//    }
//
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//      let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "TESTING NOTE")
//      annotationView.canShowCallout = true
//      annotationView.image = UIImage(systemName: "location.circle")
//
//      return annotationView
//    }
//  }
//
//  func makeCoordinator() -> Coordinator {
//    Coordinator(self)
//  }
//
//  var locationManager = CLLocationManager()
//  @State private var annotation = MKPointAnnotation()
//  var mapView = WrappedMap()
//
//  func setupManager() {
//    locationManager.requestWhenInUseAuthorization()
//    locationManager.requestAlwaysAuthorization()
//  }
//
//  func makeUIView(context: Context) -> MKMapView {
//
//    if !isEventDetailsPage {
//      setupManager()
//      mapView.showsUserLocation = true
//      //mapView.userTrackingMode = .follow
//      mapView.delegate = context.coordinator
//      mapView.onLongPress = addAnnotation(for:)
//
//      return mapView
//
//    } else {
//      let coord = CLLocationCoordinate2D(latitude: checkPoint.coordinate.latitude, longitude: checkPoint.coordinate.longitude)
//      self.georeverseCoordinate(coord) { (pin) in
//        if let pinOK = pin {
//          mapView.removeAnnotation(pinOK)
//
//          let span = MKCoordinateSpan(latitudeDelta: 0.09, longitudeDelta: 0.09)
//          let region = MKCoordinateRegion(center: coord, span: span)
//          mapView.setRegion(region, animated: true)
//          mapView.delegate = context.coordinator
//          mapView.addAnnotation(pinOK)
//        }
//      }
//
//      return mapView
//    }
//
//  }
//
//  static func getPlaceMark(_ coord: CLLocationCoordinate2D, closure: @escaping (CLPlacemark?) -> Void) {
//    let location = CLLocation(latitude: coord.latitude, longitude: coord.longitude)
//    let geocoder = CLGeocoder()
//
//    geocoder.reverseGeocodeLocation(location) { (placeMarksResponse, error) in
//      if let errorTest = error {
//        debugPrint(#line, self, errorTest.localizedDescription)
//        closure(nil)
//        return
//      }
//
//      guard error == nil, let placeMarks = placeMarksResponse, let placeMark = placeMarks.first else {
//        print(#line, self, error as Any)
//        closure(nil)
//        return
//      }
//
//      closure(placeMark)
//    }
//  }
//
//  func georeverseCoordinate(_ coord: CLLocationCoordinate2D, closure:  @escaping (Pin?) -> Void) {
//
//    MapViewModel.getPlaceMark(coord) { placeMark in
//      guard let placeM = placeMark else {
//        closure(nil)
//        return
//      }
//
//      let pin = Pin(
//        title: placeM.name,
//        subtitle: placeM.name,
//        coordinate: placeM.location!.coordinate
//      )
//
//      closure(pin)
//    }
//
//
//  }
//
//  func updateUIView(_ uiView: MKMapView, context: Context) {
//
//    guard let location = locationManager.location else {
//      print(#line, "LocationManager coordinate missing")
//      return
//    }
//
//    uiView.showsUserLocation = true
//
//    if !isEventDetailsPage {
//      let manager = CLLocationManager()
//      switch manager.authorizationStatus {
//      case .authorizedAlways, .authorizedWhenInUse:
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.startUpdatingLocation()
//        let center: CLLocationCoordinate2D = location.coordinate
//        let span = MKCoordinateSpan(latitudeDelta: 0.009, longitudeDelta: 0.009)
//        let region = MKCoordinateRegion(center: center, span: span)
//        uiView.setRegion(region, animated: true)
//      case .restricted, .denied:
//        // need show url for set permission
//        break
//      default:
//        break
//      }
//    } else {
//      let center: CLLocationCoordinate2D = location.coordinate
//      let span = MKCoordinateSpan(latitudeDelta: 0.009, longitudeDelta: 0.009)
//      let region = MKCoordinateRegion(center: center, span: span)
//      uiView.setRegion(region, animated: true)
//    }
//
//    uiView.removeAnnotations(uiView.annotations)
//    uiView.addAnnotation(annotation)
//
//  }
//
//  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//    let accuracyAuthorization = manager.accuracyAuthorization
//    switch accuracyAuthorization {
//    case .fullAccuracy:
//      print(#line, "fullAccuracy")
//      break
//    case .reducedAccuracy:
//      print(#line, "reducedAccuracy")
//      break
//    default:
//      break
//    }
//  }
//
//  func addAnnotation(for coordinate: CLLocationCoordinate2D) {
//    let newAnnotation = MKPointAnnotation()
//
//    newAnnotation.coordinate = coordinate
//    annotation = newAnnotation
//
//    let location = CLLocation(
//      latitude: newAnnotation.coordinate.latitude,
//      longitude: newAnnotation.coordinate.longitude
//    )
//
//    addAnnotationPin(forLocation: location, withLocationName: nil)
//  }
//
//  private func addAnnotationPin(forLocation location: CLLocation, withLocationName locationName: String?) {
//
//    checkPoint = CheckPoint(title: String.empty, coordinate: CLLocationCoordinate2DMake(60.014506, 30.388123))
//
//    let geocoder = CLGeocoder()
//    annotation = MKPointAnnotation(__coordinate: location.coordinate)
//    checkPoint.coordinate = location.coordinate
//    if let lName = locationName {
//      self.checkPoint.title = lName
//      checkPoint = CheckPoint(title: lName, coordinate: location.coordinate)
//      print(#line, lName, (annotation.title ?? "missing") as String)
//    } else {
//      geocoder.reverseGeocodeLocation(location) { placemarks, _ in
//        guard let placemark = placemarks?.first else {
//          return
//        }
//        let lName = placemark.name ?? String.empty
//
//        checkPoint = CheckPoint(title: lName, coordinate: location.coordinate)
//        print(#line, lName)
//      }
//    }
//
//  }
//}

extension CLLocationCoordinate2D {
  var coordinate: [Double] {
    return [self.latitude, self.longitude]
  }
}

extension CLLocationCoordinate2D: Codable {
  public enum CodingKeys: String, CodingKey {
    case latitude
    case longitude
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(latitude, forKey: .latitude)
    try container.encode(longitude, forKey: .longitude)
  }
  
  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    self.init()
    latitude = try values.decode(Double.self, forKey: .latitude)
    longitude = try values.decode(Double.self, forKey: .longitude)
  }
  
}
