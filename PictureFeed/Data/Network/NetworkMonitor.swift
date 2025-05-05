//
//  NetworkMonitor.swift
//  PictureFeed
//
//  Created by Roman on 05.05.2025.
//

import Network

final class NetworkMonitor {
    static let shared = NetworkMonitor()

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitorQueue")

    var isConnected: Bool = false {
        didSet {
            if isConnected && !oldValue {
                onReconnect?()
            }
        }
    }

    var onReconnect: (() -> Void)?

    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
        }
        monitor.start(queue: queue)
    }
}

