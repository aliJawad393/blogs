//
//  BlogPostsListTableViewCell.swift
//  BlogsList
//
//  Created by Ali Jawad on 29/05/2021.
//

import Foundation
import UIKit
import DataModel

final class BlogPostsListTableViewCell: UITableViewCell {
    
    //MARK: Vars
    private var cancellable: Cancellable?
    
    //MARK: UIView Components
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
    lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(style: .medium)
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.hidesWhenStopped = true
        return indicatorView
    }()
    
    //MARK: Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Setup View
    private func setupView() {
        selectionStyle = .none
        contentView.addSubview(verticalStack)
        contentView.addSubview(loadingIndicator)
        NSLayoutConstraint.activate([
            verticalStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            verticalStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            verticalStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            verticalStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            imageViewPost.heightAnchor.constraint(equalToConstant: 200),
            loadingIndicator.centerXAnchor.constraint(equalTo: imageViewPost.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: imageViewPost.centerYAnchor),
        ])
    }
    
    //MARK: Internal Methods
    func setData(data: PostsListPresenter.DataItem) {
        labelTitle.text = data.title
        labelDateTime.text = data.date
        imageViewPost.image = nil
    }
    
    func setImage(url: URL?, imageSource: ImageRepository?) {
        cancellable?.cancelRequest()
        
        if let url = url, let imageSource = imageSource {
            loadingIndicator.startAnimating()
            cancellable = imageSource.getImageFromURL(url: url) {[weak self] image in
                DispatchQueue.main.async {
                    self?.loadingIndicator.stopAnimating()
                    guard let imageData = image.imageData else {
                        self?.imageViewPost.image = nil
                        return
                    }
                    self?.imageViewPost.image = UIImage(data: image.imageData ?? imageData)

                }
            }

        }
    }
}

////MARK: Image Download
//
//private final class ImageDownloadOperation: Operation {
//    let url: URL
//    let completion: (UIImage?) -> ()
//
//    init(url: URL, completion: @escaping (UIImage?) -> ()) {
//        self.url = url
//        self.completion = completion
//        super.init()
//    }
//
//    override func main() {
//        if let cachedImage = ImageCache.shared.object(forKey: url.absoluteString as NSString) {
//            completion(cachedImage)
//            return
//        }
//        if isCancelled { return }
//        let data = try? Data(contentsOf: url)
//        guard let imageData = data else {return}
//        let image = UIImage(data: imageData)
//        if let image = image {
//            ImageCache.shared.setObject(image, forKey: url.absoluteString as NSString)
//        }
//
//        if isCancelled {return}
//        completion(image)
//    }
//}
