//
//  PostNetworkCoreData.swift
//  BlogsList
//
//  Created by Ali Jawad on 03/06/2021.
//

import Foundation
import DataModel
/*
    Fetches posts from server and saves to database
 */

final class PostNetworkPersistanceDecorator: PostRepository {
    private let network: PostRepository
    private let persistance: PostPersistance
    
    init(network: PostRepository, persistance: PostPersistance) {
        self.network = network
        self.persistance = persistance
    }
    
    func getPosts(offset: Int, perPage: Int, response: @escaping ((Result<PostResponse, Error>) -> Void)) -> Cancellable? {
        return network.getPosts(offset: offset, perPage: perPage) {[weak self] result in
            switch result {
            case .failure(let error):
                response(.failure(error))
            case .success(let data):
                if(offset == 0) { // delete all previously saved posts
                    try? self?.persistance.deleteAllPosts()
                }
                self?.persistance.savePosts(data.posts)
                response(.success(data))
            }
        }
        
    }
    
    func searchPosts(query: String, offset: Int, perPage: Int, response: @escaping ((Result<PostResponse, Error>) -> Void)) -> Cancellable? {
        network.searchPosts(query: query, offset: offset, perPage: perPage, response: response)
    }
    
    func getPostDetails(postId: Int, response: @escaping ((Result<Post, Error>) -> Void)) -> Cancellable? {
        network.getPostDetails(postId: postId, response: response)
    }
  
}
