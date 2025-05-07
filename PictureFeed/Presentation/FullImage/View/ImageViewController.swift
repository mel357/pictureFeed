//
//  ImageViewController.swift
//  PictureFeed
//
//  Created by Roman on 05.05.2025.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {
    private let viewModel: ImageViewModel
    private let imageView: UIImageView
    private let scrollView: UIScrollView
    private var currentIndex: Int
    private var imageURLs: [URL]

    init(viewModel: ImageViewModel, imageURLs: [URL], initialIndex: Int = 0) {
        self.viewModel = viewModel
        self.imageURLs = imageURLs
        self.currentIndex = initialIndex
        self.imageView = UIImageView(frame: .zero)
        self.scrollView = UIScrollView(frame: .zero)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
        setupImageView()
        configure(with: URL(string: viewModel.getImageURL())!)
        addNavItem()
        setupTapGesture()
        addSwipeGestures()
    }
    
    private func addNavItem() {
        navigationItem.rightBarButtonItems = [
                UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareImage)),
                UIBarButtonItem(title: ImageViewControllerText.browserTitle, style: .plain, target: self, action: #selector(openInBrowser))
            ]
    }
    
    @objc private func openInBrowser() {
        UIApplication.shared.open(URL(string: viewModel.getImageURL())!, options: [:], completionHandler: nil)
    }
    
    @objc private func shareImage() {
        let activityVC = UIActivityViewController(activityItems: [viewModel.getImageURL()], applicationActivities: nil)
        activityVC.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(activityVC, animated: true, completion: nil)
    }
    
    private func configure(with url: URL) {
        self.imageView.load(url: url)
    }
    
    private func setupScrollView() {
        scrollView.delegate = self
        scrollView.maximumZoomScale = 4.0
        scrollView.minimumZoomScale = 1.0
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isScrollEnabled = false
        scrollView.backgroundColor = .systemBackground
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.contentOffset = CGPoint(x: (scrollView.contentSize.width - view.frame.size.width) / 2,
                                           y: (scrollView.contentSize.height - view.frame.size.height) / 2)
    }
    
    private func setupImageView() {
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            imageView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor)
        ])
    }
}

extension ImageViewController {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let offsetX = max((scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5, 0)
        let offsetY = max((scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5, 0)
        imageView.center = CGPoint(x: scrollView.contentSize.width * 0.5 + offsetX,
                                   y: scrollView.contentSize.height * 0.5 + offsetY)
    }
}

extension ImageViewController {
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleFullscreen))
        scrollView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func toggleFullscreen() {
        navigationController?.popToRootViewController(animated: true)
    }
}

extension ImageViewController {
    private func addSwipeGestures() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
    }

    @objc private func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .left {
            showNextImage()
        } else if gesture.direction == .right {
            showPreviousImage()
        }
    }

    private func showNextImage() {
        currentIndex = (currentIndex + 1) % imageURLs.count
        configureWithAnimation(to: currentIndex)
    }

    private func showPreviousImage() {
        currentIndex = (currentIndex - 1 + imageURLs.count) % imageURLs.count
        configureWithAnimation(to: currentIndex)
    }
    
    private func configureWithAnimation(to index: Int) {
        let nextImageURL = imageURLs[index]
        let nextImageView = UIImageView(frame: imageView.frame)
        nextImageView.load(url: nextImageURL)
        nextImageView.contentMode = .scaleAspectFit
        nextImageView.alpha = 0
        
        view.addSubview(nextImageView)
        
        UIView.transition(with: imageView, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.imageView.alpha = 0
        }) { _ in
            self.imageView.image = nextImageView.image
            self.imageView.alpha = 1
            nextImageView.removeFromSuperview()
        }

        currentIndex = index
    }
}
