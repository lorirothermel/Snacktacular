//
//  SpotDetailView.swift
//  Snacktacular
//
//  Created by Lori Rothermel on 9/23/24.
//

import SwiftUI

struct SpotDetailView: View {
    @EnvironmentObject var spotVM: SpotViewModel
    
    @Environment(\.dismiss) var dismiss
    @State var spot: Spot
    
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
                    .stroke(.gray.opacity(0.75), lineWidth: spot.id == nil ? 2 : 0)
            }  // .overlay
            .padding(.horizontal)
            
            Spacer()
                     
        }  // VStack
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(spot.id == nil)
        .toolbar {
            if spot.id == nil {  //  A new spot so show Cancel / Save buttons.
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }  // Button - Cancel
                }  // ToolbarItem - Cancel
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        Task {
                            let success = await spotVM.saveSpot(spot: spot)
                            
                            if success {
                                dismiss()
                            } else {
                                print("😡 DANG! Error Saving spot!")
                            }  // if else
                        }  // Task
                        dismiss()
                    }  // Button - Save
                }  // ToolbarItem - Save
            }  // if
        }  // .toolbar
        
    }  // some View
    
    
}  // SpotDetailView

#Preview {
    NavigationStack {
        SpotDetailView(spot: Spot())
            .environmentObject(SpotViewModel())
    }  // NavigationStack
}
