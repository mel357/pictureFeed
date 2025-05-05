//
//  ImageViewModel.swift
//  PictureFeed
//
//  Created by Roman on 05.05.2025.
//

//import Foundation
import UIKit

class ImageViewModel {
    private let imageLoader: ImageLoader
    private let imageUrl: String

    init(imageUrl: String, imageLoader: ImageLoader = ImageLoader()) {
        self.imageUrl = imageUrl
        self.imageLoader = imageLoader
    }

    func loadImage(completion: @escaping (UIImage?) -> Void) {
        imageLoader.loadImage(from: imageUrl) { image in
            completion(image)
        }
    }
    
    func getImageURL() -> String {
        return imageUrl
    }
}

