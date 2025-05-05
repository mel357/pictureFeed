//
//  ImageCache.swift
//  PictureFeed
//
//  Created by Roman on 05.05.2025.
//

import UIKit

final class ImageCache {
    static let shared = ImageCache()

    private let fileManager = FileManager.default
    private let cacheDirectory: URL

    private init() {
        let urls = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
        cacheDirectory = urls[0].appendingPathComponent("ImageCache")

        if !fileManager.fileExists(atPath: cacheDirectory.path) {
            try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true, attributes: nil)
        }
    }

    func saveImage(_ image: UIImage, forKey key: String) {
        guard let data = image.jpegData(compressionQuality: 0.9) else { return }
        let url = cacheDirectory.appendingPathComponent(key.safeFileName())
        try? data.write(to: url)
    }

    func loadImage(forKey key: String) -> UIImage? {
        let url = cacheDirectory.appendingPathComponent(key.safeFileName())
        guard fileManager.fileExists(atPath: url.path),
              let data = try? Data(contentsOf: url),
              let image = UIImage(data: data) else {
            return nil
        }
        return image
    }

    func clear() {
        try? fileManager.removeItem(at: cacheDirectory)
    }
}

extension String {
    func safeFileName() -> String {
        let allowedCharacters = CharacterSet.alphanumerics.union(.init(charactersIn: "-_."))
        return self.components(separatedBy: allowedCharacters.inverted).joined()
    }
}
