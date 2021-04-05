//
//  EventViewModel.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 28.08.2020.
//

import Foundation
import Combine
import SwiftUI
import MapKit
import LocationClient
import PathMonitorClient
import EventClient
import KeychainService
import FuncNetworking
import AddaMeModels

//  public var baseURL: URL { URL(string: "http://192.168.1.25:8080/v1/")! }  EnvironmentKeys.rootURL
//  public var baseURL: URL { EnvironmentKeys.rootURL }

public class EventViewModel: ObservableObject {
  
  @AppStorage("isAuthorized") var isAuthorized: Bool = false
  
  @Published var location: CLLocation?
  @Published var isConnected = true
  @Published var isLocationAuthorized = false
  @Published var events: [EventResponse.Item] = []
  @Published var myEvents: [EventResponse.Item] = []
  
  @Published var isLoadingPage = false
  private var currentPage = 1
  private var canLoadMorePages = true
  
  lazy var geocoder = CLGeocoder()
  @Published var currentEventPlace = EventResponse.Item.draff
  
  var createEventCancellable: AnyCancellable?
  var eventsCancellable: AnyCancellable?
  var myEventsCancellable: AnyCancellable?
  var pathUpdateCancellable: AnyCancellable?
  var searchLocationsCancellable: AnyCancellable?
  var locationDelegateCancellable: AnyCancellable?
  
  let pathMonitorClient: PathMonitorClient
  let locationClient: LocationClient
  let eventClient: EventClient
  
  public init(
    locationClient: LocationClient,
    pathMonitorClient: PathMonitorClient,
    eventClient: EventClient
  ) {
    self.locationClient = locationClient
    self.pathMonitorClient = pathMonitorClient
    self.eventClient = eventClient
    
    self.pathUpdateCancellable = self.pathMonitorClient.networkPathPublisher
      .receive(on: DispatchQueue.main)
      .map { $0.status == .satisfied }
      .removeDuplicates()
      .sink(receiveValue: { [weak self] isConnected in
        guard let self = self else { return }
        self.isConnected = isConnected
        if self.isConnected {
          self.fetchMoreEvents()
        } else {
          self.events = []
        }
      })
    
    self.locationDelegateCancellable = self.locationClient.delegate
      .receive(on: DispatchQueue.main)
      .sink { event in
        switch event {
        case let .didChangeAuthorization(status):
          switch status {
          case .notDetermined:
            self.isLocationAuthorized = false
          case .restricted:
            // TODO: show an alert
            self.isLocationAuthorized = false
          case .denied:
            // TODO: show an alert
            self.isLocationAuthorized = false
          case .authorizedAlways, .authorizedWhenInUse:
            self.locationClient.requestLocation()
            self.isLocationAuthorized = true
            
          @unknown default:
            break
          }
          
        case let .didUpdateLocations(locations):
          guard self.isConnected, let location = locations.first else { return }
          self.location = location
          self.fetchMoreEvents()
          self.fetchAddress(location)
          
        case .didFailWithError:
          break
        }
      }
    
    if self.locationClient.authorizationStatus() == .authorizedWhenInUse {
      self.locationClient.requestLocation()
    }
    
  }
  
  private func onStart() {
    isLoadingPage = true
  }
  
  private func onFinished() {
    isLoadingPage = false
  }
  
  func distance(_ eventLocation: EventResponse.Item) -> String {
    guard let currentCoordinate = self.location else {
      print(#line, "Missing currentCoordinate")
      return "Loading Coordinate"
    }

    let distance = currentCoordinate.distance(from: eventLocation.location) / 1000
    return String(format: "%.01f km ", distance)
  }
}

extension EventViewModel {
  
  func locationButtonTapped() {
    switch self.locationClient.authorizationStatus() {
    case .notDetermined:
      self.locationClient.requestWhenInUseAuthorization()
      self.isLocationAuthorized = false
      
    case .restricted:
      // TODO: show an alert
      self.isLocationAuthorized = false
    case .denied:
      // TODO: show an alert
      self.isLocationAuthorized = false
      
    case .authorizedAlways, .authorizedWhenInUse:
      self.locationClient.requestLocation()
      self.isLocationAuthorized = true
      
    @unknown default:
      break
    }
  }
  
