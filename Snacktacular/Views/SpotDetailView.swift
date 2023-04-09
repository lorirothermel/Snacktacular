//
//  SpotDetailView.swift
//  Snacktacular
//
//  Created by Lori Rothermel on 4/3/23.
//

import SwiftUI
import MapKit
import FirebaseFirestoreSwift
import PhotosUI


struct SpotDetailView: View {
    
    
    enum ButtonPressed {
        case review, photo
    }
    
    
    struct Annotation: Identifiable {
        let id = UUID().uuidString
        var name: String
        var address: String
        var coordinate: CLLocationCoordinate2D
    }
    
    @FirestoreQuery(collectionPath: "spots") var reviews: [Review]   // This variable doesn't have the right path. We'll change it in .onAppear
    @FirestoreQuery(collectionPath: "spots") var photos: [Photo]
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var spotVM: SpotViewModel
    @EnvironmentObject var locationManager: LocationManager
    
    
    @State var spot: Spot
    @State private var showPlaceLookupSheet = false
    @State private var mapRegion = MKCoordinateRegion()
    @State private var annotations: [Annotation] = []
    @State private var showReviewViewSheet = false
    @State private var showSaveAlert = false
    @State private var showingAsSheet = false
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var buttonPressed = ButtonPressed.review
    @State private var uiImageSelected = UIImage()
    @State private var showPhotoViewSheet = false
    @State private var newPhoto = Photo()
    
    
    let regionSize = 500.0
    var previewRunning = false
    
    var avgRating: String {
        guard reviews.count != 0 else {
            return "-.-"
        }  // guard
        
        let averageValue = Double(reviews.reduce(0) {$0 + $1.rating}) / Double(reviews.count)
        return String(format: "%.1f", averageValue)
    }  // avgRating
    
    
    
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
            .frame(height: 250)
            .onChange(of: spot) { _ in
                annotations = [Annotation(name: spot.name, address: spot.address, coordinate: spot.coordinate)]
                mapRegion.center = spot.coordinate
            }
            
            SpotDetailPhotosScrollView(photos: photos, spot: spot)
                        
            HStack {
                Group {
                    Text("Avg. Rating:")
                        .font(.title2)
                        .bold()
                    Text(avgRating)
                        .font(.title)
                        .fontWeight(.black)
                        .foregroundColor(Color("SnackColor"))
                }  // Group
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                
                Spacer()
                
                Group {
                    PhotosPicker(selection: $selectedPhoto, matching: .images, preferredItemEncoding: .automatic) {
                        Image(systemName: "photo")
                        Text("Photo")
                    }
                    .onChange(of: selectedPhoto) { newValue in
                        Task {
                            do {
                                if let data = try await newValue?.loadTransferable(type: Data.self) {
                                    if let uiImage = UIImage(data: data) {
                                        uiImageSelected = uiImage
                                        print("📸 Successfully selected an image!")
                                        newPhoto = Photo()   // Clears out contents if you add more than 1 photo in a row for this spot
                                        buttonPressed = .photo
                                        if spot.id == nil {
                                            showSaveAlert.toggle()
                                        } else {
                                            showPhotoViewSheet.toggle()
                                        }
                                            
                                    }  // if let
                                }  // if let data
                            } catch {
                                print("🤮 ERROR: Selecting image failed - \(error.localizedDescription)")
                            }
                        }
                    }
                    Button(action: {
                        buttonPressed = .review
                        
                        if spot.id == nil {
                            showSaveAlert.toggle()
                        } else {
                            showReviewViewSheet.toggle()
                        }
                    }, label: {
                        Image(systemName: "star.fill")
                        Text("Rate")
                    })  // Button
                }  // Group
                .font(Font.caption)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .buttonStyle(.borderedProminent)
                .bold()
                .tint(Color("SnackColor"))
            }  // HStack
            .padding(.horizontal)
                        
            List {
                Section {
                    ForEach(reviews) { review in
                        NavigationLink {
                            ReviewView(spot: spot, review: review)
                        } label: {
                            SpotReviewRowView(review: review)  // Build a custom cell showing stars, title and body
                        }

                    }
                } header: {

                }
            }  // List
            .listStyle(.plain)
            
            Spacer()
            
        }  // VStack
        .onAppear {
            if !previewRunning && spot.id != nil {   // This is to prevent PreviewProvider error
                $reviews.path = "spots/\(spot.id ?? "")/reviews"
                print("reviews.path -> \($reviews.path)")
                $photos.path = "spots/\(spot.id ?? "")/photos"
                print("photos.path -> \($photos.path)")
            } else {   // spot.id starts out as nil
                showingAsSheet = true
            }
            
            
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
            if showingAsSheet {   // New spot so show Cancel / Save buttons
                if spot.id == nil && showingAsSheet {     // New spot so show Cancel/Save buttons
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            dismiss()
                        }  // Button
                    }  // ToolbarItem - Cancel
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Save") {
                            Task {
                                let success = await spotVM.saveSpot(spot: spot)
                                spot = spotVM.spot
                                
                                if success {
                                    // If we didn't update the path after saving spot, we wouldn't be able to show nwe reviews added
                                    $reviews.path = "spots/\(spot.id ?? "")/reviews"
                                    showReviewViewSheet.toggle()
                                    
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
                } else if showingAsSheet && spot.id != nil {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") {
                            dismiss()
                        }  // Button
                    }  // ToolbarItem
                }  // if
            }   // if showingAsSheet
        }  // .toolbar
        .sheet(isPresented: $showPlaceLookupSheet) {
            PlaceLookupView(spot: $spot)
        }
        .sheet(isPresented: $showReviewViewSheet) {
            NavigationStack {
                ReviewView(spot: spot, review: Review())
            }  // NavigationStack
        }  // .sheet
        .sheet(isPresented: $showPhotoViewSheet) {
            NavigationStack {
                PhotoView(photo: $newPhoto, uiImage: uiImageSelected, spot: spot)
            }  // NavigationStack
        }  // .sheet
        .alert("Can Not Rate Place Unless It Is Saved", isPresented: $showSaveAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Save", role: .none) {
                Task {
                    let success = await spotVM.saveSpot(spot: spot)
                    spot = spotVM.spot
                    
                    if success {
                        $reviews.path = "spots/\(spot.id ?? "")/reviews"
                        $photos.path = "spots/\(spot.id ?? "")/photos"
                        switch buttonPressed {
                            case .review:
                                showReviewViewSheet.toggle()
                            case .photo:
                                showPhotoViewSheet.toggle()
                        }  // switch
                        
                        
                        
                    } else {
                        print("🤮 ERROR: Error saving spot!")
                    }  // if success
                }  // Task
            }  // Button - Save
        } message: {
            Text( "Would you like to save this first so that you can enter a review?")
        }

        
    }  // some View
}  // SpotDetailView

struct SpotDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SpotDetailView(spot: Spot(), previewRunning: true)
                .environmentObject(SpotViewModel())
                .environmentObject(LocationManager())
        }
        
    }
}
