//
//  PictureFeedViewModel.swift
//  PictureFeed
//
//  Created by Roman on 05.05.2025.
//

import Foundation
import Network

class PictureFeedViewModel {
    private let imageLoader: ImageLoader
    private let monitor = NWPathMonitor()
    private let monitorQueue = DispatchQueue(label: "NetworkMonitor")
    var images: [URL] = []
    var onUpdate: (() -> Void)?
    private var failedToLoad = false

    init(imageLoader: ImageLoader = ImageLoader()) {
        self.imageLoader = imageLoader
        monitor.pathUpdateHandler = { [weak self] path in
            if path.status == .unsatisfied {
                self?.failedToLoad = true
            }
            
            if path.status == .satisfied, self?.failedToLoad == true {
                self?.loadImages()
            }
        }
        monitor.start(queue: monitorQueue)
    }

    func loadImages() {
        imageLoader.loadImages { [weak self] images in
            DispatchQueue.main.async {
                if images.isEmpty {
                    self?.failedToLoad = true
                } else {
                    self?.images = images
                    self?.failedToLoad = false
                    self?.onUpdate?()
                }
            }
        }
    }
    
    func numberOfItems() -> Int {
        images.count
    }

    func urlForItem(at index: Int) -> URL? {
        guard images.indices.contains(index) else { return nil }
        return images[index]
    }
}

