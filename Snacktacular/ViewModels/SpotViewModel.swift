//
//  SpotViewModel.swift
//  Snacktacular
//
//  Created by Lori Rothermel on 4/3/23.
//

import Foundation
import FirebaseFirestore
import UIKit
import FirebaseStorage


@MainActor

class SpotViewModel: ObservableObject {
    @Published var spot = Spot()
    
    
    func saveSpot(spot: Spot) async -> Bool {
        let db = Firestore.firestore()   // Ignore any error that shows up here. Wait for indexing.
        
        if let id = spot.id {  // spot must already exist so save
            do {
                try await db.collection("spots").document(id).setData(spot.dictionary)
                print("😍 Data updated successfully!")
                return true
            } catch {
                print("🤮 ERROR: Could not update data in 'spots' \(error.localizedDescription)")
                return false
            }  // do...catch
        } else {   // no id? Then this must be a new spot to add
            do {
                let documentRef = try await db.collection("spots").addDocument(data: spot.dictionary)
                self.spot = spot
                self.spot.id = documentRef.documentID
                print("🥰 Data added successfully!")
                return true
            } catch {
                print("🤮 ERROR: Could not create a new spot in 'spots' \(error.localizedDescription)")
                return false
            }
        }
    }  // func saveSpot
    
    
    func saveImage(spot: Spot, photo: Photo, image: UIImage) async -> Bool {
        guard let spotID = spot.id else {
            print("🤮 ERROR: spot.id == nil")
            return false
        }
        
        var photoName = UUID().uuidString   // This will be the name of the image file.
        
        if photo.id != nil {          // I have a photo.id so use this as the photoName. This happens if we're updating
            photoName = photo.id!     // an existing Photo's description info. It will re-save the photo.
        }  // if photo.id
        
        let storage = Storage.storage()     // Createa Firebase Storage instance.
        let storageRef = storage.reference().child("\(spotID)/\(photoName).jpeg")
        
        guard let resizedImage = image.jpegData(compressionQuality: 0.2) else {
            print("🤮 ERROR: Could not resize image!")
            return false
        }
                
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"  // Setting metadata allows you to see console image in the web browser. This setting will work for png as well as jpeg.
        
        var imageURLString = ""  // We'll set this after the image is successfully saved.
        
        do {
            let _ = try await storageRef.putDataAsync(resizedImage, metadata: metadata)
            print("📸 Image Saved!")
            do {
                let imageURL = try await storageRef.downloadURL()
                imageURLString = "\(imageURL)"   // We'll save this to Cloud Firestore as part of a document in 'photos' collection, below
            } catch {
                print("🤮 ERROR: Could not get imageURL after saving image - \(error.localizedDescription)")
                return false
            }  // do...catch
        } catch {
            print("🤮 ERROR: Uploading image to FirebaseStorage!")
            return false
        }  // do...catch
        
        // Now save to the "photos" collection of the spot document "spotID"
        let db = Firestore.firestore()
        let collectionString = "spots/\(spotID)/photos"
        
        do {
            var newPhoto = photo
            newPhoto.imageURLString = imageURLString
            try await db.collection(collectionString).document(photoName).setData(newPhoto.dictionary)
            print("😍 Data updated successfully!")
            return true
        } catch {
            print("🤮 ERROR: Could not update data in 'photos' for spotID - \(error.localizedDescription)")
            return false
        }  // do...catch
       
    }  // func saveImage
    
    
}
