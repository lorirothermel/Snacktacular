//
//  ListView.swift
//  Snacktacular
//
//  Created by Lori Rothermel on 4/3/23.
//

import SwiftUI
import Firebase


struct ListView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var sheetIsPresented = false
    
    
    var body: some View {
        List {
            Text("List Items will go here")
            Text("LLLLLL")
        }  // List
        .listStyle(.plain)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Sign Out") {
                    do {
                        try Auth.auth().signOut()
                        print("🪵➡️ Log Out Successfull")
                        dismiss()
                    } catch {
                        print("🤮 ERROR: Could not sign out!")
                    }  // do...catch
                }  // Button
            }  // ToolbarItem
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    sheetIsPresented.toggle()
                } label: {
                    Image(systemName: "plus")
                }  // Button
            }  // ToolbarItem
        }  // .toolbar
        .sheet(isPresented: $sheetIsPresented) {
            NavigationStack {
                SpotDetailView(spot: Spot())
            }  // NavigationStack
        }  // .sheet
    }  // some View
}  // ListView

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
           ListView()
        }
       
    }
}
