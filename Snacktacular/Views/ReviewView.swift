//
//  ReviewView.swift
//  Snacktacular
//
//  Created by Lori Rothermel on 4/4/23.
//

import SwiftUI

struct ReviewView: View {
    @State var spot: Spot
    @State var review: Review
    
    @Environment(\.dismiss) private var dismiss
    
    @StateObject var reviewVM = ReviewViewModel()
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text(spot.name)
                    .font(.title)
                    .bold()
                    .multilineTextAlignment(.leading)
                .lineLimit(1)
                Text(spot.address)
                    .padding(.bottom)
            }  // VStack
            .padding(.horizontal)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("Click to Rate:")
                .font(.title2)
                .bold()
            
            HStack {
                StarsSelectionView(rating: $review.rating)
                    .overlay {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.black.opacity(0.5), lineWidth: 2)
                            
                    }  // .overlay
            }  // HStack
            .padding(.bottom)
                        
            VStack(alignment: .leading) {
                Text("Review Title")
                    .bold()
                TextField("title", text: $review.title)
                    .textFieldStyle(.roundedBorder)
                    .overlay {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.gray.opacity(0.5), lineWidth: 2)
                    }  // .overlay
                Text("Review")
                    .bold()
                TextField("review", text: $review.body, axis: .vertical)
                    .padding(.horizontal, 6)
                    .textFieldStyle(.roundedBorder)
                    .frame(maxHeight: .infinity, alignment: .topLeading)
                    .overlay {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.gray.opacity(0.5), lineWidth: 2)
                    }  // .overlay
            }  // VStack
            .padding(.horizontal)
            .font(.title2)
            
            Spacer()
        }  // VStack
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }  // Button
            }  // ToolbarItem - Cancel
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    Task {
                        let success = await reviewVM.saveReview(spot: spot, review: review)
                        
                        if success {
                            dismiss()
                        } else {
                            print("🤮 ERROR: Error saving data in ReviewView")
                        }  // if...else
                    }  // Task
                    
                }  // Button
            }  // ToolbarItem - Cancel
            
            
            
        }  // .toolbar
    }  // some View
}  // ReviewView


struct ReviewView_Previews: PreviewProvider {
    
    static var previews: some View {
        NavigationStack {
            ReviewView(spot: Spot(name: "Shake Shack", address: "49 Boyleston St., Chestnut Hill, MA 02467"), review: Review())
        }
    }
}
