//
//  ImageLoader.swift
//  PictureFeed
//
//  Created by Roman on 05.05.2025.
//

import UIKit

class ImageLoader {
    func loadImages(completion: @escaping ([URL]) -> Void) {
        let url = URL(string: UrlConst.linkUrlsImage)!
        let task = URLSession.shared.dataTask(with: url) { [self] data, _, _ in
            guard let data = data else { return }
            guard let content = String(data: data, encoding: .utf8) else { return }
            let linesArray = content.components(separatedBy: .newlines)
            let imageURLs = linesArray.compactMap { URL(string: $0)}
            let group = DispatchGroup()
            var finalImageURLs: [URL] = imageURLs
            for (index, imgURL) in imageURLs.enumerated() {
                group.enter()
                checkIfImageURL(imgURL) { isImage in
                    if !isImage {
                        if finalImageURLs.count > index {
                            finalImageURLs.remove(at: index)
                        }
                    }
                    group.leave()
                }
            }
            
            group.notify(queue: .main) {
                completion(finalImageURLs)
            }
        }
        task.resume()
    }
    
    func checkIfImageURL(_ url: URL, completion: @escaping (Bool) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "HEAD"

        URLSession.shared.dataTask(with: request) { _, response, _ in
            guard let httpResponse = response as? HTTPURLResponse,
                  let contentType = httpResponse.value(forHTTPHeaderField: "Content-Type") else {
                completion(false)
                return
            }

            completion(contentType.starts(with: "image/"))
        }.resume()
    }

    func loadImage(from url: String, completion: @escaping (UIImage?) -> Void) {
        guard let imageUrl = URL(string: url) else {
            completion(nil)
            return
        }
        let task = URLSession.shared.dataTask(with: imageUrl) { data, _, _ in
            guard let data = data else {
                completion(nil)
                return
            }
            let image = UIImage(data: data)
            completion(image)
        }
        task.resume()
    }
}

