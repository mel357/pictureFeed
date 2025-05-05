//
//  GridCoordinator.swift
//  PictureFeed
//
//  Created by Roman on 05.05.2025.
//

import UIKit

class PictureFeedCoordinator {
    private let navigationController: UINavigationController
    private let viewModel: PictureFeedViewModel

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.viewModel = PictureFeedViewModel()
    }

    func start() {
        let pictureFeedViewController = PictureFeedViewController()
        pictureFeedViewController.viewModel = viewModel
        pictureFeedViewController.delegate = self
        navigationController.pushViewController(pictureFeedViewController, animated: false)
    }
}

extension PictureFeedCoordinator: PictureFeedViewControllerDelegate {
    func didSelectImage(url: String) {
        let imageCoordinator = ImageCoordinator(navigationController: navigationController, imageUrl: url)
        imageCoordinator.start()
    }
}
