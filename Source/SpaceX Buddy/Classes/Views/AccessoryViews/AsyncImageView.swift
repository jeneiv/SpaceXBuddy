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
            if let image = imageLoader.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            else {
                ProgressView()
            }
        }
        .onAppear {
            imageLoader.load()
        }
        .onDisappear {
            imageLoader.cancel()
        }
    }
}

extension AsyncImageView {
    fileprivate struct Cache {
        static let shared = NSCache<NSURL, UIImage>()
    }
    
    fileprivate class Loader : ObservableObject {
        @Published var image : UIImage?
        
        let url : URL?
        
        private static let imageProcessingQueue = DispatchQueue(label: "com.spacexbuddy.imageprocessing")
        private var isLoading = false
        private var cancellable: AnyCancellable?
        
        init(url: URL?) {
            self.url = url
        }
        
        func load() {
            guard let url = url, !isLoading else {
                return
            }
            if let cachedImage = Cache.shared.object(forKey: url as NSURL) {
                image = cachedImage
            }
            else {
                cancellable = URLSession.shared.dataTaskPublisher(for: url)
                    .map { UIImage(data: $0.data) }
                    .replaceError(with: Optional.none)
                    .handleEvents(receiveSubscription: { [weak self] _ in self?.onStart() },
                                  receiveOutput: { [weak self] in self?.addToCache($0) },
                                  receiveCompletion: { [weak self] _ in self?.onFinish() },
                                  receiveCancel: { [weak self] in self?.onFinish() })
                    .subscribe(on: Self.imageProcessingQueue)
                    .receive(on: DispatchQueue.main)
                    .assign(to: \.image, on: self)
            }
        }
        
        private func addToCache(_ image: UIImage?) {
            guard let url = url else {
                return
            }
            if let image = image {
                Cache.shared.setObject(image, forKey: url as NSURL)
            }
        }
        
        func cancel() {
            cancellable?.cancel()
        }
        
        private func onStart() {
            isLoading = true
        }
        
        private func onFinish() {
            isLoading = false
        }
    }
}

struct AsyncImageView_Previews: PreviewProvider {
    static var previews: some View {
        AsyncImageView(url: Optional.none)
    }
}
