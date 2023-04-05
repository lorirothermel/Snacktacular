//
//  PlaceLookupView.swift
//  PlaceLookupDemo
//
//  Created by Lori Rothermel on 4/3/23.
//

import SwiftUI
import MapKit

struct PlaceLookupView: View {
    @EnvironmentObject var locationManager: LocationManager
    @Environment(\.dismiss) private var dismiss
    
    @StateObject var placeVM = PlaceViewModel()
    @State private var searchText = ""
    
    @Binding var spot: Spot
    
       
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
                    spot.name = place.name
                    spot.address = place.address
                    spot.latitude = place.latitude
                    spot.longitude = place.longitude
                    
                    dismiss()
                }  // .onTapGesture
            }  // List
            
            .listStyle(.plain)
            .searchable(text: $searchText)
            .onChange(of: searchText, perform: { text in
                if !text.isEmpty {
                    placeVM.search(text: text, region: locationManager.region)
                } else {
                    placeVM.places = []
                }  // if
            })  // .onChange
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button("Dismiss") {
                        dismiss()
                    }  // Button
                }  // ToolbarItem
            }  // .toolbar
        }  // NavigationStack
    }  // some View
}  // PlaceLookupView

struct PlaceLookupView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceLookupView(spot: .constant(Spot()))
            .environmentObject(LocationManager())
    }
}
