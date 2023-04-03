//
//  Spot.swift
//  Snacktacular
//
//  Created by Lori Rothermel on 4/3/23.
//

import Foundation
import FirebaseFirestoreSwift

struct Spot: Identifiable, Codable {
    @DocumentID var id: String?
    var name = ""
    var address = ""
    
    var dictionary: [String: Any] {
        return ["name": name, "address": address]
    }
    
    
}