  func fetchAddress(_ cllocation: CLLocation? = nil) {
    
    guard let coordinate = cllocation else { return }
    
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
}

extension EventViewModel {
  
  func fetchMoreEventIfNeeded(currentItem item: EventResponse.Item?) {
    
    guard let item = item else {
      fetchMoreEvents()
      return
    }
    
    let threshouldIndex = events.index(events.endIndex, offsetBy: -7)
    if events.firstIndex(where: { $0.id == item.id }) == threshouldIndex {
      fetchMoreEvents()
    }
  }
  
  func fetchMoreMyEventIfNeeded(currentItem item: EventResponse.Item?) {
    guard let item = item else {
      fetchMoreMyEvents()
      return
    }
    
    let threshouldIndex = myEvents.index(myEvents.endIndex, offsetBy: -7)
    if myEvents.firstIndex(where: { $0.id == item.id }) == threshouldIndex {
      fetchMoreMyEvents()
    }
  }
  
  func fetchMoreEvents() {
    
    guard let location = self.location?.coordinate, isAuthorized else { return }
    
    let distance = UserDefaults.standard.double(forKey: "distance") == 0.0 ? 250.0 : UserDefaults.standard.double(forKey: "distance")
    
    let lat = "\(location.latitude)"
    let long = "\(location.longitude)"
    
    guard !isLoadingPage && canLoadMorePages else {
      return
    }
    
    isLoadingPage = true

    let query = QueryItem(page: "\(currentPage)", per: "10", lat: lat, long: long, distance: "\(Int(distance))" )
    
    eventsCancellable = self.eventClient.events(query, "")
      .handleEvents(
        receiveSubscription: { [unowned self] _ in
          isLoadingPage = true
        },
        receiveOutput: { [unowned self] response in
          self.canLoadMorePages = self.events.count < response.metadata.total
          self.isLoadingPage = false
          self.currentPage += 1
        }, receiveCompletion: { [unowned self] _ in
          isLoadingPage = false
        },
        receiveCancel: { [unowned self] in
          isLoadingPage = false
        }
      )
      .retry(3)
      .receive(on: DispatchQueue.main)
      .sink(receiveCompletion: { completionResponse in
        switch completionResponse {
        case .failure(let error):
          print(#line, error)
          self.canLoadMorePages = false
        case .finished:
          break
        }
      }, receiveValue: { [unowned self] res in
        events = (events + res.items )
      })
    
  }
  
  func createEvent(_ event: Event, _ completionHandler: @escaping (Bool) -> Void) {
    
    
    createEventCancellable = self.eventClient.create(event, "")
    .receive(on: RunLoop.main)
    .sink(receiveCompletion: { completionResponse in
      switch completionResponse {
      case .failure(let error):
        print(#line, error)
        self.canLoadMorePages = false
        completionHandler(false)
      case .finished:
        break
      }
    }, receiveValue: {  res in
      print(#line, res)
      completionHandler(true)
    })
    
  }
  
  
  func fetchMoreMyEvents() {
    
    guard !isLoadingPage && canLoadMorePages else {
      return
    }
    
    isLoadingPage = true
        
    let query = QueryItem(page: "\(currentPage)", per: "10")

    // path users/5fabb05d2470c17919b3c0e2
    myEventsCancellable = self.eventClient.events(query, "users")
      .handleEvents(
        receiveSubscription: { [unowned self] _ in
          isLoadingPage = true
        },
        receiveOutput: { [unowned self] response in
          canLoadMorePages = self.myEvents.count < response.metadata.total
          isLoadingPage = false
          currentPage += 1
        }, receiveCompletion: { [unowned self] _ in
          isLoadingPage = false
        },
        receiveCancel: { [unowned self] in
          isLoadingPage = false
        }
      )
      .receive(on: DispatchQueue.main)
      .sink(receiveCompletion: { completionResponse in
        switch completionResponse {
        case .failure(let error):
          print(#line, error)
          self.canLoadMorePages = false
        case .finished:
          break
        }
      }, receiveValue: { [unowned self] res in
        myEvents = (myEvents + res.items)
      })
  }
}

