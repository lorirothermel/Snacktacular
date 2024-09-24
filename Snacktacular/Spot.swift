//
//  Spot.swift
//  Snacktacular
//
//  Created by Lori Rothermel on 9/23/24.
//

import Foundation
import FirebaseFirestore

struct Spot: Identifiable, Codable {
    @DocumentID var id: String?
    
    var name = ""
    var address = ""
    
    var dictionary: [String: Any] {  // String is the key. Any is the value.
        return ["name": name, "address": address]
    }  // dictionary
    
    
    
    
}  // struct Spot

