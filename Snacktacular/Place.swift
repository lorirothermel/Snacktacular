//
//  Place.swift
//  PlaceLookupDemo
//
//  Created by Lori Rothermel on 4/3/23.
//

import Foundation
import MapKit



struct Place: Identifiable {
    let id = UUID().uuidString
    private var mapItem: MKMapItem
    
    init(mapItem: MKMapItem) {
        self.mapItem = mapItem
    }
    
    var name: String {
        self.mapItem.name ?? ""
    }
    
    var address: String {
        let placemark = self.mapItem.placemark
        var cityAndState = ""
        var address = ""
        
        cityAndState = placemark.locality ?? ""  // City
        if let state = placemark.administrativeArea {
            // Show either state or city, state
            cityAndState = cityAndState.isEmpty ? state : "\(cityAndState), \(state)"
        }  // if let state
        
        address = placemark.subThoroughfare ?? ""   // Address number
        
        if let street = placemark.thoroughfare {
            // Just show the street unless there is a street number then add space plus street
            address = address.isEmpty ? street : "\(address) \(street)"
        }
        
        if address.trimmingCharacters(in: .whitespaces).isEmpty && !cityAndState.isEmpty {
            // No address? Then just cityAndState with no space
            address = cityAndState
        } else {
            // No cityAndState? Then just address, otherwise cityAndState
            address = cityAndState.isEmpty ? address : "\(address), \(cityAndState)"
        }
        
        return address
    }  // var address
    
    var latitude: CLLocationDegrees {
        self.mapItem.placemark.coordinate.latitude
    }
    
    var longitude: CLLocationDegrees {
        self.mapItem.placemark.coordinate.longitude
    }
    
    
}
