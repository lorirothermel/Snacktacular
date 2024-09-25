//
//  LocationManager.swift
//  PlaceLookupDemo
//
//  Created by Lori Rothermel on 9/24/24.
//

import Foundation
import MapKit

@MainActor
class LocationManager: NSObject, ObservableObject {
    @Published var location: CLLocation?
    @Published var region = MKCoordinateRegion()
    
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation() // Remember to update Info.plist!
        locationManager.delegate = self
    }  // override init()
    
}  // class LocationManager


extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.location = location
        self.region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 5000, longitudinalMeters: 5000)
        
    }  // func locationManager
    
}  // extension LocationManager

