//
//  Place.swift
//  PlaceLookupDemo
//
//  Created by Lori Rothermel on 9/24/24.
//

import Foundation
import MapKit

struct Place: Identifiable {
    let id = UUID().uuidString
    private var mapItem: MKMapItem
    
    init(mapItem: MKMapItem) {
        self.mapItem = mapItem
    }  // init
    
    
    var name: String {
        self.mapItem.name ?? ""
    }  // name
    
    var address: String {
        let placemark = self.mapItem.placemark
        var cityAndState = ""
        var address = ""
        
        cityAndState = placemark.locality ?? ""   // City
        
        if let state = placemark.administrativeArea {
            // Show either State or City, State
            cityAndState = cityAndState.isEmpty ? state : "\(cityAndState), \(state)"
        }  // if
        
        address = placemark.subThoroughfare ?? ""  // Address Number
        
        if let street = placemark.thoroughfare {
            // Just show the street unless there is a street number then add a space and street.
            address = address.isEmpty ? street : "\(address) \(street)"
        }  // if
        
        if address.trimmingCharacters(in: .whitespaces).isEmpty && !cityAndState.isEmpty {
            // No address? Then just cityAndState with no space.
            address = cityAndState
        } else {
            // No cityAndState? Then just address, otherwise address, cityAndState.
            address = cityAndState.isEmpty ? address : "\(address), \(cityAndState)"
        }  // if else
        
        return address
    }  // address
    
    
    
    var latitude: CLLocationDegrees {
        self.mapItem.placemark.coordinate.latitude
    }  // latitude
    
    var longitude: CLLocationDegrees {
        self.mapItem.placemark.coordinate.longitude
    }  // longitude
    
}  // struct Place
