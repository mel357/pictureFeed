//
//  PictureFeedViewController.swift
//  PictureFeed
//
//  Created by Roman on 05.05.2025.
//

import UIKit

protocol PictureFeedViewControllerDelegate: AnyObject {
    func didSelectImage(url: String)
}

class PictureFeedViewController: UIViewController {
    var viewModel: PictureFeedViewModel! {
        didSet {
            viewModel.onUpdate = { [weak self] in
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            }
        }
    }
    
    weak var delegate: PictureFeedViewControllerDelegate?
    private var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        viewModel.loadImages()
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: 100, height: 100)

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PictureFeedCell.self, forCellWithReuseIdentifier: PictureFeedCell.reuseIdentifier)
        view.addSubview(collectionView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension PictureFeedViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PictureFeedCell.reuseIdentifier, for: indexPath) as? PictureFeedCell else {
            return UICollectionViewCell()
        }
        if let url = viewModel.urlForItem(at: indexPath.item) {
            cell.configure(with: url)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imageUrl = viewModel.images[indexPath.row].description
        delegate?.didSelectImage(url: imageUrl)
    }
}
