//
//  PlaceViewModel.swift
//  PlaceLookupDemo
//
//  Created by Lori Rothermel on 9/24/24.
//

import Foundation
import MapKit

@MainActor
class PlaceViewModel: ObservableObject {
    @Published var places: [Place] = []
    
    func search(text: String, region: MKCoordinateRegion) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = text
        searchRequest.region = region
        
        let search = MKLocalSearch(request: searchRequest)
        
        search.start { response, error in
            guard let response = response else {
                print("😡 ERROR: \(error?.localizedDescription ?? "Unknown Error")")
                return
            }  // guard let
                    
            self.places = response.mapItems.map(Place.init)
            
        }  // search.start
        
        
    }  // func search
    
    
}  // class PlaceViewModel
