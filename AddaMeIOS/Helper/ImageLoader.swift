//
//  ImageLoader.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 30.08.2020.
//

import SwiftUI
import Combine
import Foundation

class ImageLoader: ObservableObject {
    
    @Published var image: UIImage?
    private let url: URL
    private var cancellable: AnyCancellable?
    private var cache: ImageCache?
    private(set) var isLodaing = false
    private static let imageProcessingQueue =  DispatchQueue(label: "image-processing")
    
    init(url: URL, cache: ImageCache? = nil) {
        self.url = url
        self.cache = cache
    }
    
    deinit {
        cancellable?.cancel()
    }
    
    func load() {
        
        guard !isLodaing else { return }
        
        if let image = cache?[url] {
            self.image = image
            return
        }
        
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: Self.imageProcessingQueue)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .handleEvents(
                receiveSubscription: { _ in self.onStart() },
                receiveOutput: { self.cache($0) },
                receiveCompletion: { _ in self.onFinished() },
                receiveCancel: { self.onFinished() }
            )
            .receive(on: DispatchQueue.main)
            .assign(to: \.image, on: self)
        
    }
    
    private func onStart() {
        isLodaing = true
    }
    
    private func onFinished() {
        isLodaing = false
    }
    
    private func cache(_ image: UIImage?) {
        image.map { cache?[url] = $0 }
    }
    
    func cancel() {
        cancellable?.cancel()
    }
}
