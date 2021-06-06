//
//  PostDetailViewModel.swift
//  BlogsList
//
//  Created by Ali Jawad on 02/06/2021.
//

import Foundation
import DataModel
import Combine

protocol PostDetailViewModel {
    var view: View? {get set}
    var post: CurrentValueSubject <PostDetailPresenter, Never>{get}
    func fetchImage(completion: @escaping (Image)->())
    func load()
}

final class PostDetailViewModelConcrete: PostDetailViewModel {
    var view: View?
    private let dataSource: PostRepository
    private let postId: Int
    var post: CurrentValueSubject <PostDetailPresenter, Never> = CurrentValueSubject <PostDetailPresenter, Never>(PostDetailPresenter(title: "", date: "", imageUrl: "", description: ""))
    private let imageSource: ImageRepository

    //MARK: Init
    init(postId: Int, dataSource: PostRepository, imageSource: ImageRepository) {
        self.dataSource = dataSource
        self.postId = postId
        self.imageSource = imageSource
    }
    
    private init() {
        fatalError("Can't be initialized without required parameters")
    }

    func load() {
        view?.loadingActivity(loading: true)
        _ = dataSource.getPostDetails(postId: postId, response: {[weak self] (response) in
            self?.view?.loadingActivity(loading: false)
            switch response {
            case .failure(let error):
                self?.view?.showError(title: "Error", message: error.localizedDescription)
            case .success(let post):
                self?.post.send(PostDetailPresenter(title: post.title, date: post.date, imageUrl: post.imageUrl, description: (post.content)))
            }
        })
    }
    
    func fetchImage(completion: @escaping(Image) -> ()) {
        if let url = post.value.imageUrl {
            _ = imageSource.getImageFromURL(url: url, completion: { image in
                completion(image)
            })
        }
    }
}
