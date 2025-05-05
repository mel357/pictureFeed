//
//  RetryTapHandler.swift
//  PictureFeed
//
//  Created by Roman on 05.05.2025.
//

import Foundation

final class RetryTapTarget {
    static let shared = RetryTapTarget()
    var handler: (() -> Void)?

    @objc func didTapRetry() {
        handler?()
    }
}
