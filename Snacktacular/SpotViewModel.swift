//
//  SpotViewModel.swift
//  Snacktacular
//
//  Created by Lori Rothermel on 4/3/23.
//

import Foundation
import FirebaseFirestore


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
                _ = try await db.collection("spots").addDocument(data: spot.dictionary)
                print("🥰 Data added successfully!")
                return true
            } catch {
                print("🤮 ERROR: Could not create a new spot in 'spots' \(error.localizedDescription)")
                return false
            }
        }
    }  // func saveSpot
    
    
}
