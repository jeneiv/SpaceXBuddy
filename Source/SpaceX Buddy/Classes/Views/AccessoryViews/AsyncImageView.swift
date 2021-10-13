//
//  AsyncImageView.swift
//  SpaceX Buddy
//
//  Created by Jenei Viktor on 2020. 07. 23..
//

import SwiftUI
import Combine

struct AsyncImageView: View {
    @ObservedObject private var imageLoader : Loader
    
    var imageURL : URL?
    
    init(url: URL?) {
        self.imageURL = url
        imageLoader = Loader(url: url)
    }
    
    var body: some View {
        ZStack {
            switch imageLoader.state {
            case .undefined, .failed:
                EmptyView()
            case .loaded(image: let image):
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            case .loading:
                ProgressView()
            }
        }
        .task {
            await imageLoader.loadImage()
        }
    }
}

extension AsyncImageView {
    fileprivate struct Cache {
        static let shared = NSCache<NSURL, UIImage>()
    }
    
    @MainActor
    fileprivate class Loader : ObservableObject {
        enum State {
            case undefined
            case loading
            case loaded(image: UIImage)
            case failed
        }
        
        @Published var state: State = .undefined

        func loadImage() async {
            guard let url = url else {
                return
            }
            if let cachedImage = Cache.shared.object(forKey: url as NSURL) {
                state = .loaded(image: cachedImage)
            } else {
                state = .loading
                do {
                    let (data, _) = try await URLSession.shared.data(from: url)
                    if let image = UIImage(data: data) {
                        addToCache(image)
                        state = .loaded(image: image)
                    } else {
                        state = .failed
                    }
                } catch {
                    state = .failed
                }
            }
        }
        
        let url : URL?
        
        init(url: URL?) {
            self.url = url
        }
        
        private func addToCache(_ image: UIImage) {
            guard let url = url else {
                return
            }
            Cache.shared.setObject(image, forKey: url as NSURL)
        }
    }
}

struct AsyncImageView_Previews: PreviewProvider {
    static var previews: some View {
        AsyncImageView(url: Optional.none)
    }
}
