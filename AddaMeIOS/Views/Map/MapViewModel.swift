//
//  MapView.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 10.09.2020.
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

struct MapViewModel: UIViewRepresentable {
    
    @Binding var checkPoint: CheckPoint
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapViewModel
        
        init(_ parent: MapViewModel) {
            self.parent = parent
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    var locationManager = CLLocationManager()
    @State private var annotation = MKPointAnnotation()
    var mapView = WrappedMap()
    
    func setupManager() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
    }
    
    func makeUIView(context: Context) -> MKMapView {
        
        setupManager()
        mapView.showsUserLocation = true
        //mapView.userTrackingMode = .follow
        
        mapView.delegate = context.coordinator
        mapView.onLongPress = addAnnotation(for:)
        
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
        
        uiView.removeAnnotations(uiView.annotations)
        uiView.addAnnotation(annotation)
        
    }
    
    func addAnnotation(for coordinate: CLLocationCoordinate2D) {
        let newAnnotation = MKPointAnnotation()
    
        newAnnotation.coordinate = coordinate
        annotation = newAnnotation
        
        let location = CLLocation(latitude: newAnnotation.coordinate.latitude, longitude: newAnnotation.coordinate.longitude)
        
        addAnnotationPin(forLocation: location, withLocationName: nil)
    }
    
    private func addAnnotationPin(forLocation location: CLLocation, withLocationName locationName: String?) {

        checkPoint = CheckPoint(title: "", coordinate: CLLocationCoordinate2DMake(60.014506, 30.388123))
        
        let geocoder = CLGeocoder()
        annotation = MKPointAnnotation(__coordinate: location.coordinate)
        checkPoint.coordinate = location.coordinate
        if let lName = locationName {
            self.checkPoint.title = lName
            checkPoint = CheckPoint(title: lName, coordinate: location.coordinate)
            print(#line, lName, (annotation.title ?? "missing") as String)
        } else {
            geocoder.reverseGeocodeLocation(location) { placemarks, _ in
                guard let placemark = placemarks?.first else {
                    return
                }
                let lName = placemark.name ?? ""
                
                checkPoint = CheckPoint(title: lName, coordinate: location.coordinate)
                print(#line, lName)
            }
        }
        
    }
}

final class CheckPoint: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String?, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
    }
}

extension CLLocationCoordinate2D {
    var coordinate: [Double] {
        return [self.latitude, self.longitude]
    }
}
