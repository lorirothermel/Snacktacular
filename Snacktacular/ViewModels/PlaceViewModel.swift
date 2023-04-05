//
//  PlaceViewModel.swift
//  PlaceLookupDemo
//
//  Created by Lori Rothermel on 4/3/23.
//

import Foundation
import MapKit

class PlaceViewModel: ObservableObject {
    @Published var places: [Place] = []
    
    func search(text: String, region: MKCoordinateRegion) {
        let searchRequest = MKLocalSearch.Request()
        
        searchRequest.naturalLanguageQuery = text
        searchRequest.region = region
        
        let search = MKLocalSearch(request: searchRequest)
        
        search.start { response, error in
            guard let response = response else {
                print("🤮 ERROR: \(error?.localizedDescription ?? "Unknown Error")")
                return
            }  // guard let response
            self.places = response.mapItems.map(Place.init)
                
        }  // search.start
    }  // func search
}  // class search
