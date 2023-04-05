//
//  StarsSelectionView.swift
//  Snacktacular
//
//  Created by Lori Rothermel on 4/5/23.
//

import SwiftUI

struct StarsSelectionView: View {
    @Binding var rating: Int    // Change this to @Binding after layout is tested.
    
    let highestRating = 5
    let unselected = Image(systemName: "star")
    let selected = Image(systemName: "star.fill")
    let font: Font = .largeTitle
    let fillColor: Color = .red
    let emptyColor: Color = .gray
    
    
    var body: some View {
        HStack {
            ForEach(1...highestRating, id: \.self) { number in
                showStar(for: number)
                    .foregroundColor(number <= rating ? fillColor : emptyColor)
                    .onTapGesture {
                        rating = number
                    }
            }  // ForEach
            .font(font)
        }  // HStack
    }  // some View
    
    
    func showStar(for number: Int) -> Image {
        if number > rating {
            return unselected
        } else {
            return selected
        }  // if number
    }  // func showStar
    
    
    
}  // StarsSelectionView

struct StarsSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        StarsSelectionView(rating: .constant(4))
    }
}
