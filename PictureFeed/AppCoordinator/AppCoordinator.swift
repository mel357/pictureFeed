//
//  AppCoordinator.swift
//  PictureFeed
//
//  Created by Roman on 05.05.2025.
//

import UIKit

class AppCoordinator {
    private let navigationController: UINavigationController
    private var pictureFeedCoordinator: PictureFeedCoordinator?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        pictureFeedCoordinator = PictureFeedCoordinator(navigationController: navigationController)
        pictureFeedCoordinator?.start()
    }
}
