//
//  ImageGalleryView.swift
//  SpaceX Buddy
//
//  Created by Jenei Viktor on 2020. 08. 04..
//

import SwiftUI

struct ImageGalleryView: View {
    let imageURLStrings: [String]
    
    var body: some View {
        GeometryReader { geometry in
            TabView {
                ForEach(imageURLStrings, id: \.hash) { urlString in
                    AsyncImageView(url: URL(string: urlString)!)
                }
            }
            .tabViewStyle(PageTabViewStyle())
            .background(Color.black)
        }
    }
}

struct ImageGalleryView_Previews: PreviewProvider {
    static var previews: some View {
        ImageGalleryView(imageURLStrings: [
            "https://live.staticflickr.com/65535/49635401403_96f9c322dc_o.jpg",
            "https://live.staticflickr.com/65535/49636202657_e81210a3ca_o.jpg",
            "https://live.staticflickr.com/65535/49636202572_8831c5a917_o.jpg",
            "https://live.staticflickr.com/65535/49635401423_e0bef3e82f_o.jpg",
            "https://live.staticflickr.com/65535/49635985086_660be7062f_o.jpg"
        ])
    }
}
