//
//  SpotViewModel.swift
//  Snacktacular
//
//  Created by Lori Rothermel on 9/23/24.
//

import Foundation
import FirebaseFirestore



class SpotViewModel: ObservableObject {
    @Published var spot = Spot()
    
    
    func saveSpot(spot: Spot) async -> Bool {
        let db = Firestore.firestore()
        
        if let id = spot.id {  // spot must already exist so save
            do {
                try await db.collection("spots").document(id).setData(spot.dictionary)
                print("🤠 Data Updated Successfully!")
                return true
            } catch {
                print("😡 ERROR: Could not update data in 'spots' \(error.localizedDescription)")
                return false
            }  // do catch
        } else {   // No id? Then this must be a new spot to add.
            do {
                try await db.collection("spots").addDocument(data: spot.dictionary)
                print("🤠 Data Updated Successfully!")
                return true
            } catch {
                print("😡 ERROR: Could not create a new spot in 'spots' \(error.localizedDescription)")
                return false
            }  // do catch
        }  // if let else
        
        
        
    }  // func saveSpot
    
    
}  // SpotViewModel

