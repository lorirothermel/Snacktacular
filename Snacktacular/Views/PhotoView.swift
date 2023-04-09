//
//  PhotoView.swift
//  Snacktacular
//
//  Created by Lori Rothermel on 4/8/23.
//

import SwiftUI
import Firebase


struct PhotoView: View {
    @Binding var photo: Photo
    
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject var spotVM: SpotViewModel
    
    
    var uiImage: UIImage
    var spot: Spot
    
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                
                Spacer()
                
                TextField("Description", text: $photo.description)
                    .textFieldStyle(.roundedBorder)
                    .disabled(!(Auth.auth().currentUser?.email == photo.reviewer))
                
                Text("by: \(photo.reviewer) on: \(photo.postedOn.formatted(date: .numeric, time: .omitted))")
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
            }  // VStack
            .padding()
            .toolbar {
                if Auth.auth().currentUser?.email == photo.reviewer {
                    // Image was posted by current user
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            dismiss()
                        }  // Button - Cancel
                    }  // ToolbarItem
                    ToolbarItem(placement: .automatic) {
                        Button("Save") {
                            Task {
                                let success = await spotVM.saveImage(spot: spot, photo: photo, image: uiImage)
                                
                                if success {
                                    dismiss()
                                }  // if success
                            }  // Task
                        }  // Button - Save
                    }  // ToolbarItem
                } else {
                    // Image was NOT posted by current user.
                    ToolbarItem(placement: .automatic) {
                        Button("Done") {
                            dismiss()
                        }  // Button
                    }  // ToolbarItem
                }  // if statement Auth.auth()
            }  // .toolbar
        }  // NavigationStack
    }  // some View
}  // PhotoView



struct PhotoView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoView(photo: .constant(Photo()), uiImage: UIImage(named: "pizza") ?? UIImage(), spot: Spot())
            .environmentObject(SpotViewModel())
    }
}

