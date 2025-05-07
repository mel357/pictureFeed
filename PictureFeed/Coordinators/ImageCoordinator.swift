//
//  ImageCoordinator.swift
//  PictureFeed
//
//  Created by Roman on 05.05.2025.
//

import UIKit

class ImageCoordinator {
    private let navigationController: UINavigationController
    private let imageUrl: String
    private let viewModel: ImageViewModel

    init(navigationController: UINavigationController, imageUrl: String) {
        self.navigationController = navigationController
        self.imageUrl = imageUrl
        self.viewModel = ImageViewModel(imageUrl: imageUrl)
    }

    func start(imageURLs: [URL], index: Int) {
        let imageViewController = ImageViewController(viewModel: viewModel, imageURLs: imageURLs, initialIndex: index)
        navigationController.pushViewController(imageViewController, animated: true)
    }
}
