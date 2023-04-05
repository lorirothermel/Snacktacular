//
//  SpotDetailView.swift
//  Snacktacular
//
//  Created by Lori Rothermel on 4/3/23.
//

import SwiftUI
import MapKit

struct SpotDetailView: View {
    
    struct Annotation: Identifiable {
        let id = UUID().uuidString
        var name: String
        var address: String
        var coordinate: CLLocationCoordinate2D
    }
    
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var spotVM: SpotViewModel
    @EnvironmentObject var locationManager: LocationManager
    
    
    @State var spot: Spot
    @State private var showPlaceLookupSheet = false
    @State private var mapRegion = MKCoordinateRegion()
    @State private var annotations: [Annotation] = []
    
    
    let regionSize = 500.0
    
    
    var body: some View {
        VStack {
            Group {
                TextField("Name", text: $spot.name)
                    .font(.title)
                
                TextField("Address", text: $spot.address)
                    .font(.title2)
            }  // Group
            .disabled(spot.id == nil ? false : true)
            .textFieldStyle(.roundedBorder)
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(.gray.opacity(0.5), lineWidth: spot.id == nil ? 2 : 0)
            }  // .overlay
            .padding(.horizontal)
            
            Map(coordinateRegion: $mapRegion, showsUserLocation: true, annotationItems: annotations) { annotation in
                MapMarker(coordinate: annotation.coordinate)
            }
                       
            Spacer()
            
        }  // VStack
        .onAppear {
            if spot.id != nil {  // If we have a spot center map on the spot
                mapRegion = MKCoordinateRegion(center: spot.coordinate, latitudinalMeters: regionSize, longitudinalMeters: regionSize)
            } else {  // otherwise center the map on the device's location
                Task {  // If you don't embed a Task the map likely won't show.
                    mapRegion = MKCoordinateRegion(center: locationManager.location?.coordinate ?? CLLocationCoordinate2D(), latitudinalMeters: regionSize, longitudinalMeters: regionSize)
                }  // Task
            }  // if
            annotations = [Annotation(name: spot.name, address: spot.address, coordinate: spot.coordinate)]
        }  // .onAppear
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(spot.id == nil)
        .toolbar {
            if spot.id == nil {     // New spot so show Cancel/Save buttons
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }  // Button
                }  // ToolbarItem - Cancel
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        Task {
                            let success = await spotVM.saveSpot(spot: spot)
                            if success {
                                dismiss()
                            } else {
                                print("🤮 ERROR: Error saving spot!")
                            }  // if success
                        }  // Task
                        dismiss()
                    }  // Button
                }  // ToolbarItem - Cancel
                
                ToolbarItemGroup(placement: .bottomBar) {
                    Spacer()
                    Button {
                        showPlaceLookupSheet.toggle()
                    } label: {
                        Image(systemName: "magnifyingglass")
                        Text("Lookup Place")
                    }  // Button
                }  // ToolbarItem - Cancel
            }  // if
        }  // .toolbar
        .sheet(isPresented: $showPlaceLookupSheet) {
            PlaceLookupView(spot: $spot)
        }
        
        
    }  // some View
}  // SpotDetailView

struct SpotDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SpotDetailView(spot: Spot())
                .environmentObject(SpotViewModel())
                .environmentObject(LocationManager())
        }
        
    }
}
