//
//  ListView.swift
//  Snacktacular
//
//  Created by Lori Rothermel on 9/23/24.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore



struct ListView: View {
    @FirestoreQuery(collectionPath: "spots") var spots: [Spot]
    @Environment(\.dismiss) private var dismiss
    @State private var sheetIsPresented = false
    
    
    var body: some View {
        
        NavigationStack {
            List(spots) { spot in
                NavigationLink {
                    SpotDetailView(spot: spot)
                } label: {
                    Text(spot.name)
                        .font(.title2)
                }  // NavigationLink
                
            }  // List
            .listStyle(.plain)
            .navigationTitle("Snack Spots")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Sign Out") {
                        do {
                            try Auth.auth().signOut()
                            print("😇 Sign Out Success!")
                            dismiss()
                        } catch {
                            print("👹 SIGN OUT ERROR: Could not Sign Out")
                        }  // do catch
                    }  // Button Sign Out
                }  // ToolbarItem
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        sheetIsPresented.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }  // Button - Plus
                    
                }  // ToolbarItem
                
            }  // .toolbar
            .sheet(isPresented: $sheetIsPresented) {
                NavigationStack {
                    SpotDetailView(spot: Spot())
                }  // NavigationStack
            }  // .sheet
        }  // NavigationStack
        
    }  // some View
    
    
}  // ListView

#Preview {
    NavigationStack {
        ListView()
    }  // NavigationStack
}
