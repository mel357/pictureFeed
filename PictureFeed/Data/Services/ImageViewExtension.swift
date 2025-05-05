//
//  ImageViewExtension.swift
//  PictureFeed
//
//  Created by Roman on 05.05.2025.
//

import UIKit

extension UIImageView {
    func load(url: URL, retryHandler: (() -> Void)? = nil) {
        let cache = URLCache.shared
        let request = URLRequest(url: url)

        if let image = ImageCache.shared.loadImage(forKey: url.absoluteString) {
            self.image = image
            return
        }

        if let data = cache.cachedResponse(for: request)?.data,
           let image = UIImage(data: data) {
            self.image = image
            ImageCache.shared.saveImage(image, forKey: url.absoluteString)
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, let response = response, let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    self.image = UIImage(systemName: "arrow.clockwise.circle")
                    self.isUserInteractionEnabled = true
                    let tap = UITapGestureRecognizer(target: RetryTapTarget.shared, action: #selector(RetryTapTarget.shared.didTapRetry))
                    self.addGestureRecognizer(tap)
                    RetryTapTarget.shared.handler = retryHandler
                }
                return
            }

            let cachedData = CachedURLResponse(response: response, data: data)
            cache.storeCachedResponse(cachedData, for: request)

            ImageCache.shared.saveImage(image, forKey: url.absoluteString)

            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
}
