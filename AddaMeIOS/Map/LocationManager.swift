//
//  LocationManager.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 07.11.2020.
//

import Foundation
import CoreLocation
import SwiftUI
import Combine

final class LocationManager: NSObject, ObservableObject {
  
  var locationManager = CLLocationManager()
  lazy var geocoder = CLGeocoder()
  var regionName = String.empty
  var isEventDetail = false

  @Published var locationString = String.empty
  @Published var currentEventPlace = EventResponse.Item.defint {
    willSet {
      didChange.send(self)
    }
  }
  @Published var inRegion = false
  @Published var locationPermissionStatus = true
  @Published var currentCoordinate: CLLocation? // = CLLocation(latitude: 59.9311, longitude: 30.3609)

  var currentCLLocation: CLLocationCoordinate2D? {
    willSet {
      KeychainService.save(codable: newValue, for: .cllocation2d)
      didChange.send(self)
    }
  }
  
  let didChange = PassthroughSubject<LocationManager,Never>()
  
  override init() {
    super.init()
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.requestWhenInUseAuthorization()
//    locationManager.distanceFilter = 10
    //locationManager.allowsBackgroundLocationUpdates = true
  }

  func startLocationServices() {
    if locationManager.authorizationStatus == .authorizedAlways || locationManager.authorizationStatus == .authorizedWhenInUse {
      locationManager.startUpdatingLocation()
    } else {
      locationManager.requestWhenInUseAuthorization()
    }
  }
  
  func fetchAddress(_ clLocation: CLLocationCoordinate2D? = nil) {

    let location = clLocation == nil ? currentCLLocation : clLocation
    let coordinate = CLLocation(latitude: location!.latitude, longitude: location!.longitude)

    geocoder.reverseGeocodeLocation(coordinate) { [weak self] placemarks, error in
      if let error = error {
        fatalError(error.localizedDescription)
      }
      
      guard let currentEPlace = self?.currentEventPlace ,let placemark = placemarks?.first else {
        return
      }
      
      if let placemarkLocation = placemark.location {
        currentEPlace.coordinates = [placemarkLocation.coordinate.latitude, placemarkLocation.coordinate.longitude]
      } else {
        debugPrint(#line, "placemark.location missing")
      }
      
      if let streetNumber = placemark.subThoroughfare,
         let street = placemark.thoroughfare,
         let city = placemark.locality,
         let state = placemark.administrativeArea {
        let cityState = city == state ? ", \(city)" : "\(city), \(state)"
        DispatchQueue.main.async {
          currentEPlace.addressName = "\(streetNumber) \(street) \(cityState)"
        }
      } else if let city = placemark.locality, let state = placemark.administrativeArea {
        DispatchQueue.main.async {
          currentEPlace.addressName = "\(city), \(state)"
        }
      } else {
        DispatchQueue.main.async {
          currentEPlace.addressName = "Address Unknown"
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
//  func startLocationManager() {
//    if CLLocationManager.locationServicesEnabled() {
//      locationManager.delegate = self
//      locationManager.desiredAccuracy =
//                      kCLLocationAccuracyNearestTenMeters
//      locationManager.startUpdatingLocation()
//      updatingLocation = true
//    }
//  }
//
//  func stopLocationManager() {
//    if updatingLocation {
//      locationManager.stopUpdatingLocation()
//      locationManager.delegate = nil
//      updatingLocation = false
//    }
//  }
  
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
    //print(#line, self, latest)
    //let distanceInMeters = currentCoordinate?.distance(from: latest) ?? 0
//    if let lastLocation = currentCoordinate, let newLocation = locations.first {
//        if (lastLocation.distance(from: newLocation) < manager.distanceFilter) {
//            return
//        }
//    }

    if isEventDetail {
      return
    }
    
    //print("locations \(locations)")

    currentCoordinate = latest
    currentCLLocation = latest.coordinate
    //print(#line, latest)
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

  func distance(_ eventLocation: EventResponse.Item) -> String {
    guard let currentCoordinate = currentCoordinate else {
      print(#line, "Missing currentCoordinate")
      return "Loading Coordinate"
    }
    
    let distance = currentCoordinate.distance(from: eventLocation.location) / 1000
    return String(format: "%.01f km ", distance)
  }
}
