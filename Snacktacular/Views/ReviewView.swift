//
//  ReviewView.swift
//  Snacktacular
//
//  Created by Lori Rothermel on 4/4/23.
//

import SwiftUI
import Firebase


struct ReviewView: View {
    @State var spot: Spot
    @State var review: Review
    @State var postedByThisUser = false
    @State private var rateOrReviewerString = "Click to Rate:"   // Otherwise will say poster e-mail & Date.
    
    
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
            
            Text(rateOrReviewerString)
                .font(postedByThisUser ? .title2 : .subheadline)
                .bold(postedByThisUser)
                .minimumScaleFactor(0.5)
                .lineLimit(1)
                .padding(.horizontal)
            
            HStack {
                StarsSelectionView(rating: $review.rating)
                    .disabled(!postedByThisUser)   // Disable if not posted by this user.
                    .overlay {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.black.opacity(0.5), lineWidth: postedByThisUser ? 2 : 0)
                            
                    }  // .overlay
            }  // HStack
            .padding(.bottom)
                        
            VStack(alignment: .leading) {
                Text("Review Title")
                    .bold()
                TextField("title", text: $review.title)
                    .padding(.horizontal, 6)
                    .overlay {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.gray.opacity(0.5), lineWidth: postedByThisUser ? 2 : 0.3)
                    }  // .overlay
                Text("Review")
                    .bold()
                TextField("review", text: $review.body, axis: .vertical)
                    .padding(.horizontal, 6)
                    .textFieldStyle(.roundedBorder)
                    .frame(maxHeight: .infinity, alignment: .topLeading)
                    .overlay {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.gray.opacity(0.5), lineWidth: postedByThisUser ? 2 : 0.3)
                    }  // .overlay
            }  // VStack
            .disabled(!postedByThisUser)  // Disable if not posted by this user. No editing!
            .padding(.horizontal)
            .font(.title2)
            
            Spacer()
        }  // VStack
        .onAppear {
            if review.reviewer == Auth.auth().currentUser?.email {
                postedByThisUser = true
            } else {
                let reviewPostedOn = review.postedOn.formatted(date: .numeric, time: .omitted)
                rateOrReviewerString = "by: \(review.reviewer) on: \(reviewPostedOn)"
            }
        }  // .onAppear
        .navigationBarBackButtonHidden(postedByThisUser)   // Hide back button if posted by this user.
        .toolbar {
            if postedByThisUser {
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
            }  // if postedByThisUser

            
            
            
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
