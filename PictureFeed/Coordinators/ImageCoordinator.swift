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

    func start() {
        let imageViewController = ImageViewController(viewModel: viewModel)
        navigationController.pushViewController(imageViewController, animated: false)
    }
}
