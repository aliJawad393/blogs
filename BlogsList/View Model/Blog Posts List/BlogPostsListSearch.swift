//
//  BlogPostsListSearch.swift
//  BlogsList
//
//  Created by Ali Jawad on 02/06/2021.
//

import Foundation
import Combine
import DataModel

protocol BlogPostsSearch {
    var dataItems: CurrentValueSubject <[PostsListPresenter], Never>{get}
    var view: View? {get set}
    func search(query: String)
    func searchMore()
    func abort()
}

final class BlogPostsSearchConcrete: BlogPostsSearch {
    var dataItems: CurrentValueSubject<[PostsListPresenter], Never>
    var view: View?
    private let dataSource: PostRepository
    private var cancellable: DataModel.Cancellable?
    private var query: String?
    private let pageSize = 50
    var totalPostsCount = 0
    
    //MARK: Init
    init(dataItems: CurrentValueSubject<[PostsListPresenter], Never>, dataSource: PostRepository) {
        self.dataItems = dataItems
        self.dataSource = dataSource
    }
    
    private init() {
        fatalError("Can't be initialized without required parameters")
    }
    
    func search(query: String) {
        dataItems.value = []
        search(query: query, offset: 0)
    }
    
    func searchMore() {
        if let query = query {
            let currentCount = dataItems.value.map({$0.dataItems.count}).reduce(0, +)
            if(dataItems.value.count < totalPostsCount) {
                search(query: query, offset: currentCount)
            }
        }
    }
    
    func abort() {
        cancellable?.cancelRequest()
        cancellable = nil
        dataItems.send([])
        totalPostsCount = 0
        query = nil
    }
    
    private func search(query: String, offset: Int = 0) {
        self.query = query
        cancellable?.cancelRequest()
         cancellable = dataSource.searchPosts(query: query, offset: offset, perPage: pageSize, response: {[weak self] response in
            switch response {
            case .success(let successResponse):
                self?.view?.loadingActivity(loading: false)
                let posts = successResponse.posts.map {post in
                    PostsListPresenter.DataItem(id: post.id, date: post.date, imageUrl: post.imageUrl, title: post.title, isFeatured: post.featured)
                }
                self?.totalPostsCount = successResponse.totalPosts
                var featuredPosts = posts.filter {
                    $0.isFeatured
                }
                
                var recentPosts = posts.filter {
                    !$0.isFeatured
                }
                var postsArray: [PostsListPresenter] = []
                let previousFeatured = self?.dataItems.value.filter{
                    $0.title == featuredTitle
                }.first.map{$0.dataItems}
                
                featuredPosts = offset > 0 ? (previousFeatured ?? []) + featuredPosts : featuredPosts
                
                if(featuredPosts.count > 0  ) {
                    postsArray.append(PostsListPresenter(title: featuredTitle, dataItems: featuredPosts))
                }
                
                let previousRecents = self?.dataItems.value.filter{
                    $0.title == recentesTitle
                }.first.map{$0.dataItems}
                
                recentPosts = offset > 0 ?  (previousRecents ?? []) + recentPosts : recentPosts
                if(recentPosts.count > 0) {
                    postsArray.append(PostsListPresenter(title: recentesTitle, dataItems: recentPosts))
                }
                self?.dataItems.send(postsArray)
                
            case .failure(let error):
                if(!((error as NSError).domain == "NSURLErrorDomain" && (error as NSError).code == -999)) {
                    self?.view?.showError(title: "Error", message: error.localizedDescription)
                }
            }
        })
    }
}
