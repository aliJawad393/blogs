//
//  PostsListViewModel.swift
//  BlogsList
//
//  Created by Ali Jawad on 29/05/2021.
//

import Foundation
import Combine
import DataModel

protocol BlogPostsListViewModel {
    var dataItems: CurrentValueSubject <[PostsListPresenter], Never>{get}
    var view: View? {get set}
    var imageSource: ImageRepository {get}
    var searchText: CurrentValueSubject <String, Never>{get set}
    var searchPlaceholder: String {get}
    func load()
    func loadMore()
}

final class BlogPostsListConcreteViewModel: BlogPostsListViewModel {
    let imageSource: ImageRepository
    let searchPlaceholder: String = "Search here"
    let dataItems: CurrentValueSubject<[PostsListPresenter], Never>
    private let dataSource: PostRepository
    private let pageSize = 50
    private var totalPostsCount: Int = 0
    private var networkNotifier: NetworkNotifier
    
    weak var view: View? {
        didSet {
            searchViewModel.view = view
        }
    }
    var searchText = CurrentValueSubject<String, Never>("")
    var cancellable: DataModel.Cancellable?
    private var searchViewModel: BlogPostsSearch
    var subscription: Set<AnyCancellable> = []
    
    //MARK: Init
    init(dataItems: CurrentValueSubject<[PostsListPresenter], Never>,
         dataSource: PostRepository,
         searchViewModel: BlogPostsSearch,
         networkNotifier: NetworkNotifier,
         imageSource: ImageRepository) {
        self.dataSource = dataSource
        self.searchViewModel = searchViewModel
        self.dataItems = dataItems
        self.networkNotifier = networkNotifier
        self.imageSource = imageSource
        searchText
            .debounce(for: .milliseconds(800), scheduler: RunLoop.main) // debounces the string publisher, such that it delays the process of sending request to remote server.
            .removeDuplicates()
            .dropFirst(1)
            .map({[unowned self] (string) -> String? in
                if string.count < 1 {
                    self.searchViewModel.abort()
                    self.load()
                    self.view?.loadingActivity(loading: false)
                    return nil
                }
                
                return string
            }) // prevents sending numerous requests and sends nil if the count of the characters is less than 1.
            .compactMap{ $0 } // removes the nil values so the search string does not get passed down to the publisher chain
            .sink { (_) in
                //
            } receiveValue: { [unowned self] (searchField) in
                self.cancellable?.cancelRequest()
                self.cancellable = nil
                self.view?.loadingActivity(loading: true)
                self.searchViewModel.search(query: searchField)
            }.store(in: &subscription)
        
        self.networkNotifier.whenUnreachable = onNetworkUnreachable
        load()
    }
    
    private init() {
        fatalError("Can't be initialized without required parameters")
    }
    
    func load() {
        view?.loadingActivity(loading: true)
        load(offSet: 0)
    }
    
    func loadMore() {
        if(searchText.value.count > 0) {
            searchViewModel.searchMore()
        } else {
            let currentCount = dataItems.value.map({$0.dataItems.count}).reduce(0, +)
            if(dataItems.value.count < totalPostsCount) {
                load(offSet: currentCount)
            }
        }
    }
    
    //MARK: Private Helpers
    private func load(offSet: Int) {
        cancellable?.cancelRequest()
        cancellable = dataSource.getPosts(offset: offSet, perPage: pageSize, response: {[weak self] response in
            self?.cancellable = nil
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
                
                featuredPosts = offSet > 0 ? (previousFeatured ?? []) + featuredPosts : featuredPosts
                
                if(featuredPosts.count > 0  ) {
                    postsArray.append(PostsListPresenter(title: featuredTitle, dataItems: featuredPosts))
                }
                
                let previousRecents = self?.dataItems.value.filter{
                    $0.title == recentesTitle
                }.first.map{$0.dataItems}
                
                recentPosts = offSet > 0 ?  (previousRecents ?? []) + recentPosts : recentPosts
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
    
    func onNetworkReachale() {
        load()
    }
    
    func onNetworkUnreachable() {
        view?.showError(title: "Error", message: "Internet not available")
        self.networkNotifier.whenReachable = onNetworkReachale
    }
}

