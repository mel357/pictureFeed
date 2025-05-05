//
//  PictureFeedCell.swift
//  PictureFeed
//
//  Created by Roman on 05.05.2025.
//

import UIKit

class PictureFeedCell: UICollectionViewCell {
    static let reuseIdentifier = "PictureFeedCell"

    private let imageView: UIImageView

    override init(frame: CGRect) {
        self.imageView = UIImageView(frame: .zero)
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with url: URL) {
        imageView.load(url: url) { [weak self] in
            self?.configure(with: url)
        }
    }
}
