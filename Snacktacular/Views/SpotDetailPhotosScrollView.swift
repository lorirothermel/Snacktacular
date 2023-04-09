//
//  SpotDetailPhotosScrollView.swift
//  Snacktacular
//
//  Created by Lori Rothermel on 4/8/23.
//

import SwiftUI

//struct FakePhoto: Identifiable {
//    let id = UUID().uuidString
//    var imageURLString = "https://firebasestorage.googleapis.com:443/v0/b/snacktacular-b653d.appspot.com/o/QQ7DEGE7lfWQvxsgktLd%2FAC0C88E8-6464-4828-9559-C982D1848EB3.jpeg?alt=media&token=db21cbd8-8f89-4162-9c98-f5b76c42ad53"
//}
//
//let photos = [FakePhoto(), FakePhoto(), FakePhoto(), FakePhoto(), FakePhoto(), FakePhoto(), FakePhoto(), FakePhoto()]



struct SpotDetailPhotosScrollView: View {
    @State private var showPhotoViewerView = false
    @State private var uiImage = UIImage()
    @State private var selectedPhoto = Photo()
    
    var photos: [Photo]
    var spot: Spot
    
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: true) {
            HStack(spacing: 4) {
                ForEach(photos) { photo in
                    let imageURL = URL(string: photo.imageURLString) ?? URL(string: "")
                    AsyncImage(url: imageURL) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 80)
                            .clipped()
                            .onTapGesture {
                                let renderer = ImageRenderer(content: image)
                                selectedPhoto = photo
                                uiImage = renderer.uiImage ?? UIImage()
                                showPhotoViewerView.toggle()
                            }
                    } placeholder: {
                        ProgressView()
                            .frame(width: 80, height: 80)
                    }  // AsyncImage
                }  // ForEach(photos)
            }  // HStack
        }  // ScrollView
        .padding(.horizontal, 4)
        .frame(height: 80)
        .sheet(isPresented: $showPhotoViewerView) {
            PhotoView(photo: $selectedPhoto, uiImage: uiImage, spot: spot)
        }  // .sheet
    }  // some View
}  // SpotDetailPhotosScrollView




struct SpotDetailPhotosScrollView_Previews: PreviewProvider {
    static var previews: some View {
        SpotDetailPhotosScrollView(photos: [Photo(imageURLString: "https://firebasestorage.googleapis.com:443/v0/b/snacktacular-b653d.appspot.com/o/QQ7DEGE7lfWQvxsgktLd%2FAC0C88E8-6464-4828-9559-C982D1848EB3.jpeg?alt=media&token=db21cbd8-8f89-4162-9c98-f5b76c42ad53")], spot: Spot(id: "QQ7DEGE7lfWQvxsgktLd"))
    }
}
