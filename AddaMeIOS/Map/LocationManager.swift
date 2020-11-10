//
//  LocationManager.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 07.11.2020.
//

import Foundation
import CoreLocation

final class LocationManager: NSObject, ObservableObject {
  
  var locationManager = CLLocationManager()
  lazy var geocoder = CLGeocoder()
  var regionName = ""

  @Published var locationString = ""
  @Published var currentEventPlace = EventPlace.defualtInit
  @Published var inRegion = false
  @Published var locationPermissionStatus = true
  @Published var currentCoordinate: CLLocation = CLLocation(latitude: 59.9311, longitude: 30.3609)
  // +60.02055266,+30.38777389
  var currentCLLocation: CLLocation?
  
  override init() {
    super.init()
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.requestWhenInUseAuthorization()
    //locationManager.allowsBackgroundLocationUpdates = true
  }
  
  func startLocationServices() {
    if locationManager.authorizationStatus == .authorizedAlways || locationManager.authorizationStatus == .authorizedWhenInUse {
      locationManager.startUpdatingLocation()
    } else {
      locationManager.requestWhenInUseAuthorization()
    }
  }
  
  func fetchAddress(for place: EventPlace) {
    
    guard locationPermissionStatus else {
      return
    }
    

    geocoder.reverseGeocodeLocation(place.location) { [weak self] placemarks, error in
      if let error = error {
        fatalError(error.localizedDescription)
      }
      guard let placemark = placemarks?.first else { return }
      
      if let placemarkLocation = placemark.location {
        self?.currentEventPlace.coordinates = [placemarkLocation.coordinate.latitude, placemarkLocation.coordinate.longitude]
      } else {
        debugPrint(#line, "placemark.location missing")
      }
      
      
      if let streetNumber = placemark.subThoroughfare,
         let street = placemark.thoroughfare,
         let city = placemark.locality,
         let state = placemark.administrativeArea {
        DispatchQueue.main.async {
          self?.currentEventPlace.addressName = "\(streetNumber) \(street) \(city), \(state)"
        }
      } else if let city = placemark.locality, let state = placemark.administrativeArea {
        DispatchQueue.main.async {
          self?.currentEventPlace.addressName = "\(city), \(state)"
        }
      } else {
        DispatchQueue.main.async {
          self?.currentEventPlace.addressName = "Address Unknown"
        }
      }
    }
  }
  
//  func setupMonitoring(for places: [EventPlace]) {
//    if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
//      for place in places {
//        let region = CLCircularRegion(center: place.location.coordinate, radius: 500, identifier: place.addressName)
//        region.notifyOnEntry = true
//        locationManager.startMonitoring(for: region)
//      }
//    }
//  }
  
}

extension LocationManager: CLLocationManagerDelegate {
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    if locationManager.authorizationStatus == .authorizedAlways || locationManager.authorizationStatus == .authorizedWhenInUse {
      locationManager.startUpdatingLocation()
      locationPermissionStatus = true
    } else {
      locationPermissionStatus = false
    }
  }

  func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
    inRegion = true
    regionName = region.identifier
    locationManager.stopMonitoring(for: region)
  }

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let latest = locations.first else { return }
//    if previousLocation == nil {
//      previousLocation = latest
//    } else {
//      let distanceInMeters = previousLocation?.distance(from: latest) ?? 0
//      previousLocation = latest
//      locationString = "You are \(Int(distanceInMeters)) meters from your start point."
//    }
    print(latest)
    //let distanceInMeters = currentCoordinate?.distance(from: latest) ?? 0
    currentCoordinate = latest
    currentCLLocation = latest
  }

  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    guard let clError = error as? CLError else { return }
    switch clError {
    case CLError.denied:
      print("Access denied")
      locationPermissionStatus = false
    default:
      print("Catch all errors")
    }
  }

  func distance(_ eventLocation: EventPlace) -> String {
    let distance = currentCoordinate.distance(from: eventLocation.location) / 1000
    return String(format: "%.01f km ", distance)
  }
}
