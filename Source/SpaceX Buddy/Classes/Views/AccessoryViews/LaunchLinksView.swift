//
//  LaunchLinksView.swift
//  SpaceX Buddy
//
//  Created by Jenei Viktor on 2020. 08. 26..
//

import SwiftUI

struct LaunchLinksView: View {
    var launch: SpaceXBuddy.Launch
    
    var body: some View {
        VStack {
            SingleURLLaunchLinkButton(urlString: launch.links?.webcast, imageName: "youtube")
                .frame(width: 50, height: 50)
            SingleURLLaunchLinkButton(urlString: launch.links?.wikipedia, imageName: "wikipedia")
                .frame(width: 50, height: 50)
            SingleURLLaunchLinkButton(urlString: launch.links?.reddit.campaign, imageName: "reddit")
                .frame(width: 50, height: 50)
            ImageGalleryLaunchLinkButton(imageURLStrings: launch.links?.flickr.original ?? [], imageName: "flickr")
                .frame(width: 50, height: 50)
        }
        .padding(.trailing)
    }
}

protocol LaunchLinkButton {
    var imageName: String {get set}
    var isActive: Bool {get}
}

struct URLLinkHighligter : ViewModifier {
    var isActive : Bool
    
    var grayScaleValue : Double {
        if isActive {
            return 0.0
        }
        else {
            return 0.99
        }
    }
    var viewOpacityValue : Double {
        if isActive {
            return 1.0
        }
        else {
            return 0.3
        }
    }
    func body(content: Content) -> some View {
        content
            .grayscale(grayScaleValue)
            .opacity(viewOpacityValue)
    }
}

struct SingleURLLaunchLinkButton : View, LaunchLinkButton {
    var urlString : String?
    var imageName: String
    
    var isActive: Bool {
        urlString != Optional.none
    }
    
    var body: some View {
        Button(action: {
            guard let linkURLString = urlString, let linkURL = URL(string: linkURLString) else {
                SpaceXBuddy.logger.error("[LaunchLinkButton] Cannot create URL for (\(urlString ?? "EMPTY")")
                return
            }
            UIApplication.shared.open(linkURL, options: [:], completionHandler: Optional.none)
        }) {
            Image(imageName)
                .resizable()
                .modifier(URLLinkHighligter(isActive: isActive))
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ImageGalleryLaunchLinkButton : View, LaunchLinkButton {
    var imageURLStrings : [String]
    var imageName: String
    @State var isGalleryShowed : Bool = false
    
    var isActive: Bool {
        imageURLStrings.count > 0
    }
    
    var body: some View {
        Button(action: {
            if imageURLStrings.count > 0 {
                isGalleryShowed = true
            }
        }) {
            Image(imageName)
                .resizable()
                .modifier(URLLinkHighligter(isActive: isActive))
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $isGalleryShowed) {
            ImageGalleryView(imageURLStrings: imageURLStrings)
        }
    }
}
