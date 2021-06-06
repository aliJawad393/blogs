//
//  PostDetailViewController.swift
//  BlogsList
//
//  Created by Ali Jawad on 29/05/2021.
//

import Foundation
import UIKit
import Combine
import WebKit

final class PostDetailViewController: UIViewController {
    
    //MARK: Vars
    private let viewModel: PostDetailViewModel
    private var subscriptions = [AnyCancellable]()

    //MARK: UIView Components
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var verticalStack: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .fill
        view.spacing = 20
        view.addArrangedSubview(labelTitle)
        view.addArrangedSubview(imageViewPost)
        view.addArrangedSubview(labelDateTime)
        view.addArrangedSubview(UIView())
        return view
    }()
    private lazy var labelTitle: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        view.font = UIFont.montserratMedium.withSize(20)
        return view
    }()
    private lazy var imageViewPost: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    private lazy var labelDateTime: UILabel = {
        let view = UILabel()
        view.font = UIFont.montserratLight.withSize(15)
        view.textAlignment = .right
        return view
    }()
    
    lazy var loadingIndicatorImage: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(style: .medium)
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.hidesWhenStopped = true
        return indicatorView
    }()
    
    //MARK: Init
    init(viewModel: PostDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    private init() {
        fatalError("Can't be initialized without required parameters")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindViewModel()
        viewModel.load()
    }
    
    //MARK: View Setup
    private func setupView() {
        view.addSubview(scrollView)
        view.addSubview(loadingIndicatorImage)
        view.backgroundColor = .systemBackground
        scrollView.addSubview(verticalStack)
        navigationController?.navigationBar.isHidden = false
         NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            verticalStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            verticalStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            verticalStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 30),
            verticalStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            imageViewPost.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),
            loadingIndicatorImage.centerXAnchor.constraint(equalTo: imageViewPost.centerXAnchor),
            loadingIndicatorImage.centerYAnchor.constraint(equalTo: imageViewPost.centerYAnchor),

        ])
    }
}

extension PostDetailViewController {
    override func loadingActivity(loading: Bool) {
        DispatchQueue.main.async {[unowned self] in
            loading ? self.loadingIndicatorImage.startAnimating() : loadingIndicatorImage.stopAnimating()
        }
    }
    
    override func showError(title: String, message: String) {
        DispatchQueue.main.async {[unowned self] in
            self.loadingIndicatorImage.stopAnimating()
        }
        super.showError(title: title, message: message)
    }
}

//MARK: Bind View Model
private extension PostDetailViewController {
    private func bindViewModel() {
        viewModel.post
            .sink {[weak self] item in
                DispatchQueue.main.async {
                    self?.labelTitle.text = item.title
                    self?.labelDateTime.text = item.date
                    self?.loadImage()
                    //TODO - Later: Load post content (post.description)
                }
            }.store(in: &subscriptions)
    }
}

//MARK: Private Helpers
private extension PostDetailViewController {
    private func loadImage() {
        loadingIndicatorImage.startAnimating()
        viewModel.fetchImage {[weak self] image in
            if let imageData = image.imageData {
                DispatchQueue.main.async {
                    self?.loadingIndicatorImage.stopAnimating()
                    self?.imageViewPost.image = UIImage(data: imageData)
                    
                }
            }
        }
    }
}
