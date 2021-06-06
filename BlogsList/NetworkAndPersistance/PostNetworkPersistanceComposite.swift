//
//  NetworkOrPersistance.swift
//  BlogsList
//
//  Created by Ali Jawad on 03/06/2021.
//

/*
 Fetches data from Primary source, if fails, loads from secondary
 */

import Foundation
import DataModel

final class PostNetworkPersistanceComposite: PostRepository {
    private let primarySource: PostRepository
    private let secondarySource: PostRepository
    public init(primarySource: PostRepository, secondary: PostRepository) {
        self.primarySource = primarySource
        self.secondarySource = secondary
    }
    
    func getPosts(offset: Int, perPage: Int, response: @escaping ((Result<PostResponse, Error>) -> Void)) -> Cancellable? {
        var cancellable: Cancellable?
        cancellable = primarySource.getPosts(offset: offset, perPage: perPage, response: {[weak self] (result) in
            switch result {
            case .failure(_):
                cancellable = self?.secondarySource.getPosts(offset: offset, perPage: perPage, response: response)
            case .success(let posts):
                response(.success(posts))
            }
        })
        return cancellable
    }
    
    func searchPosts(query: String, offset: Int, perPage: Int, response: @escaping ((Result<PostResponse, Error>) -> Void)) -> Cancellable? {
        var cancellable: Cancellable?
        cancellable = primarySource.searchPosts(query: query, offset: offset, perPage: perPage, response: {[weak self] result  in
            switch result {
            case .failure(_):
                cancellable = self?.secondarySource.searchPosts(query: query, offset: offset, perPage: perPage, response: response)
            case .success(let posts):
                response(.success(posts))
            }
        })
        return cancellable
    }
    
    func getPostDetails(postId: Int, response: @escaping ((Result<Post, Error>) -> Void)) -> Cancellable? {
        var cancellable: Cancellable?
        cancellable = primarySource.getPostDetails(postId: postId, response: {[weak self] result in
            switch result {
            case .failure(_):
                cancellable = self?.secondarySource.getPostDetails(postId: postId, response: response)
            case .success(let post):
                response(.success(post))
            }
        })
        return cancellable
    }
}
