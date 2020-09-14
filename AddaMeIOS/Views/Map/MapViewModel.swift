//
//  MapView.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 10.09.2020.
//

import SwiftUI
import MapKit

struct MapViewModel: UIViewRepresentable {
    
    var locationManager = CLLocationManager()
    var mapView = MKMapView(frame: UIScreen.main.bounds)
    
    func setupManager() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
    }
    
    func makeUIView(context: Context) -> MKMapView {
        setupManager()
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.showsUserLocation = true
        let status = CLLocationManager.authorizationStatus()
        
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            let location: CLLocationCoordinate2D = locationManager.location!.coordinate
            let span = MKCoordinateSpan(latitudeDelta: 0.009, longitudeDelta: 0.009)
            let region = MKCoordinateRegion(center: location, span: span)
            uiView.setRegion(region, animated: true)
        }
    }
}

final class CheckPoint: NSObject, MKAnnotation {
    let title: String?
    let coordinate: CLLocationCoordinate2D
    
    init(title: String?, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
    }

}

struct MapViewCheckPoints: UIViewRepresentable {
    @Binding var checkPoints: [CheckPoint]
    
    func makeUIView(context: Context) -> MKMapView {
        MKMapView()
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.addAnnotations(checkPoints)
    }
}
