//
//  PlaceLookupView.swift
//  PlaceLookupDemo
//
//  Created by Lori Rothermel on 9/24/24.
//

import SwiftUI
import MapKit


struct PlaceLookupView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var locationManager: LocationManager
    @StateObject var placeVM = PlaceViewModel()
    @State private var searchText = ""
    @Binding var returnedPlace: Place
    
    
        
    var body: some View {
        NavigationStack {
            List(placeVM.places) { place in
                VStack(alignment: .leading) {
                    Text(place.name)
                        .font(.title2)
                    Text(place.address)
                        .font(.callout)
                    
                }  // VStack
                .onTapGesture {
                    returnedPlace = place
                    dismiss()
                }  // .onTapGesture
                
            }  // List
            .listStyle(.plain)
            .searchable(text: $searchText)
            .onChange(of: searchText, { text, _ in
                if !text.isEmpty {
                    placeVM.search(text: text, region: locationManager.region)
                } else {
                    placeVM.places = []
                }  // if else
            })  // .onChange
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button("Dismiss") {
                        dismiss()
                    }  // Button - Dismiss
                }  // ToolbarItem
            }  // .toolbar
            
        }  // NavigationStack
        
        
    }  // some View
}  // PlaceLookupView

#Preview {
    PlaceLookupView(returnedPlace: .constant(Place(mapItem: MKMapItem())))
        .environmentObject(LocationManager())
}
